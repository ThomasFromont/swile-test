//
//  TransactionDetailsViewController.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

import UIKit
import RxSwift
import RxSwiftExt
import SnapKit

final class TransactionDetailsViewController: UIViewController {

    private enum Constant {
        static let closeButtonInsets = UIEdgeInsets(top: 9, left: 20, bottom: 0, right: 0)
    }

    // MARK: - Properties

    private let viewModel: TransactionDetailsViewModel
    private let styleGuide: StyleGuideType
    private let disposeBag = DisposeBag()

    private let scrollView = UIScrollView()
    private let closeButton = CloseButton()
    private let header = HeaderTransaction()
    private let actionsStackView = UIStackView()

    // MARK: - Initializer

    init(viewModel: TransactionDetailsViewModel, styleGuide: StyleGuideType) {
        self.viewModel = viewModel
        self.styleGuide = styleGuide

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        setupStyle()
        bind()
    }

    // MARK: - Setup

    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(header)
        scrollView.addSubview(closeButton)
        scrollView.addSubview(actionsStackView)
    }

    func setupStyle() {
        view.backgroundColor = styleGuide.colorScheme.background
        actionsStackView.axis = .vertical
    }

    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        header.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.left.right.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(Constant.closeButtonInsets)
        }

        actionsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func bind() {
        header.data = .init(
            title: viewModel.price,
            subtitle: viewModel.name,
            information: viewModel.date,
            tint: viewModel.tint,
            heroSuffix: viewModel.heroSuffix
        )

        viewModel.rx_avatar
            .drive(onNext: { [weak self] avatar in
                self?.header.avatar = avatar
            })
            .disposed(by: disposeBag)

        viewModel.rx_icon
            .drive(onNext: { [weak self] icon in
                self?.header.icon = icon
            })
            .disposed(by: disposeBag)

        closeButton.rx
            .controlEvent(.touchUpInside)
            .bind(to: viewModel.rx_closeObserver)
            .disposed(by: disposeBag)
    }
}
