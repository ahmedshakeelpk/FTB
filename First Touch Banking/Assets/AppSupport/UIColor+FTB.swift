//
//  UIColor+FTB.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

extension UIColor {

    public class var selctedColor : UIColor {
        return UIColor(hexString: "#0079B8")
//        return UIColor(hexString: "#00BDD1")
    }
    public class var blueColor : UIColor {
        return UIColor(hexString: "#0079B8")
    }
}
extension UIColor {
    // Create color from RGB
    convenience init(absoluteRed: Int, green: Int, blue: Int) {
        self.init(
            absoluteRed: absoluteRed,
            green: green,
            blue: blue,
            alpha: 1.0
        )
    }

    // Create color from RGBA
    convenience init(absoluteRed: Int, green: Int, blue: Int, alpha: CGFloat) {
        let normalizedRed = CGFloat(absoluteRed) / 255
        let normalizedGreen = CGFloat(green) / 255
        let normalizedBlue = CGFloat(blue) / 255

        self.init(
            red: normalizedRed,
            green: normalizedGreen,
            blue: normalizedBlue,
            alpha: alpha
        )
    }

    // Color from HEX-Value
    // Based on: http://stackoverflow.com/a/24263296
    convenience init(hexValue:Int) {
        self.init(
            absoluteRed: (hexValue >> 16) & 0xff,
            green: (hexValue >> 8) & 0xff,
            blue: hexValue & 0xff
        )
    }

    // Color from HEX-String
    // Based on: http://stackoverflow.com/a/27203691
    convenience init(hexString:String) {
        var normalizedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (normalizedHexString.hasPrefix("#")) {
            normalizedHexString.remove(at: normalizedHexString.startIndex)
        }
        //       normalizedHexString = normalizedHexString.replacingOccurrences(of: "#", with: "")

        // Convert to hexadecimal integer
        var hexValue:UInt32 = 0
        Scanner(string: normalizedHexString).scanHexInt32(&hexValue)

        self.init(
            hexValue:Int(hexValue)
        )
    }
}
