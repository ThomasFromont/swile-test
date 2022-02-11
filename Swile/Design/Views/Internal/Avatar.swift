//
//  Avatar.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

final class Avatar: UIView {

    enum Constant {
        static let smallInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        static let bigInsets = UIEdgeInsets.zero
        static let smallSize = CGSize(width: 32, height: 32)
        static let bigSize = CGSize(width: 56, height: 56)
    }

    enum AvatarStyle {
        case small
        case big

        var size: CGSize {
            switch self {
            case .small: return Constant.smallSize
            case .big: return Constant.bigSize
            }
        }

        var insets: UIEdgeInsets {
            switch self {
            case .small: return Constant.smallInsets
            case .big: return Constant.bigInsets
            }
        }
    }

    // MARK: - Properties

    var tint: Tint? {
        didSet {
            guard let tint = tint else {
                return
            }

            backgroundView.backgroundColor = tint.lightColor
            self.layer.borderColor = tint.darkColor.withAlphaComponent(0.06).cgColor
            self.tintColor = tint.darkColor
        }
    }

    var image: UIImage? {
        didSet { imageView.image = image }
    }

    var heroSuffix: String? {
        didSet {
            backgroundView.hero.id = heroSuffix.map { HeroPrefix.background + $0 }
            backgroundView.hero.modifiers = [.duration(HeroDuration.medium.rawValue)]
            imageView.hero.id = heroSuffix.map { HeroPrefix.avatarImage + $0 }
            imageView.hero.modifiers = [.duration(HeroDuration.medium.rawValue)]
        }
    }

    private let avatarStyle: AvatarStyle

    private let imageView = UIImageView()
    private let backgroundView = UIView()

    // MARK: - Initializers

    public init(avatarStyle: AvatarStyle) {
        self.avatarStyle = avatarStyle

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
        addSubview(backgroundView)
        addSubview(imageView)
    }

    // MARK: - Layout

    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.size.equalTo(avatarStyle.size)
        }

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(avatarStyle.insets)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        clipsToBounds = true
        layer.cornerRadius = avatarStyle.size.width / 2.5
        layer.borderWidth = 1

        imageView.layer.cornerRadius = avatarStyle.size.width / 2.5
        backgroundView.layer.cornerRadius = avatarStyle.size.width / 2.5

        imageView.contentMode = .scaleAspectFit
    }
}
