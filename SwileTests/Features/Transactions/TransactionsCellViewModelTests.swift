//
//  TransactionsViewModelTests.swift
//  SwileTests
//
//  Created by Thomas Fromont on 10/02/2022.
//

import XCTest
import RxSwift
@testable import Swile

class TransactionsViewModelTests: XCTestCase {

    private let disposeBag = DisposeBag()

    func testDelegate() {
        let transaction = Transaction.mock()

        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .rating = cell else {
                return false
            }
            return true
        }

        let expectCells = expectation(description: "Cells should trigger")
        let expectProfile = expectation(description: "Profile delegate method should trigger")
        let expectReply = expectation(description: "Reply delegate method should trigger")

        let delegate = MockRatingsViewModelDelegate(
            onProfile: { someIdentifier in
                XCTAssertEqual(someIdentifier, userIdentifier)
                expectProfile.fulfill()
            },
            onReply: { someRating in
                XCTAssertEqual(someRating.comment, rating.comment)
                expectReply.fulfill()
            }
        )

        let ratingsRepository = mockRatingsRepository(response: ratings)
        let viewModel = buildViewModel(ratingsRepository: ratingsRepository)
        viewModel.delegate = delegate

        var ratingCell: RatingsViewModel.Cell?
        viewModel
            .rx_cells.skip(1)
            .drive(onNext: { cells in
                expectCells.fulfill()
                ratingCell = cells.first(where: { condition($0) })
            })
            .disposed(by: disposeBag)

        viewModel.rx_needsMoreDataObserver.onNext(2)
        wait(for: [expectCells], timeout: XCTestCase.defaultTimeout)

        guard let notNilCell = ratingCell, case .rating(let ratingCellViewModel) = notNilCell else {
                return XCTFail("Wrong cell type")
        }

        ratingCellViewModel.rx_selectProfileObserver.onNext(())
        wait(for: [expectProfile], timeout: XCTestCase.defaultTimeout)

        ratingCellViewModel.rx_selectReplyObserver.onNext(())
        wait(for: [expectReply], timeout: XCTestCase.defaultTimeout)
    }

    func testDelegateContentFailUser() {
        let expectContentFail = expectation(description: "Content Fail method should trigger")

        let delegate = MockRatingsViewModelDelegate(onContentFail: { expectContentFail.fulfill() })

        let response = networkUtilities.mockedResponse(withDataFromFileNamed: "bad-request", code: HTTPStatusCode.badRequest)
        let httpClient = MockHTTPClient(response: response)
        let userRepository = AnyRepository(base: UserRepository(httpClient: httpClient))

        let viewModel = buildViewModel(userRepository: userRepository)
        viewModel.delegate = delegate

        wait(for: [expectContentFail], timeout: XCTestCase.defaultTimeout)
    }

    func testDelegateContentFailRatings() {
        let expectContentFail = expectation(description: "Content Fail method should trigger")

        let delegate = MockRatingsViewModelDelegate(onContentFail: { expectContentFail.fulfill() })

        let response = networkUtilities.mockedResponse(withDataFromFileNamed: "bad-request", code: HTTPStatusCode.badRequest)
        let httpClient = MockHTTPClient(response: response)
        let ratingsRepository = AnyRepository(base: RatingsRepository(httpClient: httpClient))

        let viewModel = buildViewModel(ratingsRepository: ratingsRepository)
        viewModel.delegate = delegate

        viewModel.rx_needsMoreDataObserver.onNext(2)
        wait(for: [expectContentFail], timeout: XCTestCase.defaultTimeout)
    }

    func testLoading() {
        let expectationInitial = self.expectation(description: "initial loading")
        expectationInitial.expectedFulfillmentCount = 2
        let expectationMoreData = self.expectation(description: "refresh loading")
        expectationMoreData.expectedFulfillmentCount = 2

        let viewModel = buildViewModel()

        let expectedLoading = [true, false]
        var recordedInitialLoading = [Bool]()
        var recordedMoreDataLoading = [Bool]()

        viewModel
            .rx_loadingInitial
            .drive(onNext: { loading in
                expectationInitial.fulfill()
                recordedInitialLoading.append(loading)
            })
            .disposed(by: disposeBag)

        viewModel
            .rx_loadingMoreData
            .drive(onNext: { loading in
                expectationMoreData.fulfill()
                recordedMoreDataLoading.append(loading)
            })
            .disposed(by: disposeBag)

        viewModel.rx_needsMoreDataObserver.onNext(2)
        viewModel.rx_needsMoreDataObserver.onNext(20)
        waitForExpectationsWithDefaultTimeout()

        XCTAssertEqual(recordedInitialLoading, expectedLoading)
        XCTAssertEqual(recordedMoreDataLoading, expectedLoading)
    }

    func testLoadsNextPage() {
        let firstPageRatings = Ratings.mock(pagination: Pagination.mock(nextCursor: "cursor"))
        let secondPageRatings = Ratings.mock(pagination: Pagination.mock(nextCursor: nil))
        let ratingsRepository = AnyRepository(base: MockRatingsRepository(
            ratingsForPage: [
                nil: firstPageRatings,
                "cursor": secondPageRatings,
            ]
        ))
        let viewModel = buildViewModel(ratingsRepository: ratingsRepository)

        let expectFirstPage = expectation(description: "Expect to see first page")
        viewModel
            .rx_cells
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .filter { !$0.isEmpty }
            .skip(1)
            .take(1)
            .subscribe(onNext: { _ in
                expectFirstPage.fulfill()
            })
            .disposed(by: disposeBag)

        let expectSecondPage = expectation(description: "Expect to see second page")
        viewModel
            .rx_cells
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .filter { !$0.isEmpty }
            .skip(2)
            .take(1)
            .subscribe(onNext: { _ in
                expectSecondPage.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.rx_needsMoreDataObserver.onNext(2)
        wait(for: [expectFirstPage], timeout: XCTestCase.defaultTimeout)

        viewModel.rx_needsMoreDataObserver.onNext(firstPageRatings.ratings.count + 2)
        wait(for: [expectSecondPage], timeout: XCTestCase.defaultTimeout)
    }

    func testVoiceCell() {
        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .voice = cell else {
                return false
            }
            return true
        }

        if let cell = recordedCell(condition: condition),
            case .voice(let voiceData) = cell {
            XCTAssertEqual(voiceData.title, translationKeys.voice)
        } else {
            XCTFail("Wrong cell type")
        }
    }

    func testNoVoiceCell() {
        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .voice = cell else {
                return false
            }
            return true
        }

        let translationKeys = RatingsTranslationKeys.mock(voice: nil)
        guard recordedCell(ratingsTranslationKeys: translationKeys, condition: condition) == nil else {
            return XCTFail("Should not have voice")
        }
    }

    func testRatingsInfoCell() {
        let ratingCounts = [1, 10]
        let rating = 4.2

        ratingCounts.forEach { ratingCount in
            let user = User.mock(rating: rating, ratingCount: ratingCount)
            let expectedTitle = String(format: translator.translation(for: translationKeys.ratings), String(rating))
            let expectedSubtitle =
                translator.translation(for: translationKeys.ratingsCount, quantity: ratingCount)
            let condition: (RatingsViewModel.Cell) -> Bool = { cell in
                guard case .ratingsInfo(let viewModel) = cell else {
                    return false
                }

                return viewModel.title.contains(expectedTitle)
                    && viewModel.subtitle.contains(expectedSubtitle)
            }

            let cell = recordedCell(user: user, condition: condition)
            if cell == nil, ratingCount > 0 {
                XCTFail("Wrong cell type")
            } else if cell != nil, ratingCount == 0 {
                XCTFail("Wrong cell type")
            }
        }
    }

    func testNoRatingsInfoCell() {
        let ratingCount = 10
        let rating = 4.2

        let user = User.mock(rating: rating, ratingCount: ratingCount)
        let expectedTitle = String(format: translator.translation(for: translationKeys.ratings), String(rating))
        let expectedSubtitle =
            translator.translation(for: translationKeys.ratingsCount, quantity: ratingCount)
        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .ratingsInfo(let viewModel) = cell else {
                return false
            }

            return viewModel.title.contains(expectedTitle)
                && viewModel.subtitle.contains(expectedSubtitle)
        }

        let cell = recordedCell(userIdentifier: nil, user: user, condition: condition)
        guard cell == nil else {
            return XCTFail("Should not have ratings info")
        }
    }

    func testRatingsCountsCell() {
        let ratingOutstanding = RatingCount.mock(rank: .veryHigh, count: 10)
        let ratingExcellent = RatingCount.mock(rank: .high, count: 8)
        let ratingGood = RatingCount.mock(rank: .medium, count: 4)
        let ratingPoor = RatingCount.mock(rank: .low, count: 3)
        let ratingVeryDisapointing = RatingCount.mock(rank: .veryLow, count: 0)
        let ratings = Ratings.mock(ratingCounts: [ratingVeryDisapointing, ratingGood, ratingOutstanding, ratingExcellent, ratingPoor])

        var recordedRatingCounts: [Int] = []
        let expectedRatingCounts = [10, 8, 4, 3, 0]

        Rank.allCases.forEach { rank in
            let expectedSubtitle = String(format: translator.translation(for: rank.titleTranslationKey))
            let condition: (RatingsViewModel.Cell) -> Bool = { cell in
                guard case .ratingsCount(let data) = cell else {
                    return false
                }

                return data.title.contains(expectedSubtitle)
            }

            let cell = recordedCell(ratings: ratings, condition: condition)
            guard let notNilCell = cell,
                case .ratingsCount(let viewModel) = notNilCell else {
                XCTFail("Wrong cell type")
                return
            }

            recordedRatingCounts.append(Int(viewModel.count) ?? -1)
        }

        XCTAssertEqual(recordedRatingCounts, expectedRatingCounts)
    }

    func testNoRatingsCountsCell() {
        let ratings = Ratings.mock(ratingCounts: [])
        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .ratingsCount = cell else {
                return false
            }
            return true
        }

        guard recordedCell(ratings: ratings, condition: condition) == nil else {
            return XCTFail("Should not have rating count")
        }
    }

    func testRatingsCell() {
        let displayName = "displayName"
        let rank: Rank = .high
        let comment = "comment"
        let rating = Rating.mock(rank: rank, comment: comment, userDisplayName: displayName)
        let ratings = Ratings.mock(ratings: [rating])

        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .rating = cell else {
                return false
            }

            return true
        }

        let cell = recordedCell(ratings: ratings, condition: condition)
        guard let notNilCell = cell,
            case .rating(let ratingCellViewModel) = notNilCell else {
                XCTFail("Wrong cell type")
                return
        }

        XCTAssertEqual(ratingCellViewModel.displayName, displayName)
        XCTAssertEqual(ratingCellViewModel.title, rank.titleTranslationKey)
        XCTAssertEqual(ratingCellViewModel.comment, comment)
        XCTAssertNil(ratingCellViewModel.response)
    }

    func testNoRatingsCell() {
        let ratings = Ratings.mock(ratings: [])

        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .voice = cell else {
                return false
            }

            return true
        }

        let cell = recordedCell(ratings: ratings, condition: condition)
        guard let notNilCell = cell,
            case .voice(let voiceCellViewModel) = notNilCell else {
                XCTFail("Wrong cell type")
                return
        }

        XCTAssertEqual(voiceCellViewModel.title, translationKeys.emptyStateTitle)
    }

    func testRatingsWithResponseCell() {
        let userName = "userName"
        let user = User.mock(displayName: userName)
        let displayName = "displayName"
        let rank: Rank = .high
        let comment = "comment"
        let response = "response"
        let rating = Rating.mock(rank: rank, comment: comment, userDisplayName: displayName, response: response)
        let ratings = Ratings.mock(ratings: [rating])

        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .rating = cell else {
                return false
            }

            return true
        }

        let cell = recordedCell(user: user, ratings: ratings, condition: condition)
        guard let notNilCell = cell,
            case .rating(let ratingCellViewModel) = notNilCell else {
                XCTFail("Wrong cell type")
                return
        }

        XCTAssertEqual(ratingCellViewModel.displayName, displayName)
        XCTAssertEqual(ratingCellViewModel.title, rank.titleTranslationKey)
        XCTAssertEqual(ratingCellViewModel.comment, comment)
        XCTAssertNotNil(ratingCellViewModel.response)
        XCTAssertEqual(ratingCellViewModel.response?.title, String(format: translationKeys.responseTitle, user.displayName))
        XCTAssertEqual(ratingCellViewModel.response?.subtitle, response)
    }

    func testRatingsCellDeletedUser() {
        let rating = Rating.mock(userDisplayName: "")
        let ratings = Ratings.mock(ratings: [rating])

        let condition: (RatingsViewModel.Cell) -> Bool = { cell in
            guard case .rating = cell else {
                return false
            }

            return true
        }

        let cell = recordedCell(ratings: ratings, condition: condition)
        guard let notNilCell = cell,
            case .rating(let ratingCellViewModel) = notNilCell else {
                XCTFail("Wrong cell type")
                return
        }

        XCTAssertEqual(ratingCellViewModel.displayName, translationKeys.deletedUser)
    }

    private func recordedCell(userIdentifier: String? = "identifier",
                              user: User = User.mock(),
                              ratings: Ratings = Ratings.mock(),
                              ratingsTranslationKeys: RatingsTranslationKeys? = nil,
                              condition: @escaping (RatingsViewModel.Cell) -> Bool) -> RatingsViewModel.Cell? {
        let expectation = self.expectation(description: "cells")

        let userRepository = mockUserRepository(response: user)
        let ratingsRepository = mockRatingsRepository(response: ratings)
        let viewModel = buildViewModel(userIdentifier: userIdentifier,
                                       userRepository: userRepository,
                                       ratingsRepository: ratingsRepository,
                                       ratingsTranslationKeys: ratingsTranslationKeys)

        var cell: RatingsViewModel.Cell?

        viewModel
            .rx_cells.skip(1)
            .drive(onNext: { cells in
                expectation.fulfill()
                cell = cells.first(where: { condition($0) })
            })
            .disposed(by: disposeBag)

        viewModel.rx_needsMoreDataObserver.onNext(2)
        waitForExpectationsWithDefaultTimeout()

        return cell
    }

    private func mockUserRepository(response: User = User.mock()) -> AnyRepository<User> {
        return AnyRepository(base: MockRepository(value: response))
    }

    private func mockRatingsRepository(response: Ratings = Ratings.mock()) -> AnyRepository<Ratings> {
        return AnyRepository(base: MockRepository(value: response))
    }
}
