//
//  ItemTransaction.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit
import SnapKit

final public class ItemTransaction: UIControl, HasData {

    private enum Constant {
        static let insets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        static let spacing: CGFloat = 14
        static let spacingTitles: CGFloat = 2
        static let iconBottomInsets = -3.0
        static let iconRightInsets = -5.0
    }

    // MARK: - Nested

    public struct Data {

        public enum PriceType {
            case text
            case tag
        }

        public let title: String
        public let subtitle: String
        public let price: String
        public let priceType: PriceType
        public let tint: Tint
        public let heroSuffix: String?

        public init(
            title: String,
            subtitle: String,
            price: String,
            priceType: PriceType,
            tint: Tint,
            heroSuffix: String? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.price = price
            self.priceType = priceType
            self.tint = tint
            self.heroSuffix = heroSuffix
        }
    }

    private let stackView = UIStackView()
    private let imageContainer = UIView()
    private let avatarView = Avatar(avatarStyle: .big)
    private let iconView = IconView(iconStyle: .small)
    private let textContainer = UIView()
    private let textStackView = UIStackView()
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceContainer = UIView()
    private let priceStackView = UIStackView()
    private let priceLabel = UILabel()
    private let priceTag = Tag()
    private let styleGuide = StyleGuide.shared

    // MARK: - Properties

    public var data: Data? {
        didSet { updateData() }
    }

    public var avatar: UIImage? {
        didSet { avatarView.image = avatar }
    }

    public var icon: UIImage? {
        didSet { iconView.image = icon }
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

        stackView.addArrangedSubview(imageContainer)
        stackView.addArrangedSubview(textContainer)

        imageContainer.addSubview(avatarView)
        imageContainer.addSubview(iconView)

        textContainer.addSubview(textStackView)
        textStackView.addArrangedSubview(titleStackView)
        textStackView.addArrangedSubview(priceContainer)

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)

        priceContainer.addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceTag)
    }

    // MARK: - Layout

    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.insets)
        }

        avatarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constant.iconRightInsets)
            make.bottom.equalToSuperview().inset(Constant.iconBottomInsets)
        }

        textStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        priceStackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = false
        stackView.spacing = Constant.spacing

        textStackView.axis = .horizontal
        textStackView.spacing = Constant.spacing

        titleStackView.axis = .vertical
        titleStackView.spacing = Constant.spacingTitles

        titleLabel.font = styleGuide.fontBook.title
        titleLabel.numberOfLines = 1
        titleLabel.textColor = styleGuide.colorScheme.textPrimary

        subtitleLabel.font = styleGuide.fontBook.subtitle
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = styleGuide.colorScheme.textSecondary

        priceStackView.axis = .vertical

        priceLabel.font = styleGuide.fontBook.title
        priceLabel.numberOfLines = 1
        priceLabel.textColor = styleGuide.colorScheme.textPrimary
        priceLabel.textAlignment = .right
    }

    // MARK: - Update

    private func updateData() {

        switch data?.priceType ?? .text {
        case .text:
            priceLabel.isHidden = false
            priceTag.isHidden = true
        case .tag:
            priceLabel.isHidden = true
            priceTag.isHidden = false
        }

        titleLabel.text = data?.title
        subtitleLabel.text = data?.subtitle
        priceLabel.text = data?.price
        avatarView.tint = data?.tint
        iconView.tint = data?.tint

        if let price = data?.price, let tint = data?.tint {
            priceTag.data = .init(text: price, tint: tint)
        }

        avatarView.heroSuffix = data?.heroSuffix
        iconView.hero.id = data?.heroSuffix.map { HeroPrefix.icon + $0 }
        iconView.hero.modifiers = [.duration(HeroDuration.medium.rawValue)]
    }
}
