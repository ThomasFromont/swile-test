//
//  Divider.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

import UIKit
import SnapKit

public final class Divider: UIView {

    private enum Constant {
        static let height: CGFloat = 1
        static let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    // MARK: - Properties

    private let divider: UIView = UIView()
    private let styleGuide = StyleGuide.shared

    // MARK: - Initializers

    public init() {
        super.init(frame: .zero)

        setupHierarchy()
        setupLayout()
        setupStyle()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Hierarchy

    private func setupHierarchy() {
        addSubview(divider)
    }

    // MARK: - Layout

    private func setupLayout() {
        divider.snp.updateConstraints { make in
            make.height.equalTo(Constant.height)
            make.edges.equalToSuperview().inset(Constant.insets)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        divider.backgroundColor = styleGuide.colorScheme.divider
    }
}
