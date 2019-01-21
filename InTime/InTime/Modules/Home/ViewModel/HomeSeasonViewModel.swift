//
//  HomeSeasonViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/21.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import CoreGraphics

let CategorysKey: String = "categorys"

/// 加载本地时节
class HomeSeasonViewModel {
    
    // 保存分类
    static func saveCategory(name: String) {
        var category = CategoryModel()
        category.id = NSDate().string(withFormat: "yyyyMMddHHmmss")
        category.title = name
        category.isSelected = false
        let categoryJson = category.convertToJson()
        let categoryJsonStr = categoryJson.comvertToString
        
        
        var category1 = CategoryModel()
        category1.id = NSDate().string(withFormat: "yyyyMMddHHmmss")
        category1.title = "纪念日"
        category1.isSelected = false
        let categoryJson1 = category1.convertToJson()
        let categoryJsonStr1 = categoryJson1.comvertToString
        
        let categoryJsons = [categoryJsonStr, categoryJsonStr1]
        let categoryData = NSKeyedArchiver.archivedData(withRootObject: categoryJsons)
        HandlerDocumentManager.saveCategorys(data: categoryData)
    }
    
    
    /// 加载所有的分类类别
    static func loadLocalSeasonTypes(completion: (_ seasonTypes: [CategoryModel]) -> ()) {
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
    static func loadLocalSeasons(completion: (_ seasons: [SeasonModel]) -> ()) {
       
//       let season = SeasonModel()
//        season
//
//        /// 所属类别
//        var categoryModel: CategoryModel = CategoryModel()
//        /// 标题
//        var title: String = ""
//        /// 时节时间
//        var startDate: TimeModel = TimeModel()
//        /// 显示单位
//        var unitModel: InfoSelectedModel = InfoSelectedModel()
//        /// 是否开启闹铃提醒
//        var isOpenRemind: Bool = true
//        /// 重复提醒类型
//        var repeatRemindType: RepeatRemindType = RepeatRemindType.no
//        /// 自定义背景
//        var backgroundModel: BackgroundImageModel = BackgroundImageModel()
//        /// 字体颜色
//        var textColor: UIColor = UIColor.white
    }
}
