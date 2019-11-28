//
//  ITSettingsViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/11/27.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITSettingsViewModel: NSObject {
    static let CellHeight: CGFloat = 50.0
    
    static func loadListSections(completion: (_ sections: [BaseSectionModel]) -> ()) {
          
        /// 是否显示到主屏幕
        let showBg = ShowInMainScreenModel()
        showBg.name = "Widget小组件显示背景图片"
        showBg.isShow = true
        let showBgSection = BaseSectionModel(cellIdentifier: SettingCellIdType.showBgImageInWidget.rawValue,
                                               headerTitle: "",
                                               footerTitle: "",
                                               headerHeight: 20.0,
                                               footerHeight: 10.0,
                                               cellHeight: CellHeight,
                                               showCellCount: 1,
                                               items: [showBg])
        
        let feedback = ShowInMainScreenModel()
        feedback.name = "意见反馈"
        feedback.isShow = true
        let feedbackSection = BaseSectionModel(cellIdentifier: SettingCellIdType.feedback.rawValue,
                                               headerTitle: "",
                                               footerTitle: "",
                                               headerHeight: 10.0,
                                               footerHeight: 10.0,
                                               cellHeight: CellHeight,
                                               showCellCount: 1,
                                               items: [feedback])
        
        completion([showBgSection, feedbackSection])
    }
}
