//
//  SectionCell.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit

final class SectionCell: UITableViewCell {

    private let sectionHeader = SectionHeader()

    var viewModel: SectionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            sectionHeader.data = .init(title: viewModel.title)
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

    private func setupViews() {
        contentView.addSubview(sectionHeader)
    }

    private func setupLayout() {
        layoutMargins = .zero

        sectionHeader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupStyle() {
        isUserInteractionEnabled = false
        contentView.backgroundColor = .clear
    }
}
