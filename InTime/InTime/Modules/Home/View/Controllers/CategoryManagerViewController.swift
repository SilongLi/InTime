//
//  CategoryManagerViewController.swift
//  InTime
//
//  Created by lisilong on 2019/3/5.
//  Copyright © 2019 BruceLi. All rights reserved.
//

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
    
    // MARK: - setup
    func setupSubviews() {
        navigationItem.title = "分类管理"
        view.backgroundColor = UIColor.tintColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(IT_NaviHeight)
            make.left.right.bottom.equalToSuperview()
        }
        
        navigationItem.leftBarButtonItem = closeItem
        navigationItem.rightBarButtonItems = [addItem, sortItem]
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
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItems = [finishSortedItem]
    }
    
    @objc func finishSortBtnAction() {
        tableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem = closeItem
        navigationItem.rightBarButtonItems = [addItem, sortItem]
    }
    
    @objc func gotoAddNewCategoryAction() {
        
    }
     
//    func modifyCategory(_ catetory: CategoryModel?, categoryView: CommonAlertTableView) {
//        let alertTitle = (currentCategoryId?.isEmpty ?? false) ? "修改分类" : "添加分类"
//        let inputAlert = InputTextFieldAlertView(title: alertTitle, textFieldText: catetory?.title, placeholder: "请输入分类名称", cancelAction: nil, doneAction: { [weak self] (text) in
//            guard let strongSelf = self else { return }
//            guard let title: String = text else { return }
//            let maxLenght = 60
//            if title.count == 0 {   //id 删除分类
//                if let categoryId = strongSelf.currentCategoryId {
////                    HomeSeasonViewModel.loadLocalSeasons(categoryId: categoryId) { (seasons) in
////                        if seasons.count > 0 {
////                            let deleteAlert = ITCustomAlertView.init(title: "温馨提示",
////                                                                     detailTitle: "删除分类后，改分类下的”时节“自动转到”全部“分类下。",
////                                                                     topIcon: nil,
////                                                                     contentIcon: nil,
////                                                                     isTwoButton: true, cancelAction: nil) {
////                                                                        strongSelf.deleteCategory(catetory, categoryView: categoryView)
////                            }
////                            deleteAlert.doneButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
////                            deleteAlert.doneButton.setTitle("删除", for: UIControl.State.normal)
////                            deleteAlert.showAlertView(inViewController: strongSelf, leftOrRightMargin: strongSelf.margin)
////                        } else {
////                            strongSelf.deleteCategory(model, categoryView: categoryView)
////                        }
////                    }
//                } else {
//                    UIApplication.shared.keyWindow?.showText("请输入合法分类名称！")
//                }
//                return
//            } else if title.count > maxLenght {
//                UIApplication.shared.keyWindow?.showText("请输入少于\(maxLenght)字符长度的分类名称！")
//                return
//            } else {
//                var success = false
//                if let currentModel = textModel { // 更新分类标题
//                    if var models = self?.categoryModels {
//                        for index in 0..<models.count {
//                            var model = models[index]
//                            if model.id == currentModel.type {
//                                model.title = title
//                            }
//                            models[index] = model
//                        }
//                        success = HomeSeasonViewModel.saveAllCategorys(models)
//                    }
//                } else { // 添加分类标题
//                    success = HomeSeasonViewModel.saveCategory(name: title)
//                }
//                if success {
//                    NotificationCenter.default.post(name: NotificationUpdateSeasonCategory, object: nil)
//                    AddNewSeasonViewModel.loadClassifyModel(originSeason: strongSelf.newSeason) { (model, categorys) in
//                        strongSelf.categoryAlertModel = model
//                        strongSelf.categoryModels = categorys
//                        categoryView.updateContentView(model)
//                    }
//                } else {
//                    UIApplication.shared.keyWindow?.showText("分类名称已存在！")
//                    return
//                }
//            }
//        })
//        inputAlert.showAlertView(inViewController: self, leftOrRightMargin: margin)
//    }

    func deleteCategory(_ category: CategoryModel, categoryView: CommonAlertTableView) {
        var originModels = categorys
        for index in 0..<originModels.count {
            let model = originModels[index]
            if model.id == category.id {
                categoryModels.remove(at: index)
            }
        }
        // TODO:
        /// 如果删除的是被选中类，则默认分类变为选中
        for index in 0..<categoryModels.count {
            var model = categoryModels[index]
            //            if textModel.isSelected, model.isDefalult {
            //                model.isSelected = true
            //                categoryModels[index] = model
            //            }
        }

        // 保存分类数据并更新视图
        if originModels.count != categoryModels.count {
            HomeSeasonViewModel.saveAllCategorys(categoryModels)
            NotificationCenter.default.post(name: NotificationUpdateSeasonCategory, object: nil)

            let alertModel = AddNewSeasonViewModel.handleClassifyModel(originSeason: newSeason, categoryModels)
            categoryAlertModel = alertModel
            categoryView.updateContentView(alertModel)
        }
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
    
    // MARK: - 添加左滑删除功能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "修改"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if let model = alertModel, let block = deleteItemBlock {
//            let selectedModel = model.texts[indexPath.row]
//            block(selectedModel)
//        }
    }
}
