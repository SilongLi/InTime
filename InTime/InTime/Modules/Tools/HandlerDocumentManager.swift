//
//  HandlerDocumentManager.swift
//  InTime
//
//  Created by lisilong on 2019/1/21.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

private enum DocumentType: String {
    case categorys = "Categorys"
    case seasons = "Seasons"
    case images = "images"
}

private let HasRemovedAllCategerysDataToAppGroupKey = "HasRemovedAllCategerysDataToAppGroup"
private let HasRemovedAllSeasonsDataToAppGroupKey = "HasRemovedAllSeasonsDataToAppGroup"
private let HasRemovedAllImagesDataToAppGroupKey = "HasRemovedAllImagesDataToAppGroup"

class HandlerDocumentManager {
    
    // MARK: - 把本地所有旧数据导入App group中
    public static func importAllLocalOldDataIntoTheAppGroup(_ seasonType: String) {
        // 转移分类数据
        if !UserDefaults.standard.bool(forKey: HasRemovedAllCategerysDataToAppGroupKey) {
            let categoryData = HandlerDocumentManager.getCategorys()
            if let categoryData = categoryData {
                let success = HandleAppGroupsDocumentMannager.saveCategorys(data: categoryData)
                CommonTools.printLog(message:success ? "成功把本地所有旧分类数据导入App Group中。" : "把本地所有旧分类数据导入App Group失败！")
                if success {
                    UserDefaults.standard.set(true, forKey: HasRemovedAllCategerysDataToAppGroupKey)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        
        // 转移时节数据
        if !UserDefaults.standard.bool(forKey: HasRemovedAllSeasonsDataToAppGroupKey) {
            let seasonsData = HandlerDocumentManager.getSeasons(seasonType: seasonType)
            if let seasonsData = seasonsData {
                let success = HandleAppGroupsDocumentMannager.saveSeasons(seasonType: seasonType, data: seasonsData)
                CommonTools.printLog(message:success ? "成功把本地所有旧时节数据导入App Group中。" : "把本地所有旧时节数据导入App Group失败！")
                if success {
                    UserDefaults.standard.set(true, forKey: HasRemovedAllSeasonsDataToAppGroupKey)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        
        // 转移图片数据
        if !UserDefaults.standard.bool(forKey: HasRemovedAllImagesDataToAppGroupKey) {
            let seasonsData = HandlerDocumentManager.getSeasons(seasonType: seasonType)
            if let seasonsData = seasonsData {
                let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
                if seasonJsons is Array<String>, let jsonStrs: [String] = seasonJsons as? [String] {
                    var isAllSuccess = true
                    for jsonStr in jsonStrs {
                        let json = JSON(parseJSON: jsonStr)
                        let season = SeasonModel.convertToModel(json: json)
                        if season.backgroundModel.type == .custom {
                            let imageData = HandlerDocumentManager.getCustomImage(imageName: season.backgroundModel.name)
                            let success = HandleAppGroupsDocumentMannager.saveCustomImage(imageName: season.backgroundModel.name, imageData: imageData)
                            CommonTools.printLog(message:success ? "成功把本地所有旧图片数据导入App Group中。" : "把本地所有旧图片数据导入App Group失败！")
                            if !success {
                                isAllSuccess = false
                            }
                        }
                    }
                    
                    if isAllSuccess {
                        UserDefaults.standard.set(true, forKey: HasRemovedAllImagesDataToAppGroupKey)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    

    // MARK: - 时节分类处理
    @discardableResult
    private static func saveCategorys(data: Data?) -> Bool {
        guard data != nil, let filePath = self.getCategoryFilePath() else {
            return false
        }
        return NSKeyedArchiver.archiveRootObject(data!, toFile: filePath)
    }
    
    private static func getCategorys() -> Data? {
        guard let filePath = self.getCategoryFilePath() else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
    }
    
    // MARK: - 时节处理
    @discardableResult
    private static func saveSeasons(seasonType: String, data: Data?) -> Bool {
        guard data != nil, let filePath = self.getSeasonsFilePath(seasonType) else {
            return false
        }
        return NSKeyedArchiver.archiveRootObject(data!, toFile: filePath)
    }
    
    private static func getSeasons(seasonType: String) -> Data? {
        guard let filePath = self.getSeasonsFilePath(seasonType) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
    }
    
    // MARK: - 保存自定义背景图片处理
    @discardableResult
    private static func saveCustomImage(imageName: String, imageData: Data?) -> Bool {
        guard imageData != nil, var filePath = self.rootFilePath(type: .images) else {
            return false
        }
        filePath = (filePath as NSString).appendingPathComponent("\(imageName).png")
        return NSKeyedArchiver.archiveRootObject(imageData!, toFile: filePath)
    }
    
    // MARK: - 获取自定义背景图片
    @discardableResult
    private static func getCustomImage(imageName: String) -> Data? {
        guard !imageName.isEmpty, var filePath = self.rootFilePath(type: .images) else {
            return nil
        }
        filePath = (filePath as NSString).appendingPathComponent("\(imageName).png")
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data
    }
    
    // MARK: - 删除自定义背景图片
    @discardableResult
    private static func deleteCustomImage(imageName: String) -> Bool {
        guard !imageName.isEmpty, var filePath = self.rootFilePath(type: .images) else {
            return false
        }
        filePath = (filePath as NSString).appendingPathComponent("\(imageName).png")
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
                CommonTools.printLog(message: error)
                return nil
            }
        }
        return filePath
    }
}
