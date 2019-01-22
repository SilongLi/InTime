//
//  SelectedCategoryView.swift
//  InTime
//
//  Created by lisilong on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import SnapKit

class SelectedCategoryView: UIView {
    
    fileprivate let CategoryCellId = "SelectedCategoryViewCellId"
    fileprivate let duration: TimeInterval = 0.25
    fileprivate let lineH: CGFloat = 0.5
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.tintColor.withAlphaComponent(0.85)
        tableView.separatorColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryCellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var bgMaskView: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(maskViewAction), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor.tintColor.withAlphaComponent(0.3)
        btn.alpha = 0.0
        return btn
    }()
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "showDetail"))
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "全部"
        return titleLabel
    }()
    
    var dataSource: [CategoryModel] = [CategoryModel]()
    var cellHeight: CGFloat = 50.0
    let margin: CGFloat = (IT_IPHONE_X || IT_IPHONE_6P) ? 40.0 : 30.0
    var selectedCategoryBlock: ((_ model: CategoryModel?) -> ())?
    var isShow: Bool = false
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - actions
    
    /// 展示列表和遮罩
    func showListView() {
        guard !isShow else {
            return
        }
        isShow = true
        addSubview(bgMaskView)
        addSubview(tableView)
        
        bgMaskView.frame = CGRect.init(x: 0.0, y: 0.0, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT - IT_NaviHeight)
        UIView.animate(withDuration: self.duration, animations: {
            self.bgMaskView.alpha = 1
        })
         
        tableView.frame = CGRect(x: margin, y: 0.0, width: IT_SCREEN_WIDTH - margin * 2, height: 0.01)
        let count: CGFloat = CGFloat(dataSource.count)
        let markViewH = (IT_SCREEN_HEIGHT - IT_NaviHeight - cellHeight) * 0.8
        let tableViewH = count * self.cellHeight > markViewH ? markViewH : count * self.cellHeight + margin
        UIView.animate(withDuration: self.duration, animations: {
            self.tableView.frame = CGRect(x: self.margin, y: 0.0, width: IT_SCREEN_WIDTH - self.margin * 2, height: tableViewH)
        })
        tableView.layer.cornerRadius = 16.0
        tableView.layer.masksToBounds = true
        tableView.reloadData()
    }
    
    /// 收起列表和遮罩
    func hiddenListView() {
        isShow = false
        self.disminssMarkView()
        self.hiddenTableView()
    }
    
    /// 移除遮罩
    func disminssMarkView() {
        guard self.bgMaskView.superview != nil else {
            return
        }
        UIView.animate(withDuration: self.duration, animations: {
            self.bgMaskView.alpha = 0
        }, completion: { (_) in
            self.bgMaskView.removeFromSuperview()
        })
    }
    
    /// 隐藏列表
    private func hiddenTableView() {
        guard tableView.superview != nil else {
            return
        }
        UIView.animate(withDuration: duration, animations: {
            self.tableView.frame = CGRect(x: self.margin, y: 0.0, width: IT_SCREEN_WIDTH - self.margin * 2, height: 0.01)
        }) { (_) in
            self.tableView.removeFromSuperview()
        }
    }
    
    /// 点击遮罩，退出列表页
    @objc func maskViewAction() {
        hiddenListView()
        if let block = self.selectedCategoryBlock {
            block(nil)
        }
    }
    
    /// 当下拉列表展开的时候，拦截用户的点击事件，让下拉列表页接受交互事件。
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if view == nil {
            for subView in self.subviews {
                let tp = subView.convert(point, from: self)
                if subView.bounds.contains(tp) {
                    view = subView
                }
            }
        }
        return view
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension SelectedCategoryView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCellId, for: indexPath) as! CategoryTableViewCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for index in 0..<dataSource.count {
            dataSource[index].isSelected = false
        }
        var model = dataSource[indexPath.row]
        model.isSelected = true
        dataSource[indexPath.row] = model
        if let block = self.selectedCategoryBlock {
            block(model)
        }
        hiddenListView()
    }
}
