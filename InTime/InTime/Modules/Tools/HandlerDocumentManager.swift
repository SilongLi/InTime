//
//  HandlerDocumentManager.swift
//  InTime
//
//  Created by lisilong on 2019/1/21.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import CoreGraphics

enum DocumentType: String {
    case categorys = "Categorys"
    case seasons = "Seasons"
    case images = "images"
}

class HandlerDocumentManager {

    // MARK: - 时节分类处理
    @discardableResult
    public static func saveCategorys(data: Data?) -> Bool {
        guard data != nil, let filePath = self.getCategoryFilePath() else {
            return false
        }
        return NSKeyedArchiver.archiveRootObject(data!, toFile: filePath)
    }
    
    public static func getCategorys() -> Data? {
        guard let filePath = self.getCategoryFilePath() else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
    }
    
    // MARK: - 时节处理
    @discardableResult
    public static func saveSeasons(seasonType: String, data: Data?) -> Bool {
        guard data != nil, let filePath = self.getSeasonsFilePath(seasonType) else {
            return false
        }
        return NSKeyedArchiver.archiveRootObject(data!, toFile: filePath)
    }
    
    public static func getSeasons(seasonType: String) -> Data? {
        guard let filePath = self.getSeasonsFilePath(seasonType) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
    }
    
    // MARK: - 保存自定义背景图片处理
    @discardableResult
    public static func saveCustomImage(seasonId: String, imageData: Data?) -> Bool {
        guard imageData != nil, var filePath = self.rootFilePath(type: .images) else {
            return false
        }
        filePath = (filePath as NSString).appendingPathComponent("\(seasonId).png")
        return NSKeyedArchiver.archiveRootObject(imageData!, toFile: filePath)
    }
    
    // MARK: - 获取自定义背景图片
    @discardableResult
    public static func getCustomImage(seasonId: String) -> Data? {
        guard !seasonId.isEmpty, var filePath = self.rootFilePath(type: .images) else {
            return nil
        }
        filePath = (filePath as NSString).appendingPathComponent("\(seasonId).png")
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
    }
    
    // MARK: - 删除自定义背景图片
    @discardableResult
    public static func deleteCustomImage(seasonId: String) -> Bool {
        guard !seasonId.isEmpty, var filePath = self.rootFilePath(type: .images) else {
            return false
        }
        filePath = (filePath as NSString).appendingPathComponent("\(seasonId).png")
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    
    // MARK: - 文件路径
    
    /// 获取时节分类文件路径
    private static func getCategoryFilePath() -> String? {
        guard let filePath = self.rootFilePath(type: .categorys) else {
            return nil
        }
        return (filePath as NSString).appendingPathComponent("Category.json")
    }
    
    /// 获取时节文件路径
    ///
    /// - Parameter name: 文件名称
    /// - Returns: 返回保存广告资源的文件路径
    private static func getSeasonsFilePath(_ name: String) -> String? {
        guard let filePath = self.rootFilePath(type: .seasons) else {
            return nil
        }
        return (filePath as NSString).appendingPathComponent(name + ".json")
    }
    
    private static func rootFilePath(type: DocumentType) -> String? {
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        filePath = (filePath as NSString).appendingPathComponent("InTime")
        filePath = (filePath as NSString).appendingPathComponent(type.rawValue)
        if !FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return nil
            }
        }
        return filePath
    }
}
