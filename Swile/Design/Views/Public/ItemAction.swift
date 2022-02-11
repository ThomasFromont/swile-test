//
//  ItemAction.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

import UIKit
import SnapKit

final public class ItemAction: UIControl, HasData {

    private enum Constant {
        static let insets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        static let spacing: CGFloat = 12
        static let avatarSize = CGSize(width: 32, height: 32)
    }

    // MARK: - Nested

    public struct Data {

        public let title: String
        public let action: String?
        public let tint: Tint

        public init(title: String, action: String?, tint: Tint) {
            self.title = title
            self.action = action
            self.tint = tint
        }
    }

    private let stackView = UIStackView()
    private let textStackView = UIStackView()
    private let avatarView = Avatar(avatarStyle: .small)
    private let titleLabel = UILabel()
    private let actionLabel = UILabel()
    private let styleGuide = StyleGuide.shared

    // MARK: - Properties

    public var data: Data? {
        didSet { updateData() }
    }

    public var avatar: UIImage? {
        didSet { avatarView.image = avatar }
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

    // MARK: - Override

    override public var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? styleGuide.colorScheme.divider : .clear
        }
    }

    // MARK: - Hierarchy

    private func setupHierarchy() {
        addSubview(stackView)

        stackView.addArrangedSubview(avatarView)
        stackView.addArrangedSubview(textStackView)

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(actionLabel)
    }

    // MARK: - Layout

    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.insets)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = false
        stackView.spacing = Constant.spacing

        textStackView.axis = .horizontal
        textStackView.isUserInteractionEnabled = false
        stackView.spacing = Constant.spacing

        titleLabel.font = styleGuide.fontBook.title
        titleLabel.numberOfLines = 0
        titleLabel.textColor = styleGuide.colorScheme.textPrimary

        actionLabel.font = styleGuide.fontBook.action
        actionLabel.numberOfLines = 0
        actionLabel.textColor = styleGuide.colorScheme.textAction
        actionLabel.textAlignment = .center
    }

    // MARK: - Update

    private func updateData() {
        titleLabel.text = data?.title
        textStackView.spacing = data?.action == nil ? .zero : Constant.spacing
        actionLabel.isHidden = data?.action == nil
        actionLabel.text = data?.action
        avatarView.tint = data?.tint
    }
}
