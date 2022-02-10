//
//  TransactionCell.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit
import RxSwift

final class TransactionCell: UITableViewCell {

    private let itemTransaction = ItemTransaction()
    private var disposeBag = DisposeBag()

    var viewModel: TransactionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            let disposeBag = DisposeBag()

            itemTransaction.data = .init(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                price: viewModel.price,
                priceType: viewModel.isPriceNegative ? .text : .tag,
                tint: viewModel.tint
            )

            itemTransaction.rx
                .controlEvent(.touchUpInside)
                .bind(to: viewModel.selectObserver)
                .disposed(by: disposeBag)

            viewModel.rx_avatar
                .drive(onNext: { [weak self] avatar in
                    self?.itemTransaction.avatar = avatar
                })
                .disposed(by: disposeBag)

            viewModel.rx_icon
                .drive(onNext: { [weak self] icon in
                    self?.itemTransaction.icon = icon
                })
                .disposed(by: disposeBag)

            self.disposeBag = disposeBag
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        itemTransaction.isHighlighted = highlighted
    }

    private func setupViews() {
        contentView.addSubview(itemTransaction)
    }

    private func setupLayout() {
        layoutMargins = .zero

        itemTransaction.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupStyle() {
        contentView.backgroundColor = .clear
    }
}
