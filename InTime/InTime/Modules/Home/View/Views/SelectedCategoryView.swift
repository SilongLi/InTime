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
    
    fileprivate let cellId = "SelectedCategoryViewCellId"
    fileprivate let duration: TimeInterval = 0.25
    fileprivate let lineH: CGFloat = 0.5
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.tintColor
        tableView.separatorColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.accessibilityLabel = "Product_List_Drop_List_Table_View_Hidden"
        tableView.isAccessibilityElement = true
        return tableView
    }()
    
    var bgMaskView: UIView?
    
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
    var selectedCategoryBlock: ((_ model: CategoryModel?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupbgMaskView()
        setupsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    func setupbgMaskView() {
        let height: CGFloat = self.frame.size.height > 0.0 ? self.frame.size.height : 0.0
        bgMaskView = UIView(frame: CGRect(x: 0.0, y: height, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT - height - IT_NaviHeight))
        bgMaskView?.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
//            UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        bgMaskView?.alpha = 0
        bgMaskView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maskViewAction)))
        bgMaskView?.accessibilityLabel = "Product_List_Drop_List_Mask_View_Hidden"
        bgMaskView?.isAccessibilityElement = true
    }
    
    func setupsubViews() {
        let height: CGFloat = self.frame.size.height > 0.0 ? self.frame.size.height : 0.0
        tableView.frame = CGRect(x: 0.0, y: height, width: IT_SCREEN_WIDTH, height: 0.01)
        addSubview(tableView)
        
//        addSubview(titleLabel)
//        addSubview(iconView)
//        iconView.snp.makeConstraints({ (make) in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.size.equalTo(CGSize(width: 20.0, height: 14.0))
//        })
//        titleLabel.snp.makeConstraints({ (make) in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(iconView.snp.top).offset(-3)
//            make.height.equalTo(20)
//            make.width.greaterThanOrEqualTo(80.0)
//        })
        
        // 2. 分割线
        let bottomLine = UIView(frame: CGRect(x: 0, y: height - lineH, width: self.frame.size.width, height: lineH))
        bottomLine.backgroundColor = UIColor.spaceLineColor
        self.addSubview(bottomLine)
    }
    
    // MARK: - actions
    
    /// 展示列表和遮罩
    func showListView() {
        tableView.reloadData()
        self.insertSubview(self.bgMaskView!, at: 0)
        UIView.animate(withDuration: self.duration, animations: {
            self.bgMaskView?.alpha = 1
        })
        let count: CGFloat = CGFloat(dataSource.count)
        let markViewH = (IT_SCREEN_HEIGHT - IT_NaviHeight - cellHeight) * 0.8
        let tableViewH = count * self.cellHeight > markViewH ? markViewH : count * self.cellHeight
        UIView.animate(withDuration: self.duration, animations: {
            self.tableView.frame = CGRect(x: 0.0, y: self.bounds.size.height, width: IT_SCREEN_WIDTH, height: tableViewH)
        })
        tableView.accessibilityLabel = "Product_List_Drop_List_Table_View_Show"
        bgMaskView?.accessibilityLabel = "Product_List_Drop_List_Mask_View_Show"
    }
    
    /// 收起列表和遮罩
    func hiddenListView() {
        self.disminssMarkView()
        self.hiddenTableView()
    }
    
    /// 移除遮罩
    func disminssMarkView() {
        guard self.bgMaskView?.superview != nil else {
            return
        }
        UIView.animate(withDuration: self.duration, animations: {
            self.bgMaskView?.alpha = 0
        }, completion: { (_) in
            self.bgMaskView?.removeFromSuperview()
        })
        bgMaskView?.accessibilityLabel = "Product_List_Drop_List_Mask_View_Hidden"
    }
    
    /// 隐藏列表
    private func hiddenTableView() {
        guard self.tableView.frame.size.height > 10 else {
            return
        }
        let height: CGFloat = self.frame.size.height
        UIView.animate(withDuration: self.duration, animations: {
            self.tableView.frame = CGRect(x: 0.0, y: height, width: IT_SCREEN_WIDTH, height: 0.01)
        })
        tableView.accessibilityLabel = "Product_List_Drop_List_Table_View_Hidden"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as UITableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.white
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.title
        cell.selectionStyle  = .none
        cell.backgroundColor = UIColor.tintColor
        cell.isAccessibilityElement = true
        // 设置选中样式
        var accessoryView: UIImageView? = cell.viewWithTag(666) as? UIImageView ?? nil
        if accessoryView == nil {
            accessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            accessoryView?.tag   = 666
            accessoryView?.image = UIImage(named: "selected")
            cell.accessoryView   = accessoryView
        }
//        let isSelected = titleModel?.isSelected ?? false
//        cell.textLabel?.textColor = isSelected ? self.didSelectedModel?.titleSelectedColor : self.didSelectedModel?.titleNormalColor
//        cell.accessoryView?.isHidden = isSelected ? false : true
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
        if let block = self.selectedCategoryBlock {
            let model = dataSource[indexPath.row]
            block(model)
        }
        self.hiddenListView()
    }
}
