//
//  ImageProvider.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation
import RxSwift

class ImageProvider {

    static func rx_image(from url: String?, defaultImage: UIImage?) -> Observable<UIImage?> {
        guard let urlString = url, let url = URL(string: urlString) else {
            return .just(defaultImage)
        }

        let request = URLRequest(url: url)

        return URLSession.shared.rx
            .response(request: request)
            .map { UIImage(data: $0.1) }
            .startWith(defaultImage)
    }
}
