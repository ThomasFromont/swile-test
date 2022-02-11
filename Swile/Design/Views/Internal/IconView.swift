//
//  IconView.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

final class IconView: UIView {

    private enum Constant {
        static let smallSize = CGSize(width: 22.0, height: 22.0)
        static let smallImageSize = CGSize(width: 16.0, height: 16.0)
        static let bigSize = CGSize(width: 30.0, height: 30.0)
        static let bigImageSize = CGSize(width: 24.0, height: 24.0)
    }

    enum IconStyle {
        case small
        case big

        var size: CGSize {
            switch self {
            case .small: return Constant.smallSize
            case .big: return Constant.bigSize
            }
        }

        var imageSize: CGSize {
            switch self {
            case .small: return Constant.smallImageSize
            case .big: return Constant.bigImageSize
            }
        }
    }

    // MARK: - Properties

    var image: UIImage? {
        didSet { iconImageView.image = image }
    }

    var tint: Tint? {
        didSet { iconImageView.tintColor = tint?.darkColor }
    }

    var heroSuffix: String? {
        didSet {
            self.hero.id = heroSuffix.map { HeroPrefix.icon + $0 }
            self.hero.modifiers = [.duration(HeroDuration.medium.rawValue)]
        }
    }

    private let iconStyle: IconStyle
    private let iconImageView: IconImageView

    // MARK: - Initializers

    init(iconStyle: IconStyle) {
        self.iconStyle = iconStyle
        self.iconImageView = IconImageView(iconStyle: iconStyle)

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
        addSubview(iconImageView)
    }

    // MARK: - Layout

    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.size.equalTo(iconStyle.size)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = StyleGuide.shared.colorScheme.background

        clipsToBounds = true
        layer.cornerRadius = iconStyle.size.width / 2
    }
}

private final class IconImageView: UIImageView {

    // MARK: - Properties

    private let iconStyle: IconView.IconStyle

    // MARK: - Initializers

    init(iconStyle: IconView.IconStyle) {
        self.iconStyle = iconStyle

        super.init(image: nil)

        clipsToBounds = true

        layer.cornerRadius = iconStyle.imageSize.width / 2
        contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override var intrinsicContentSize: CGSize {
        return iconStyle.imageSize
    }
}
