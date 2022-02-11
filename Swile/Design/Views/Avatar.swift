//
//  Avatar.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

final class Avatar: UIView {

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

    var heroBackgroundSuffix: String? {
        didSet {
            backgroundView.hero.id = heroBackgroundSuffix.map { HeroPrefix.background + $0 }
            backgroundView.hero.modifiers = [.duration(HeroDuration.medium.rawValue)]
        }
    }

    var heroImageSuffix: String? {
        didSet {
            imageView.hero.id = heroImageSuffix.map { HeroPrefix.avatarImage + $0 }
            imageView.hero.modifiers = [.duration(HeroDuration.medium.rawValue)]
        }
    }

    private let size: CGSize
    private let withBorder: Bool

    private let imageView = UIImageView()
    private let backgroundView = UIView()

    // MARK: - Initializers

    public init(size: CGSize, withBorder: Bool = true) {
        self.size = size
        self.withBorder = withBorder

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
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Style

    private func setupStyle() {
        clipsToBounds = true
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        layer.cornerRadius = size.width / 2.5
        layer.borderWidth = withBorder ? 1 : 0

        imageView.layer.cornerRadius = size.width / 2.5
        backgroundView.layer.cornerRadius = size.width / 2.5

        imageView.contentMode = .scaleAspectFit
    }
}
