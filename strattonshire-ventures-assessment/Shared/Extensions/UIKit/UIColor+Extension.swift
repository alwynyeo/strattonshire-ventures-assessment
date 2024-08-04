//
//  UIColor+Extension.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/3/24.
//

import UIKit

extension UIColor {

    /**
     Initializes a `UIColor` object with a hexadecimal color string.

     - Parameter hexString: The hexadecimal string representing the color.

     The string can be in one of the following formats:
     - `#RGB` (e.g., `#F00` for red)
     - `#RRGGBB` (e.g., `#FF0000` for red)
     - `#AARRGGBB` (e.g., `#FFFF0000` for red with full opacity)

     The `#` prefix is optional, and the string is case-insensitive.

     If the string is not in a recognized format, the color defaults to black with full opacity.

     - Returns: An initialized `UIColor` object.
     */
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
