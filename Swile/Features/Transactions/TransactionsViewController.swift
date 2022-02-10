//
//  TransactionsViewController.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxSwiftExt

class TransactionsViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private let viewModel: TransactionsViewModel
    private let styleGuide: StyleGuide
    private var cells = [TransactionsViewModel.Cell]() {
        didSet {
            tableView.reloadData()
        }
    }

    init(viewModel: TransactionsViewModel, styleGuide: StyleGuide) {
        self.viewModel = viewModel
        self.styleGuide = styleGuide
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        bind()

        viewModel.rx_reloadObserver.onNext(())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        view.backgroundColor = styleGuide.colorScheme.background

        tableView.registerReusable(cellClass: HeaderCell.self)
        tableView.registerReusable(cellClass: SectionCell.self)
        tableView.registerReusable(cellClass: TransactionCell.self)
        tableView.registerReusable(cellClass: SpacingCell.self)

        tableView.separatorStyle = .none
        tableView.backgroundColor = styleGuide.colorScheme.background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind() {
        viewModel.rx_cells
            .drive(onNext: { [weak self] cells in
                self?.cells = cells
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func refreshTableView() {
        viewModel.rx_reloadObserver.onNext(())
    }
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .header(let viewModel):
            let cell = tableView.dequeueReusableCell(withCellClass: HeaderCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .section(let viewModel):
            let cell = tableView.dequeueReusableCell(withCellClass: SectionCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .transaction(let viewModel):
            let cell = tableView.dequeueReusableCell(withCellClass: TransactionCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .spacing:
            let cell = tableView.dequeueReusableCell(withCellClass: SpacingCell.self, for: indexPath)
            return cell
        }
    }
}
