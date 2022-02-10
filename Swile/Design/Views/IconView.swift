//
//  IconView.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

final class IconView: UIView {

    private enum Constant {
        static let size = CGSize(width: 22.0, height: 22.0)
    }

    // MARK: - Properties

    var image: UIImage? {
        didSet { iconImageView.image = image }
    }

    var tint: Tint? {
        didSet { iconImageView.tintColor = tint?.darkColor }
    }

    private let iconImageView = IconImageView()

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
        addSubview(iconImageView)
    }

    // MARK: - Layout

    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.size.equalTo(Constant.size)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        layer.cornerRadius = Constant.size.width / 2
    }
}

private final class IconImageView: UIImageView {

    private enum Constant {
        static let size = CGSize(width: 16.0, height: 16.0)
    }

    // MARK: - Initializers

    init() {
        super.init(image: nil)

        clipsToBounds = true
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)

        layer.cornerRadius = Constant.size.width / 2
        contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override var intrinsicContentSize: CGSize {
        return Constant.size
    }
}
