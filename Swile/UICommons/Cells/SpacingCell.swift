//
//  SpacingCell.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit

final class SpacingCell: UITableViewCell {

    private let spaceDivider = SpaceDivider()

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
        contentView.addSubview(spaceDivider)
    }

    private func setupLayout() {
        layoutMargins = .zero

        spaceDivider.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupStyle() {
        isUserInteractionEnabled = false
        contentView.backgroundColor = .clear
    }
}
