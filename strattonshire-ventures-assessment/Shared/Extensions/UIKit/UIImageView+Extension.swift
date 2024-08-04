//
//  UIImageView+Extension.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/3/24.
//

import UIKit
import Kingfisher

extension UIImageView {

    /**
     Sets an image to the image view from the specified URL.

     - Parameters:
     - url: The URL from which to retrieve the image.
     - placeholder: An optional image to display while the image is being downloaded.

     - Important: The `url` parameter must contain a valid URL to an image.

     - Note: This method uses the Kingfisher library for image downloading and caching.

     - Example:
     ```swift
     let url = URL(string: "https://example.com/image.jpg")
     imageView.setImage(with: url, placeholder: UIImage(named: "placeholder"))
     ```

     - SeeAlso: [Kingfisher Library](https://github.com/onevcat/Kingfisher)
     */
    func setImage(with urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            print("Error: happened under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        typealias ResultType = Result<RetrieveImageResult, KingfisherError>

        let imageView = self
        var kf = imageView.kf
        let cornerRadius = imageView.layer.cornerRadius
        let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        kf.indicatorType = IndicatorType.activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = Resources.Color.indicator
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                KingfisherOptionsInfoItem.processor(processor),
                KingfisherOptionsInfoItem.backgroundDecode,
                KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.3)),
                KingfisherOptionsInfoItem.waitForCache,
            ]
        ) { result in
            switch result {
                case ResultType.success(let value): break
//                    print("Kingfisher Task done for: \(value.source.url?.absoluteString ?? "")")
                case ResultType.failure(let error): break
//                    print("Kingfisher Job failed: \(error.localizedDescription)")
            }
        }
    }
}
