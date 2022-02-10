//
//  Avatar.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

final class Avatar: UIImageView {

    private enum Constant {
        static let size = CGSize(width: 56.0, height: 56.0)
    }

    // MARK: - Properties

    var tint: Tint? {
        didSet {
            guard let tint = tint else {
                return
            }

            self.backgroundColor = tint.lightColor
            self.layer.borderColor = tint.darkColor.withAlphaComponent(0.06).cgColor
            self.tintColor = tint.darkColor
        }
    }

    // MARK: - Initializers

    public init() {
        super.init(image: nil)

        setupLayout()
        setupStyle()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Layout

    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.size.equalTo(Constant.size)
        }
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = StyleGuide.shared.colorScheme.background

        clipsToBounds = true
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        layer.cornerRadius = Constant.size.width / 2.5

        layer.borderWidth = 1.0
    }
}
