//
//  HomeSeasonViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/21.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import CoreGraphics

let DatestringWithFormat: String = "yyyyMMddHHmmssSSS"

/// 加载本地时节
class HomeSeasonViewModel {
    
    /// 默认分类时节
    static func initDefaultCategorys() {
        let data = HandlerDocumentManager.getCategorys()
        guard data == nil else {
            return
        }
        var home = CategoryModel()
        home.id = NSDate().string(withFormat: DatestringWithFormat) + "1"
        home.title = "首页"
        home.isSelected = true
        home.isDefalult = true
        let homeJson = home.convertToJson()
        let homeJsonStr = homeJson.convertToString
        
        var season = CategoryModel()
        season.id = NSDate().string(withFormat: DatestringWithFormat) + "2"
        season.title = "时节"
        season.isSelected = false
        let seasonJson = season.convertToJson()
        let seasonJsonStr = seasonJson.convertToString
        
        var ring = CategoryModel()
        ring.id = NSDate().string(withFormat: DatestringWithFormat) + "3"
        ring.title = "闹铃"
        ring.isSelected = false
        let ringJson = ring.convertToJson()
        let ringJsonStr = ringJson.convertToString
        
        let categoryJsons = [homeJsonStr, seasonJsonStr, ringJsonStr]
        let categoryData = NSKeyedArchiver.archivedData(withRootObject: categoryJsons)
        HandlerDocumentManager.saveCategorys(data: categoryData)
    }
    
    /// 保存时节分类
    ///
    /// - Parameter name: 分类名称
    /// - Returns: 是否保存成功
    @discardableResult
    static func saveCategory(name: String) -> Bool {
        guard !name.isEmpty else {
            return false
        }
        var category = CategoryModel()
        category.id = NSDate().string(withFormat: DatestringWithFormat)
        category.title = name
        category.isSelected = false
        let categoryJson = category.convertToJson()
        let categoryJsonStr = categoryJson.convertToString
        
        var categoryStrs = [categoryJsonStr]
        if let data = HandlerDocumentManager.getCategorys() {
            let categoryJsons = NSKeyedUnarchiver.unarchiveObject(with: data)
            if categoryJsons is Array<String>, let jsonStrs: [String] = categoryJsons as? [String] {
                /// 判断是否已经存在
                guard jsonStrs.contains(categoryJsonStr) == false else {
                    return false
                }
                categoryStrs.append(contentsOf: jsonStrs)
            }
        }
        let categoryData = NSKeyedArchiver.archivedData(withRootObject: categoryStrs)
        return HandlerDocumentManager.saveCategorys(data: categoryData)
    }
    
    @discardableResult
    static func saveAllCategorys(_ categorys: [CategoryModel]) -> Bool {
        guard !categorys.isEmpty else {
            return false
        }
        var categoryStrs: [String] = [String]()
        for model in categorys {
            let categoryJson = model.convertToJson()
            let categoryJsonStr = categoryJson.convertToString
            categoryStrs.append(categoryJsonStr)
        }
        let categoryData = NSKeyedArchiver.archivedData(withRootObject: categoryStrs)
        return HandlerDocumentManager.saveCategorys(data: categoryData)
    }
    
    /// 加载所有的分类类别
    static func loadLocalCategorys(completion: (_ categorys: [CategoryModel]) -> ()) {
        var models: [CategoryModel] = [CategoryModel]()
        if let data = HandlerDocumentManager.getCategorys() {
            let categoryJsons = NSKeyedUnarchiver.unarchiveObject(with: data)
            if categoryJsons is Array<String>, let jsonStrs: [String] = categoryJsons as? [String] {
                for jsonStr in jsonStrs {
                    let json = JSON(parseJSON: jsonStr)
                    let model = CategoryModel.convertToModel(json: json)
                    models.append(model)
                }
            }
        }
        completion(models)
    }
    
    /// 加载当前类别下的所有时节
    static func loadLocalSeasons(categoryId: String, completion: (_ seasons: [SeasonModel]) -> ()) {
        var models: [SeasonModel] = [SeasonModel]()
        if let seasonsData = HandlerDocumentManager.getSeasons(categoryId: categoryId) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, let jsonStrs: [String] = seasonJsons as? [String] {
                for jsonStr in jsonStrs {
                    let json = JSON(parseJSON: jsonStr)
                    let model = SeasonModel.convertToModel(json: json)
                    models.append(model)
                }
            }
        }
        completion(models)
    }
}
