//
//  Avatar.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

final class Avatar: UIImageView {

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

    private let size: CGSize
    private let withBorder: Bool

    // MARK: - Initializers

    public init(size: CGSize, withBorder: Bool = true) {
        self.size = size
        self.withBorder = withBorder

        super.init(image: nil)

        setupStyle()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Style

    private func setupStyle() {
        backgroundColor = StyleGuide.shared.colorScheme.background

        clipsToBounds = true
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        layer.cornerRadius = size.width / 2.5

        layer.borderWidth = withBorder ? 1 : 0
    }
}
