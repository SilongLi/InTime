//
//  BaseViewModelProtocol.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation
import CoreGraphics

/// TableView section 信息结构体模型协议，包含 section 标题信息等
protocol TableViewSectionProtocol {
    var cellIdentifier: String { get }
    var headerTitle: String { get }
    var footerTitle: String { get }
    var headerHeight: CGFloat { get }
    var footerHeight: CGFloat { get }
    var cellHeight: CGFloat { get }
    var showCellCount: Int { get }
    var items: [ViewModelProtocol] { get }
}

/// View需要的Model数据统一需要实现的protocol
protocol ViewModelProtocol {
    // 用于缓存，通过数据计算的视图高度
    var cellHeight: CGFloat { get set }
}
