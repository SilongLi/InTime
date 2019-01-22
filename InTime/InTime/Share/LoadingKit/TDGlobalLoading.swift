//
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

open class TDGlobalLoading {

    /// 全局loading
    ///
    /// - Parameters:
    ///   - title: 提示文本
    ///   - afterDelay: 自动隐藏时间
    ///   - animationType: 动画类型，默认使用菊花圈
    ///   - animationGifName: gif图片名，animationType类型为.gif时，必须设置
    ///   - animationGroup: 动画图片集合，animationType类型为.group时，必须设置
    ///   - canTouchSuperView: 是否可触摸hud的父视图，默认不可触摸
    ///   - isAutoHide: 是否自动隐藏，默认不隐藏
    ///   - style: loading样式，默认为黑底白字
    public static func showGlobalLoading(_ title: String,
                                  afterDelay: TimeInterval = delayTime,
                                  animationType: AnimationType = .normal,
                                  animationGifName: String? = nil,
                                  animationGroup: [UIImage]? = nil,
                                  canTouchSuperView: Bool = false,
                                  isAutoHide: Bool = false,
                                  style: LoadingStyle = .normal,
                                  imagePosition: ImagePosition = .left,
                                  imageSize: CGSize = CGSize(width: 20, height: 20),
                                  backgoundColor: UIColor = .clear) {
        let window = UIApplication.shared.keyWindow
        window?.showLeftAnimationLoading(title,
                                        afterDelay: afterDelay,
                                        animationType: animationType,
                                        animationGifName: animationGifName,
                                        animationGroup: animationGroup,
                                        canTouchSuperView: canTouchSuperView,
                                        isAutoHide: isAutoHide,
                                        style: style,
                                        imagePosition: imagePosition,
                                        imageSize: imageSize,
                                        backgoundColor: backgoundColor)
    }

    /// 隐藏全局loading
    public static func hideGlobalLoading(_ message: String) {
        let window = UIApplication.shared.keyWindow
        window?.hideWithMessage(message)
    }

    public static func hide() {
        let window = UIApplication.shared.keyWindow
        window?.hideHud()
    }


    /// 全局文字提示
    ///
    /// - Parameters:
    ///   - title: 提示文本
    ///   - afterDelay: 自动隐藏时间
    ///   - style: 样式
    ///   - fontSize: 字体大小
    ///   - maxLine: 最多显示的行数
    ///   - alignment: 对齐方式
    ///   - canTouchSuperView: 能否交互 true：可交互 false：不可交互
    public static func showGlobalText(_ title: String,
                                afterDelay: TimeInterval = delayTime,
                                style: LoadingStyle = .normal,
                                fontSize: Int = 14,
                                maxLine: Int = 5,
                                alignment: NSTextAlignment = .left,
                                canTouchSuperView: Bool = false) {
        let window = UIApplication.shared.keyWindow
        window?.showText(title,
                         afterDelay: afterDelay,
                         style: style,
                         fontSize: fontSize,
                         maxLine: maxLine,
                         alignment: alignment,
                         canTouchSuperView: canTouchSuperView)
    }
}
