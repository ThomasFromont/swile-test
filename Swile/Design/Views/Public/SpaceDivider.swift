//
//  SpaceDivider.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit

final public class SpaceDivider: UIView {

    private enum Constant {
        static let height: CGFloat = 8.0
    }

    // MARK: - Initializers

    public init() {
        super.init(frame: .zero)

        setupConstraints()
        setupStyle()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = .clear
    }
}
