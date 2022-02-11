//
//  CloseButton.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

import UIKit
import SnapKit

final public class CloseButton: UIControl {

    private enum Constant {
        static let size = CGSize(width: 24.0, height: 24.0)
    }

    // MARK: - Properties

    private let imageView = UIImageView()
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
        addSubview(imageView)
    }

    // MARK: - Layout

    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = .clear
        imageView.image = Asset.iconChevronDown.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = styleGuide.colorScheme.textPrimary
    }
}
