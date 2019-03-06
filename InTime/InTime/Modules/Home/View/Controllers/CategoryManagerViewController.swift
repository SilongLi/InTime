//
//  CategoryManagerViewController.swift
//  InTime
//
//  Created by lisilong on 2019/3/5.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 分类管理

import UIKit

class CategoryManagerViewController: BaseViewController {
    
    let CategoryManagerCellId = "CategoryManagerCellId"
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryManagerCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    lazy var closeItem = {
        return UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItem.Style.done, target: self, action: #selector(closeBtnAction))
    }()
    lazy var addItem = {
        return UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItem.Style.done, target: self, action: #selector(gotoAddNewCategoryAction))
    }()
    lazy var sortItem = {
        return UIBarButtonItem(image: UIImage(named: "sort"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sortCategorysAction))
    }()
    lazy var finishSortedItem = {
        return UIBarButtonItem(image: UIImage(named: "save"), style: UIBarButtonItem.Style.done, target: self, action: #selector(finishSortBtnAction))
    }()
    
    var categorys = [CategoryModel]()
    var currentCategoryId: String?
    var didSelectedCategory: ((_ category: CategoryModel) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        loadDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shadowImage = UIImage.creatImage(color: UIColor.spaceLineColor,
                                             size: CGSize.init(width: IT_SCREEN_WIDTH, height: 0.2))
        navigationController?.navigationBar.shadowImage = shadowImage
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - setup
    func setupSubviews() {
        navigationItem.title = "分类管理"
        view.backgroundColor = UIColor.tintColor
        
        navigationItem.leftBarButtonItem   = closeItem
        navigationItem.rightBarButtonItems = [addItem, sortItem]
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(IT_NaviHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - load dataSource
    func loadDataSource() {
        HomeSeasonViewModel.loadLocalCategorys { [weak self] (models) in
            var categorys = models
            if let selectedCategoryId = self?.currentCategoryId {
                for index in 0..<categorys.count {
                    var category = categorys[index]
                    category.isSelected = false
                    if category.id == selectedCategoryId {
                        category.isSelected = true
                    }
                    categorys[index] = category
                }
            }
            self?.categorys = categorys
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - actions
    @objc func closeBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sortCategorysAction() {
        tableView.setEditing(true, animated: true)
        navigationItem.leftBarButtonItem   = nil
        navigationItem.rightBarButtonItems = [finishSortedItem]
    }
    
    @objc func finishSortBtnAction() {
        tableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem   = closeItem
        navigationItem.rightBarButtonItems = [addItem, sortItem]
    }
    
    @objc func gotoAddNewCategoryAction() {
        addNewCategory()
    }
    
    /// 删除分类
    func deleteCategory(_ category: CategoryModel) {
        guard !category.isDefault else {
            view.showText("此分类不可删除！")
            return
        }
        for index in 0..<categorys.count {
            let model = categorys[index]
            if model.id == category.id {
                categorys.remove(at: index)
                break
            }
        }
        /// 如果删除的是被选中类，则默认分类变为选中
        if category.isSelected {
            for index in 0..<categorys.count {
                if categorys[index].isDefault {
                    categorys[index].isSelected = true
                    break
                }
            }
        }
        
        HomeSeasonViewModel.saveAllCategorys(categorys)
        tableView.reloadData()
        NotificationCenter.default.post(name: NotificationUpdateSeasonCategory, object: nil)
    }
    
    /// 修改分类名称
    func modifyCategory(_ catetory: CategoryModel) {
        let inputAlert = InputTextFieldAlertView(title: "修改分类名称", textFieldText: catetory.title, placeholder: "请输入分类名称", cancelAction: nil, doneAction: { [weak self] (text) in
            guard let strongSelf = self else { return }
            guard let title: String = text else {
                strongSelf.view.showText("请输入合法分类名称！")
                return
            }
            let maxLenght = 60
            if title.isEmpty {
                strongSelf.view.showText("请输入合法分类名称！")
                return
            } else if title.count > maxLenght {
                strongSelf.view.showText("请输入少于\(maxLenght)字符长度的分类名称！")
                return
            } else {
                var success = false
                var models = strongSelf.categorys
                for index in 0..<models.count {
                    if models[index].id == catetory.id {
                        models[index].title = title
                        break
                    }
                }
                success = HomeSeasonViewModel.saveAllCategorys(models)
                if success {
                    strongSelf.categorys = models
                    strongSelf.tableView.reloadData()
                    NotificationCenter.default.post(name: NotificationUpdateSeasonCategory, object: nil)
                } else {
                    strongSelf.view.showText("分类名称已存在！")
                    return
                }
            }
        })
        inputAlert.showAlertView(inViewController: self, leftOrRightMargin: 35.0)
    }
    
    /// 添加分类
    func addNewCategory() {
        let inputAlert = InputTextFieldAlertView(title: "添加分类", textFieldText: nil, placeholder: "请输入分类名称", cancelAction: nil, doneAction: { [weak self] (text) in
            guard let strongSelf = self else { return }
            guard let title: String = text else {
                strongSelf.view.showText("请输入合法分类名称！")
                return
            }
            let maxLenght = 60
            if title.isEmpty {
                strongSelf.view.showText("请输入合法分类名称！")
                return
            } else if title.count > maxLenght {
                strongSelf.view.showText("请输入少于\(maxLenght)字符长度的分类名称！")
                return
            } else {
                let success = HomeSeasonViewModel.saveCategory(name: title)
                if success {
                    HomeSeasonViewModel.loadLocalCategorys(completion: { (categorys) in
                        strongSelf.categorys = categorys
                        strongSelf.tableView.reloadData()
                        NotificationCenter.default.post(name: NotificationUpdateSeasonCategory, object: nil)
                    })
                } else {
                    strongSelf.view.showText("分类名称已存在！")
                    return
                }
            }
        })
        inputAlert.showAlertView(inViewController: self, leftOrRightMargin: 35.0)
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>
extension CategoryManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryManagerCellId, for: indexPath) as! CategoryTableViewCell
        cell.model = categorys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !categorys[indexPath.row].isDefault else {
            view.showText("新“时节”不可添加在此分类下！")
            return
        }
        for var model in categorys {
            model.isSelected = false
        }
        var category = categorys[indexPath.row]
        category.isSelected = true
        categorys[indexPath.row] = category
        if let block = didSelectedCategory {
            block(category)
        }
        closeBtnAction()
    }
    
    // MARK: - 拖拽排序
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let model = categorys[sourceIndexPath.row]
        categorys.remove(at: sourceIndexPath.row)
        if destinationIndexPath.row > categorys.count {
            categorys.append(model)
        } else {
            categorys.insert(model, at:destinationIndexPath.row)
        }
        HomeSeasonViewModel.saveAllCategorys(categorys)
        tableView.reloadData()
        NotificationCenter.default.post(name: NotificationUpdateSeasonCategory, object: nil)
    }
    
    // MARK: - 添加左滑修改和删除功能
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let category = categorys[indexPath.row]
        let delete = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "删除") { [weak self] (action, indexPath) in
            HomeSeasonViewModel.loadLocalSeasons(categoryId: category.id) { [weak self] (seasons) in
                guard let strongSelf = self else { return }
                if seasons.count > 0 {
                    let deleteAlert = ITCustomAlertView.init(title: "温馨提示", detailTitle: "删除分类后，改分类下的”时节“自动转到”全部“分类下。", topIcon: nil, contentIcon: nil, isTwoButton: true, cancelAction: nil) {
                        strongSelf.deleteCategory(category)
                    }
                    deleteAlert.doneButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
                    deleteAlert.doneButton.setTitle("删除", for: UIControl.State.normal)
                    deleteAlert.showAlertView(inViewController: strongSelf, leftOrRightMargin: 35.0)
                } else {
                    strongSelf.deleteCategory(category)
                }
            }
            tableView.setEditing(false, animated: true)
        }
        
        let modify = UITableViewRowAction.init(style: UITableViewRowAction.Style.default, title: "修改") { [weak self] (action, indexPath) in
             self?.modifyCategory(category)
            tableView.setEditing(false, animated: true)
        }
        modify.backgroundColor = UIColor.darkGaryColor
        
        return [delete, modify]
    }
}
