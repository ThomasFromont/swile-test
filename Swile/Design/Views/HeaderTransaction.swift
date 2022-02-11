//
//  HeaderTransaction.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

import UIKit
import SnapKit

final public class HeaderTransaction: UIView, HasData {

    private enum Constant {
        static let textsInsets = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        static let subtitleOffset: CGFloat = 4.0
        static let informationOffset: CGFloat = 8.0
        static let imagesContainerHeight: CGFloat = 224.0
        static let avatarSize = CGSize(width: 144, height: 144)
        static let avatarOffset: CGFloat = -18.0
        static let iconOffset: CGFloat = -29.0
    }

    // MARK: - Nested

    public struct Data {
        public let title: String
        public let subtitle: String
        public let information: String
        public let tint: Tint

        public init(title: String, subtitle: String, information: String, tint: Tint) {
            self.title = title
            self.subtitle = subtitle
            self.information = information
            self.tint = tint
        }
    }

    // MARK: - Properties

    private let stackView = UIStackView()
    private let imagesContainer = UIView()
    private let avatarView = Avatar(size: Constant.avatarSize, withBorder: false)
    private let iconView = IconView()
    private let textsContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let informationLabel = UILabel()
    private let styleGuide = StyleGuide.shared

    public var data: Data? {
        didSet { updateData() }
    }

    public var avatar: UIImage? {
        didSet {
            avatarView.image = avatar
        }
    }

    public var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
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
        addSubview(stackView)
        stackView.addArrangedSubview(imagesContainer)
        stackView.addArrangedSubview(textsContainer)

        imagesContainer.addSubview(avatarView)
        imagesContainer.addSubview(iconView)

        textsContainer.addSubview(titleLabel)
        textsContainer.addSubview(subtitleLabel)
        textsContainer.addSubview(informationLabel)
    }

    // MARK: - Layout

    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imagesContainer.snp.makeConstraints { make in
            make.height.equalTo(Constant.imagesContainerHeight)
        }

        avatarView.snp.makeConstraints { make in
            make.size.equalTo(Constant.avatarSize)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(Constant.avatarOffset)
        }

        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(imagesContainer.snp.bottom)
            make.right.equalToSuperview().offset(Constant.iconOffset)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(Constant.textsInsets)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.subtitleOffset)
            make.left.right.equalToSuperview().inset(Constant.textsInsets)
        }

        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constant.informationOffset)
            make.left.right.bottom.equalToSuperview().inset(Constant.textsInsets)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = .clear
        stackView.axis = .vertical

        titleLabel.font = styleGuide.fontBook.header
        titleLabel.numberOfLines = 1
        titleLabel.textColor = styleGuide.colorScheme.textPrimary
        titleLabel.textAlignment = .center

        subtitleLabel.font = styleGuide.fontBook.titleSmall
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = styleGuide.colorScheme.textPrimary
        subtitleLabel.textAlignment = .center

        informationLabel.font = styleGuide.fontBook.sectionHeader
        informationLabel.numberOfLines = 1
        informationLabel.textColor = styleGuide.colorScheme.textSecondary
        informationLabel.textAlignment = .center
    }

    // MARK: - Update

    private func updateData() {
        titleLabel.text = data?.title
        subtitleLabel.text = data?.subtitle
        informationLabel.text = data?.information

        avatarView.tint = data?.tint
        iconView.tint = data?.tint
        imagesContainer.backgroundColor = data?.tint.lightColor
    }
}
