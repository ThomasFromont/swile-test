//
//  SectionHeader.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit

final public class SectionHeader: UIView, HasData {

    private enum Constant {
        static let insets = UIEdgeInsets(top: 2, left: 20, bottom: 4, right: 20)
    }

    // MARK: - Nested

    public struct Data {
        public let title: String

        public init(title: String) {
            self.title = title
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
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.insets)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = .clear

        label.font = styleGuide.fontBook.sectionHeader
        label.numberOfLines = 0
        label.textColor = styleGuide.colorScheme.textSecondary
    }

    // MARK: - Update

    private func updateData() {
        label.text = data?.title
    }
}
