//
//  UILabel+Extension.swift
//  PrivateEquity
//
//  Created by LuoJieFeng on 2017/8/4.
//  Copyright © 2017年 TDW.CN. All rights reserved.
//

import UIKit
import Foundation

extension NamespaceWrapper where Base: UILabel {

    /// 设置行间距和富文本颜色
    ///
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - strArray: 文本集合
    ///   - colorArray: 颜色集合
    ///   - fontColor: 字体集合
    public func setLineSpacing(lineSpacing: Int,
                               strArray: [String],
                               colorArray: [UIColor],
                               fontColor: [UIFont]) {
        var length = 0
        var mutableString = ""
        for text in strArray where text.isEmpty == false {
                mutableString.append(text)
        }

        let attributeString = NSMutableAttributedString(string: mutableString)
        // 设置富文本文字颜色、字体大小
        for i in 0 ..< strArray.count {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: colorArray[i], NSAttributedString.Key.font: fontColor[i]],
                                          range: NSRange(location: length, length: strArray[i].count))
            length += strArray[i].count
        }

        // 设置富文本行间距
        if lineSpacing != 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
            attributeString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                          range: NSRange(location: 0, length: attributeString.length))
        }

        wrappedValue.attributedText = attributeString
    }

    /// 设置字体的行间距
    ///
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - availableWidth: 文本宽度
    public func setLineSpacing(lineSpacing: CGFloat, availableWidth: CGFloat) {
        let textString = wrappedValue.text
        guard textString != nil else {
            return
        }
        let height = self.heightForText(text: textString, availableWidth: availableWidth)
        let range = NSRange(location: 0, length: (wrappedValue.attributedText?.string.count)!)
        if height > 2 * wrappedValue.font.pointSize {
            let mutableAttribute = NSMutableAttributedString(string: textString!)
            let paragraphStyle   = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            paragraphStyle.minimumLineHeight = wrappedValue.font.pointSize
            paragraphStyle.lineSpacing = lineSpacing
            mutableAttribute.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            wrappedValue.attributedText = mutableAttribute
        } else {
            return
        }
    }

    /// 获取字体高度
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - availableWidth: 文本宽度
    /// - Returns: 字体高度
    public func heightForText(text: String?, availableWidth: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: wrappedValue.font.pointSize)
        let textSize = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
        let attribute = [NSAttributedString.Key.font: font]
        let rect = text?.boundingRect(with: textSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute, context: nil)
        return rect?.height ?? 0
    }

    /// UILabel展示HTML文本
    ///
    /// - Parameters:
    ///   - htmlString: html文本
    public func loadHtmlString(htmlString: String) {
        if let data = htmlString.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            let attrStr = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)

            wrappedValue.attributedText = attrStr
        }
    }

    /// 拼接字符串
    ///
    /// - Parameters:
    ///   - str: 传入字符串
    ///   - fontSize: 字体大小
    ///   - color: 颜色
    public func appendColorStrWithString(str: String,
                                         fontSize: CGFloat,
                                         color: UIColor,
                                         baselineOffset: CGFloat = 0) {
        let attributedString = NSMutableAttributedString(string: "")
        let attStr = NSMutableAttributedString(string: str,
                                               attributes: [
                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                                                NSAttributedString.Key.foregroundColor: color,
                                                NSAttributedString.Key.baselineOffset: baselineOffset])
        if let hasAttribute = wrappedValue.attributedText {
            attributedString.append(hasAttribute)
        }
        attributedString.append(attStr)
        wrappedValue.attributedText = attributedString
    }

    /// 自定义字体及显示样式
    ///
    /// - Parameters:
    ///   - text: 文本内容
    ///   - fontName: 字体
    ///   - fontSize: 字号
    ///   - color: 字体颜色
    @discardableResult
    public func attributedText(text: String, fontName: String, fontSize: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes([NSAttributedString.Key.font: font,
                                      NSAttributedString.Key.foregroundColor: color],
                                     range: NSRange(location: 0, length: text.count))
        wrappedValue.attributedText = attributedText
        return attributedText
    }

    /// 动态获取 UILabel 的高度
    ///
    /// - Parameters:
    ///   - label: label 界面上已经布局的 label1 或者自己初始化 label2 传入计算，但是 label2 的属性要同 label1 相同
    ///   - width: 最大宽度
    /// - Returns: CGFloat
    public func dynamicHeightOfLabel(_ width: CGFloat) -> CGFloat {
        let size = wrappedValue.sizeThatFits(CGSize(width: width, height: CGFloat.infinity))
        return ceil(size.height) + 1
    }
}
