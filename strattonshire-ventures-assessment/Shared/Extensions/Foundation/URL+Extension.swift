//
//  URL+Extension.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/4/24.
//

import UIKit

extension URL {
    /// Retrieves the aspect ratio of an image located at the URL.
    ///
    /// This method creates an image source from the URL and extracts the image properties
    /// to get the pixel width and height. It then returns these dimensions as a tuple.
    ///
    /// - Returns: A tuple containing the pixel width and height of the image. If the image properties
    /// cannot be retrieved, the method returns (0, 0).
    func getImageAspectRatio() -> (CGFloat, CGFloat) {
        // Create an image source from the URL
        let imageURL = self
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil) else {
            // Return default value (220, 310) if the image source cannot be created
            // Return (0, 0) would crash the app
            return (220, 310)
        }

        // Copy the image properties at index 0
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? else {
            // Return default value (220, 310) if the image properties cannot be copied
            // Return (0, 0) would crash the app
            return (220, 310)
        }

        // Extract the pixel width and height from the image properties
        guard let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as? CGFloat,
              let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as? CGFloat else {
            // Return default value (220, 310) if the pixel dimensions cannot be extracted
            // Return (0, 0) would crash the app
            return (220, 310)
        }

        // Return the pixel width and height as a tuple
        return (pixelWidth, pixelHeight)
    }
}
