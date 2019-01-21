//
//  CategoryModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 类别模型

struct CategoryModel: SelectedViewModelProtocol {
    var id: String = ""
    var title: String = ""
    var isSelected: Bool = false
}

extension CategoryModel {
    static func convertToModel(json: JSON) -> CategoryModel {
        var model = CategoryModel()
        model.id = json["id"].stringValue
        model.title = json["title"].stringValue
        model.isSelected = json["isSelected"].boolValue
        return model
    }
    
    func convertToJson() -> Dictionary<String, Any> {
        return ["id": id,
                "title": title,
                "isSelected": isSelected]
    }
}
