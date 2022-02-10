//
//  Tag.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit

final class Tag: UIView, HasData {

    private enum Constant {
        static let insets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        static let cornerRadius: CGFloat = 9.0
        static let height: CGFloat = 24.0
    }

    // MARK: - Nested

    public struct Data {
        public let text: String
        public let tint: Tint

        public init(text: String, tint: Tint) {
            self.text = text
            self.tint = tint
        }
    }

    // MARK: - Properties

    private let label = UILabel()
    private let styleGuide = StyleGuide.shared

    public var data: Data? {
        didSet { updateData() }
    }

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
        addSubview(label)
    }

    // MARK: - Layout

    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }

        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constant.insets)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - Style

    private func setupStyle() {
        layer.cornerRadius = Constant.cornerRadius

        label.font = styleGuide.fontBook.title
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    // MARK: - Update

    private func updateData() {
        label.text = data?.text
        label.textColor = data?.tint.darkColor
        backgroundColor = data?.tint.lightColor
    }
}
