//
//  BaseTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    /// 更加模型数据更新UI，方式一
    var item: ViewModelProtocol?

    /// 更加模型数据更新UI，方式二
    func setupContent<T>(model: T, indexPath: IndexPath = IndexPath()) {}

    /// 根据数据计算高度
    ///
    /// - Parameter model: 模型数据
    /// - Returns: 视图高度
    func calculateCellHeight<T>(_ model: T) -> CGFloat { return 0.0 }
}
