//
//  BaseModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation 

class BaseModel: ViewModelProtocol {
    var cellHeight: CGFloat = 0.0
    required init() {}
}

struct BaseSectionModel: TableViewSectionProtocol {
    var cellIdentifier: String
    var headerTitle: String
    var footerTitle: String
    var headerHeight: CGFloat
    var footerHeight: CGFloat
    var cellHeight: CGFloat
    var showCellCount: Int
    var items: [ViewModelProtocol]

    init(cellIdentifier: String,
         headerTitle: String = "",
         footerTitle: String = "",
         headerHeight: CGFloat = 0.0,
         footerHeight: CGFloat = 0.0,
         cellHeight: CGFloat = 0.0,
         showCellCount: Int = 0,
         items: [ViewModelProtocol]) {
        self.cellIdentifier = cellIdentifier
        self.headerTitle    = headerTitle
        self.footerTitle    = footerTitle
        self.headerHeight   = headerHeight
        self.footerHeight   = footerHeight
        self.cellHeight     = cellHeight
        self.showCellCount  = showCellCount
        self.items          = items
    }
}
