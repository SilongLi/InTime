//
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

public let delayTime = 2.0 //默认显示时间2.0s

public enum LoadingStyle {
    case normal        //默认样式，黑底白字
    case gray          //灰色样式，白底灰字
    case orange        //桔色样式，白底桔字
}

public enum ImagePosition {
    case top
    case left
}

// MARK: - 注意：loading动画的图片显示的大小为20*20，暂不提供自定义大小

extension UIView {

    // MARK: - public method
    /// loading框
    ///
    /// - Parameters:
    ///   - title: 提示语
    ///   - afterDelay: 显示时间，默认2.0s
    ///   - animationType: 动画类型，默认使用菊花圈
    ///   - animationGifName: gif图片名，animationType类型为.gif时，必须设置
    ///   - animationGroup: 动画图片集合，animationType类型为.group时，必须设置
    ///   - canTouchSuperView: 是否可触摸hud的父视图，默认不可触摸
    ///   - isAutoHide: 是否自动隐藏，默认不隐藏
    ///   - style: 默认为黑底白字
    ///   - imagePosition: 图片位置
    ///   - imageSize: 图片大小
    ///   - backgoundColor: hud背景色
    ///   - minSize: hud最小的宽高
    ///   - imageEdgeInsets: 图片上下左右间距
    ///   - textEdgeInsets: 文字上下左右间距
    ///   - font: 字体
    ///   - animationDuring: loading动画时长
    ///   - contentBackgroundColor: hud内容区域的背景颜色，默认黑色半透明
    ///   - completionBlock: 完成回调
    public func showLeftAnimationLoading(_ title: String,
                                  afterDelay: TimeInterval = delayTime,
                                  animationType: AnimationType = .normal,
                                  animationGifName: String? = nil,
                                  animationGroup: [UIImage]? = nil,
                                  canTouchSuperView: Bool = false,
                                  isAutoHide: Bool = false,
                                  style: LoadingStyle = .normal,
                                  imagePosition: ImagePosition = .left,
                                  imageSize: CGSize = CGSize(width: 20, height: 20),
                                  backgoundColor: UIColor = .clear,
                                  minSize: CGSize? = nil,
                                  imageEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                  textEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                  font: UIFont = UIFont.systemFont(ofSize: 14),
                                  animationDuring: TimeInterval = 2.0,
                                  contentBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                                  completionBlock: (() -> Void)? = nil) {

        if self.isHudShow() == true {
            return
        }

        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.backgroundColor = backgoundColor
        hud.isUserInteractionEnabled = !canTouchSuperView
        hud.backgroundView.isUserInteractionEnabled = !canTouchSuperView
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        // 设置bezelView的背景样式为纯色背景，默认初始化设置为高斯模糊
        hud.bezelView.style = .solidColor
        hud.completionBlock = {
            if completionBlock != nil {
                completionBlock!()
            }
        }

        if isAutoHide == true {
            hud.hide(animated: true, afterDelay: afterDelay)
        }

        // 设置自定义视图
        let loadingView = TDLoadingView()
        loadingView.configData(title,
                               type: animationType,
                               animationGifName: animationGifName,
                               animations: animationGroup,
                               style: style,
                               imagePosition: imagePosition,
                               imageSize: imageSize,
                               imageEdgeInsets: imageEdgeInsets,
                               textEdgeInsets: textEdgeInsets,
                               font: font,
                               animationDuring: animationDuring)

        // 设置Loading背景色
        switch style {
        case .normal:
            loadingView.backgroundColor = contentBackgroundColor
        case .gray, .orange:
            loadingView.backgroundColor = contentBackgroundColor
        }

        hud.bezelView.addSubview(loadingView)
        // 布局loadingView，设置上下左右对齐
        hud.bezelView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[loadingView]-0-|", options: [], metrics: nil, views: ["loadingView": loadingView]))
        hud.bezelView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[loadingView]-0-|", options: [], metrics: nil, views: ["loadingView": loadingView]))

        // 开始loading动画
        loadingView.startAnimating()

        if let size = minSize {
            hud.minSize = size
        } else {
            hud.minSize = loadingView.frame.size
        }
    }

    /// 显示倒计时loading框
    ///
    /// - Parameters:
    ///   - counter: 倒计时多少秒
    ///   - leftText: 左边文字
    ///   - rightText: 右边文字
    ///   - canTouchSuperView: 是否可交互，默认不可交互
    public func showTimerLoading(counter: Int,
                                 leftText: String,
                                 rightText: String,
                                 canTouchSuperView: Bool = false,
                                 contentBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)) {
        if self.isHudShow() == true {
            return
        }

        let hud = MBProgressHUD.showAdded(to: self, animated: true)

        hud.isUserInteractionEnabled = !canTouchSuperView
        hud.backgroundView.isUserInteractionEnabled = !canTouchSuperView
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.bezelView.backgroundColor = .black
        hud.bezelView.style = .solidColor

        // 注意：倒计时未到0s的时候需手动调用hidHud()方法触发completionBlock，来停止定时器
        hud.completionBlock = { [weak self, weak hud] in
            self?.hideTimerHud(view: hud!)
        }

        // 设置自定义视图
        let loadingView = TDTimerView()
        loadingView.backgroundColor = contentBackgroundColor
        loadingView.configData(counter: counter,
                               leftText: leftText,
                               rightText: rightText)
        hud.bezelView.addSubview(loadingView)
        // 布局loadingView，设置上下左右对齐
        hud.bezelView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[loadingView]-0-|", options: [], metrics: nil, views: ["loadingView": loadingView]))
        hud.bezelView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[loadingView]-0-|", options: [], metrics: nil, views: ["loadingView": loadingView]))

        // 倒计时到0s的时候自动隐藏
        loadingView.startTimer { [weak self] (counter) in
            if counter <= 0 {
                self?.hideHud()
            }
        }

        hud.minSize = loadingView.frame.size
    }

    /// 只显示文本
    ///
    /// - Parameters:
    ///   - title: 状态提示语
    ///   - afterDelay: 显示时间， 默认2.0s
    ///   - style: 样式，默认黑底白字
    ///   - fontSize: 字体大小，默认14
    ///   - maxLine: 最大换行数，默认5
    ///   - alignment: 对齐方式，默认左对齐
    ///   - canTouchSuperView: 是否可交互，默认不可交互
    ///   - backgroundColor: 背景色
    ///   - completionBlock: 完成回调
    public func showText(_ title: String,
                  afterDelay: TimeInterval = delayTime,
                  style: LoadingStyle = .normal,
                  fontSize: Int = 14,
                  maxLine: Int = 5,
                  alignment: NSTextAlignment = .left,
                  canTouchSuperView: Bool = false,
                  backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                  completionBlock: (() -> Void)? = nil) {

        if self.isHudShow() == true || title.isEmptyString() { return }

        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .text
        hud.bezelView.style = .solidColor

        switch style {
        case .normal:
            hud.bezelView.backgroundColor = backgroundColor
            hud.contentColor = .white
        case .gray:
            hud.bezelView.backgroundColor = backgroundColor
            hud.contentColor = .gray
        case .orange:
            hud.bezelView.backgroundColor = backgroundColor
            hud.contentColor = .orange
        }

        hud.isUserInteractionEnabled = !canTouchSuperView
        hud.backgroundView.isUserInteractionEnabled = !canTouchSuperView
        hud.margin = 15.0
        hud.label.textAlignment = alignment
        hud.label.text = title
        hud.label.numberOfLines = maxLine
        hud.label.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: afterDelay)
        hud.completionBlock = {
            if completionBlock != nil {
                completionBlock!()
            }
        }
    }

    /// 默认loading框
    ///
    /// - Parameter title: 状态提示语
    public func showSquareLoading(_ title: String = "") {

        if self.isHudShow() == true { return }

        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .indeterminate
        hud.bezelView.style = .solidColor

        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        hud.contentColor = .white
        hud.margin = 15.0
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.removeFromSuperViewOnHide = true

        hud.label.text = title

        hud.hide(animated: true, afterDelay: delayTime)
    }

    /// 隐藏hud，成功状态提示
    ///
    /// - Parameters:
    ///   - title: 状态提示语
    ///   - completionBlock: 完成回调
    public func hideWithSuccess(_ title: String,
                                completionBlock: (() -> Void)? = nil) {
        let hud = self.hudForView()
        if let hud = hud {

            //如果存在自定的视图，先移除
            self.hideCustomLoadingView(view: hud)

            hud.margin = 10.0
            hud.mode = .text
            hud.label.font = UIFont.systemFont(ofSize: 14)
            hud.label.text = title
            hud.minSize = CGSize(width: 100, height: 40)
            hud.label.numberOfLines = 0
            hud.contentColor = .white
            hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: delayTime)
            hud.completionBlock = {
                if let block = completionBlock {
                    block()
                }
            }
        }
    }

    /// 隐藏hud，错误状态提示
    ///
    /// - Parameter title: 状态提示语
    ///   - completionBlock: 完成回调
    public func hideWithError(_ title: String,
                              completionBlock: (() -> Void)? = nil) {
        let hud = self.hudForView()
        if let hud = hud {

            //如果存在自定的视图，先移除
            self.hideCustomLoadingView(view: hud)

            hud.margin = 10.0
            hud.mode = .text
            hud.label.font = UIFont.systemFont(ofSize: 14)
            hud.label.text = title
            hud.minSize = CGSize(width: 100, height: 40)
            hud.label.numberOfLines = 0
            hud.contentColor = .white
            hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: delayTime)
            hud.completionBlock = {
                if let block = completionBlock {
                    block()
                }
            }
        }
    }

    /// 隐藏hud，显示提示文本
    ///
    /// - Parameter title: 提示文本
    ///   - completionBlock: 完成回调
    public func hideWithMessage(_ title: String,
                                completionBlock: (() -> Void)? = nil) {
        let hud = self.hudForView()
        if let hud = hud {

            //如果存在自定的视图，先移除
            self.hideCustomLoadingView(view: hud)

            hud.margin = 10.0
            hud.mode = .text
            hud.label.font = UIFont.systemFont(ofSize: 14)
            hud.label.text = title
            hud.minSize = CGSize(width: 100, height: 40)
            hud.label.numberOfLines = 0
            hud.contentColor = .white
            hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: delayTime)
            hud.completionBlock = {
                if let block = completionBlock {
                    block()
                }
            }
        }
    }

    /// 隐藏hud
    ///
    /// - Parameter animated: 是否执行动画，默认为true
    public func hideHud(animated: Bool = true,
                        completionBlock: (() -> Void)? = nil) {
        let hud = self.hudForView()
        hud?.hide(animated: animated, afterDelay: 0.25)
        hud?.completionBlock = {
            if let block = completionBlock {
                block()
            }
        }
    }

    // MARK: - private method
    /// 隐藏倒计时View
    private func hideTimerHud(view: UIView) {
        let elements = view.subviews.reversed()
        for view in elements {
            if view is TDTimerView {
                let timerView = view as? TDTimerView
                timerView?.stopTimer()
                timerView?.removeFromSuperview()
            }
            hideTimerHud(view: view)
        }
    }

    /// 返回当前view最顶部的HUD
    ///
    /// - Returns: 返回当前view最顶部的HUD
    private func hudForView() -> MBProgressHUD? {
        let elements = self.subviews.reversed()
        for view in elements {
            if view is MBProgressHUD {
                return view as? MBProgressHUD
            }
        }

        return nil
    }

    /// 当前view是否已经显示了hud
    ///
    /// - Returns: true/false
    private func isHudShow() -> Bool {
        for subView in self.subviews {
            if subView is MBProgressHUD {
                return true
            }
        }

        return false
    }

    /// hud显示模式切换的时候，先移除自定义的视图，防止默认提示label和自定的视图重叠
    /// 递归遍历所有子视图，找到自定义的loding（TDLoadingView）就移除
    /// - Parameter view: 当前view
    private func hideCustomLoadingView(view: UIView) {
        for subView in view.subviews {
            if subView is TDLoadingView {
                let view = subView as! TDLoadingView
                view.stopAnimating()
                view.isHidden = true
                view.removeFromSuperview()
                return
            }
            hideCustomLoadingView(view: subView)
        }
    }
}

extension String {
    func isEmptyString() -> Bool {
        if self.isEmpty || self.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
            return true
        }
        return false
    }
}


