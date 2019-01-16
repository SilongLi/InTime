//
//  UIImage+CreateImage.swift
//  PaishengFinance
//
//  Created by lisilong on 2018/1/11.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

import UIKit

public let kDFMBSize: UInt = 1024 * 1024
public let kDFKBSize: UInt = 1024
public let kDFGBSize: UInt = 1024 * 1024 * 1024

extension UIImage {
    /// 根据UIColor创建UIImage
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    /// - Returns: 图片
    public class func creatImage(color: UIColor, size: CGSize = CGSize.init(width: 100, height: 100)) -> UIImage {
        let size = (size == CGSize.zero ? CGSize.init(width: 100, height: 100): size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// 计算图片缓存具体大小
    ///
    /// - Parameter cacheSize: UInt
    /// - Returns: String
    public class func pictureCacheSize(_ cacheSize: UInt) -> String {
        if cacheSize > kDFGBSize {
            let unit = kDFGBSize
            let retF = cacheSize/unit
            return String(format: "%.1f", Float(retF)) + "GB"
        } else if cacheSize > kDFMBSize {
            let unit = kDFMBSize
            let retF = cacheSize/unit
            return String(format: "%.1f", Float(retF)) + "MB"
        } else if cacheSize > kDFKBSize {
            let unit = kDFKBSize
            let retF = cacheSize/unit
            return String(format: "%.1f", Float(retF)) + "KB"
        } else {
            return "0KB"
        }
    }

    /// 获取项目中的App启动页图片
    ///
    /// - Returns: 返回启动页图片
    public class func loadLaunchImage() -> UIImage? {
        let viewSize    = UIScreen.main.bounds.size
        let orientation = UIApplication.shared.statusBarOrientation
        let viewOrientation = (orientation == .landscapeLeft || orientation == .landscapeRight) ? "Landscape" : "Portrait"
        var imageName: UIImage?
        let imagesInfoArray = Bundle.main.infoDictionary!["UILaunchImages"]
        guard imagesInfoArray != nil else {
            return nil
        }
        for dict: [String: String] in imagesInfoArray as! Array {
            let imageSize = NSCoder.cgSize(for: dict["UILaunchImageSize"]!)
            if imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"]! as String {
                imageName = UIImage(named: dict["UILaunchImageName"]!)
            }
        }
        return imageName
    }
}
