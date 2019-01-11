//
//  CloudKeeper
//
//  Created by BruceLi on 2018/8/15.
//  Copyright © 2018 BruceLi. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK: - 基础用色

    /// App 主色调
    open class var tintColor: UIColor { return UIColor.color(hex: "#2C2D39") }
    open class func tintHexColorString() -> String { return "#2C2D39" }
    
    // 绿色
//    open class var greenColor: UIColor { return UIColor.color(red: 117.0, green: 198.0, blue: 152.0) }
    open class var greenColor: UIColor { return UIColor.color(hex: "#7BF554") }
    // 粉色
    open class var pinkColor: UIColor { return UIColor.color(red: 233.0, green: 94.0, blue: 137.0) }
    
    /// 淡白-cell的高亮色
    open class var cellHighlightedColor: UIColor { return UIColor.white.withAlphaComponent(0.3) }
    /// 分隔线颜色
    open class var spaceLineColor: UIColor { return UIColor.color(hex: "#e5e5e5").withAlphaComponent(0.3) }
    
    // MARK: - other
    
    /// 随机色
    open class var randomColor: UIColor {
        return UIColor.color(red: CGFloat(arc4random() % 256),
                             green: CGFloat(arc4random() % 256),
                             blue: CGFloat(arc4random() % 256))
    }

    /// 直接通过RGBA值创建UIColor
    open class func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }

    /// 把16进制色 ==> UIColor
    ///
    /// - Parameter hex: 16进制色字符串
    /// - Returns: UIColor
    open class func color(hex hexStr: String, alpha: CGFloat = 1.0) -> UIColor {
        var hex: String = hexStr
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        guard hex.count == 6 else {
            return UIColor.tintColor
        }
        let redStart = hex.index(hex.startIndex, offsetBy: 0)
        let redEnd   = hex.index(hex.startIndex, offsetBy: 2)
        let redStr: String = String(hex[redStart..<redEnd])

        let greenStart = hex.index(hex.startIndex, offsetBy: 2)
        let greenEnd   = hex.index(hex.startIndex, offsetBy: 4)
        let greenStr: String = String(hex[greenStart..<greenEnd])

        let blueStart = hex.index(hex.startIndex, offsetBy: 4)
        let blueEnd   = hex.index(hex.startIndex, offsetBy: 6)
        let blueStr: String = String(hex[blueStart..<blueEnd])

        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        Scanner(string: redStr).scanHexInt32(&red)
        Scanner(string: greenStr).scanHexInt32(&green)
        Scanner(string: blueStr).scanHexInt32(&blue)
        return UIColor.color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }

    /// 用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
