//
//  HandleAppGroupsDocumentMannager.swift
//  InTime
//
//  Created by lisilong on 2019/11/23.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

private let AppGroupID = "group.Capabilities.Income"
private let CagetoryJSONName = "InTimeCagetoryJSON.json"
private let SeasonJSONName = "InTimeSeason.json"
private let ImageName = "_InTimeImage.png"

private let IsShowBgImageViewInMainScreenKey = "IsShowBgImageViewInMainScreen"

class HandleAppGroupsDocumentMannager: NSObject {
    
    // MARK: - 时节分类
    @discardableResult
    public static func saveCategorys(data: Data?) -> Bool {
        let fileURL = self.getAppGrouCategoryFileURL()
        return HandleAppGroupsDocumentMannager.saveDataWithFileURL(fileURL, data: data)
    }
    
    public static func getCategorys() -> Data? {
        let fileURL = self.getAppGrouCategoryFileURL()
        return HandleAppGroupsDocumentMannager.getDataWithFileURL(fileURL)
    }
    
    // MARK: - 时节处理
    @discardableResult
    public static func saveSeasons(seasonType: String, data: Data?) -> Bool {
        let fileURL = self.getAppGroupSeasonsFileURL(seasonType)
        return HandleAppGroupsDocumentMannager.saveDataWithFileURL(fileURL, data: data)
    }
    
    public static func getSeasons(seasonType: String) -> Data? {
        let fileURL = self.getAppGroupSeasonsFileURL(seasonType)
        return HandleAppGroupsDocumentMannager.getDataWithFileURL(fileURL)
    }
    
    // MARK: - 保存自定义背景图片处理
    @discardableResult
    public static func saveCustomImage(imageName: String, imageData: Data?) -> Bool {
        let fileURL = self.getAppGroupImageFileURL(imageName)
        return HandleAppGroupsDocumentMannager.saveDataWithFileURL(fileURL, data: imageData)
    }
    
    // MARK: - 获取自定义背景图片
    @discardableResult
    public static func getCustomImage(imageName: String) -> Data? {
        let fileURL = self.getAppGroupImageFileURL(imageName)
        return HandleAppGroupsDocumentMannager.getDataWithFileURL(fileURL)
    }
    
    // MARK: - 删除自定义背景图片
    @discardableResult
    public static func deleteCustomImage(imageName: String) -> Bool {
        guard !imageName.isEmpty, let fileURL = self.getAppGroupImageFileURL(imageName) else {
            return false
        }
        if let _ = HandleAppGroupsDocumentMannager.getCustomImage(imageName: imageName) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                CommonTools.printLog(message: error)
                return false
            }
        }
        return true
    }
    
    // MARK: - App Group Root File URL
    
    private static func saveDataWithFileURL(_ fileURL: URL?, data: Data?) -> Bool {
        guard let fileURL = fileURL, let data = data else {
            return false
        }
        do {
            try data.write(to: fileURL, options: Data.WritingOptions.atomic)
        } catch {
            CommonTools.printLog(message: error)
            return false
        }
        return true
    }
    
    private static func getDataWithFileURL(_ fileURL: URL?) -> Data? {
        guard let fileURL = fileURL else {
            return nil
        }
        var data: Data?
        do {
            try data = Data.init(contentsOf: fileURL, options: Data.ReadingOptions.mappedIfSafe)
        } catch {
            CommonTools.printLog(message: error)
            return data
        }
        return data
    }
    
    private static func getAppGrouCategoryFileURL() -> URL? {
        guard let fileURL = self.rootAppGroupFileURL() else {
            return nil
        }
        return fileURL.appendingPathComponent(CagetoryJSONName)
    }
    
    private static func getAppGroupSeasonsFileURL(_ name: String) -> URL? {
        guard let fileURL = self.rootAppGroupFileURL() else {
            return nil
        }
        return fileURL.appendingPathComponent(name + SeasonJSONName)
    }
    
    private static func getAppGroupImageFileURL(_ name: String) -> URL? {
        guard let fileURL = self.rootAppGroupFileURL() else {
            return nil
        }
        return fileURL.appendingPathComponent(name + ImageName)
    }
    
    private static func rootAppGroupFileURL() -> URL? {
        let dataFileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupID)
        return dataFileURL
    }
    
    // MARK: - UserDefaults
    
    /// 存储Widget组件是否显示背景图片
    public static func saveShowBgImageInMainScreen(_ isShow: Bool) {
        if let userDefault = HandleAppGroupsDocumentMannager.userDefault() {
            userDefault.set(isShow, forKey: IsShowBgImageViewInMainScreenKey)
        }
    }
    
    // 获取Widget组件是否显示背景图片
    public static func isShowBgImageInMainScreen() -> Bool {
        if let userDefault = HandleAppGroupsDocumentMannager.userDefault() {
           return userDefault.bool(forKey: IsShowBgImageViewInMainScreenKey)
        }
        return false
    }
    
    private static func userDefault() -> UserDefaults? {
        if let userDefaults = UserDefaults.init(suiteName: AppGroupID) {
            return userDefaults
        }
        return nil
    }
}
