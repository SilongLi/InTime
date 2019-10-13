//
//  HomeSeasonViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/21.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

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
        home.title = "全部"
        home.isSelected = true
        home.isDefault = true
        let homeJson = home.convertToJson()
        let homeJsonStr = homeJson.convertToString
        
        var ring = CategoryModel()
        ring.id = NSDate().string(withFormat: DatestringWithFormat) + "2"
        ring.title = "闹铃"
        ring.isSelected = false
        ring.iconName = "ringIcon"
        let ringJson = ring.convertToJson()
        let ringJsonStr = ringJson.convertToString
        
        var anniversaries = CategoryModel()
        anniversaries.id = NSDate().string(withFormat: DatestringWithFormat) + "3"
        anniversaries.title = "纪念日"
        anniversaries.isSelected = false
        anniversaries.iconName = "anniversary"
        let anniversariesJson = anniversaries.convertToJson()
        let anniversariesJsonStr = anniversariesJson.convertToString
        
        let categoryJsons = [homeJsonStr, ringJsonStr, anniversariesJsonStr]
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
                for jsonStr in jsonStrs {
                    let json = JSON(parseJSON: jsonStr)
                    if json["title"].stringValue == name {
                        return false
                    }
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
        HomeSeasonViewModel.loadAllSeasons { (seasons) in
            var models: [SeasonModel] = [SeasonModel]()
            for season in seasons {
                if season.categoryId == categoryId {
                    models.append(season)
                }
            }
            completion(models)
        }
    }
    
    /// 获取所有时节
    static func loadAllSeasons(completion: (_ seasons: [SeasonModel]) -> ()) {
        var seasons = [SeasonModel]()
        if let seasonsData = HandlerDocumentManager.getSeasons(seasonType: HomeRingSeasonsKey) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, let jsonStrs: [String] = seasonJsons as? [String] {
                for jsonStr in jsonStrs {
                    let json = JSON(parseJSON: jsonStr)
                    let model = SeasonModel.convertToModel(json: json)
                    seasons.append(model)
                }
            }
        }
        completion(seasons)
    }
}
