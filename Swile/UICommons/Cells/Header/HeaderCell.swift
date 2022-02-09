//
//  HeaderCell.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit
import SnapKit

final class HeaderCell: UITableViewCell {

    private let header = Header()

    var viewModel: HeaderCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            header.data = .init(title: viewModel.title)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(header)
    }

    private func setupLayout() {
        layoutMargins = .zero

        header.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
