//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by lisilong on 2019/11/23.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
         
        loadLocalCategorys { (categorys) in
            print(categorys)
        }
    }
    
    // MARK: - widget
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let height: CGFloat = activeDisplayMode == .expanded ? 200.0 : 500.0
        self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: height)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - actions
      
    @objc func gotoMainVC() {
        guard let schema = URL.init(string: "IncomeTodayWidget://1987") else { return }
        self.extensionContext?.open(schema, completionHandler: { (success) in
            CommonTools.printLog(message: success ? "跳转到知时节主工程成功！" :  "跳转到知时节主工程失败！")
        })
    }
         
    // MARK: - load dataSource
    
    /// 加载所有的分类类别
    func loadLocalCategorys(completion: (_ categorys: [CategoryModel]) -> ()) {
        var models: [CategoryModel] = [CategoryModel]()
        if let data = HandleAppGroupsDocumentMannager.getCategorys() {
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
}
