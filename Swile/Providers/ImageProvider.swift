//
//  ImageProvider.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation
import RxSwift

protocol ImageProviderType: AnyObject {
    func rx_image(from url: String?, defaultImage: UIImage?) -> Observable<UIImage?>
}

class ImageProvider: ImageProviderType {

    private var cachedImages: [String: UIImage] = [:]
    private let queue = DispatchQueue(label: "swile.imageprovider", qos: DispatchQoS.userInteractive)

    func rx_image(from url: String?, defaultImage: UIImage?) -> Observable<UIImage?> {
        guard let urlString = url, let url = URL(string: urlString) else {
            return .just(defaultImage)
        }

        let request = URLRequest(url: url)

        var startImage = defaultImage
        queue.sync {
            if let cachedImage = cachedImages[urlString] {
                startImage = cachedImage
            }
        }

        return URLSession.shared.rx
            .response(request: request)
            .map { UIImage(data: $0.1) }
            .do { [weak self] image in
                guard let self = self else {
                    return
                }
                self.queue.sync {
                    self.cachedImages[urlString] = image
                }
            }
            .startWith(startImage)
    }
}
