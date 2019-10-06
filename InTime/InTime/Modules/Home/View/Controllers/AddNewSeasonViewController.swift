//
//  AddNewSeasonViewController.swift
//  InTime
//
//  Created by lisilong on 2019/1/14.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 添加或修改时节

import UIKit
import FDFullscreenPopGesture
import CropViewController
import CoreSpotlight

let NewSeasonMargin: CGFloat = IT_IPHONE_X || IT_IPHONE_6P ? 20.0 : 15.0

class AddNewSeasonViewController: BaseViewController {
    
    let margin: CGFloat = 35.0
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(ITInputTextTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.input.rawValue)
        tableView.register(ITSelectedTimeTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.timeSelected.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.unit.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.category.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.animation.rawValue)
        tableView.register(ITInfoSelectedTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.ring.rawValue)
        tableView.register(ITReminderTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.reminder.rawValue)
        tableView.register(ITRepeatReminderTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.repeatReminder.rawValue)
        tableView.register(ITSelectedBackgroundImageTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.background.rawValue)
        tableView.register(ITSelectedTextColorTableViewCell.self, forCellReuseIdentifier: NewSeasonCellIdType.textColor.rawValue)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tintColor
        return tableView
    }()
    
    // 点击空白区域的时候，退出编辑状态
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endTextFieldEditing))
        return tap
    }()
    
    var dataSource: [BaseSectionModel] = [BaseSectionModel]()
    var newSeason: SeasonModel = SeasonModel()
    
    var unitAlertModel: AlertCollectionModel = AlertCollectionModel()
    
    var categoryModels: [CategoryModel] = [CategoryModel]()
    var categoryAlertModel: AlertCollectionModel = AlertCollectionModel()
    
    var animationAlertModel: AlertCollectionModel = AlertCollectionModel()
    
    var reminderAlertModel: AlertCollectionModel = AlertCollectionModel()
    var isModifySeason: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        loadDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navbarBackgroundImage: UIImage = UIImage.creatImage(color: UIColor.tintColor)
        navigationController?.navigationBar.setBackgroundImage(navbarBackgroundImage, for: .default)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - setup
    func setupSubviews() {
        fd_interactivePopDisabled = true
        
        view.backgroundColor = UIColor.tintColor
        navigationItem.title = "新建"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "save"), style: UIBarButtonItem.Style.done, target: self, action: #selector(saveSeasonAction))
        
        /// 当键盘升起的时候，添加点击手势
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.view.addGestureRecognizer(strongSelf.tapGestureRecognizer)
        }
        /// 当键盘收起的时候，移除点击手势
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.view.removeGestureRecognizer(strongSelf.tapGestureRecognizer)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupSeasion() {
        guard newSeason.title.isEmpty, newSeason.categoryId.isEmpty else {
            isModifySeason = true
            return
        }
        
        // 初始化新“时节”
        newSeason.id = NSDate().string(withFormat: DatestringWithFormat)
        
        for section in dataSource {
            switch section.cellIdentifier {
            case NewSeasonCellIdType.timeSelected.rawValue: /// 开始时间
                if let startTime: TimeModel = section.items.first as? TimeModel {
                    newSeason.startDate = startTime
                }
            case NewSeasonCellIdType.unit.rawValue:  /// 显示单位
                if let selectedModel: InfoSelectedModel = section.items.first as? InfoSelectedModel {
                    newSeason.unitModel = selectedModel
                }
            case NewSeasonCellIdType.category.rawValue:  /// 分类管理
                if let selectedModel: InfoSelectedModel = section.items.first as? InfoSelectedModel {
                    newSeason.categoryId = selectedModel.id
                }
            case NewSeasonCellIdType.ring.rawValue:  /// 提醒铃声
                if let selectedModel: InfoSelectedModel = section.items.first as? InfoSelectedModel {
                    newSeason.ringType = RemindVoiceType(rawValue: selectedModel.info) ?? RemindVoiceType.defaultType
                }
            case NewSeasonCellIdType.reminder.rawValue: /// 是否开启提醒
                if let model: OpenReminderModel = section.items.first as? OpenReminderModel {
                    newSeason.isOpenRemind = model.isOpen
                }
            case NewSeasonCellIdType.repeatReminder.rawValue:   /// 重复提醒
                if let models: RepeatReminderModel = section.items.first as? RepeatReminderModel {
                    for model in models.types {
                        if model.isSelected {
                            newSeason.repeatRemindType = model.type
                        }
                    }
                }
            case NewSeasonCellIdType.background.rawValue:   /// 自定义背景
                if let models: BackgroundModel = section.items.first as? BackgroundModel {
                    for model in models.images {
                        if model.isSelected {
                            newSeason.backgroundModel = model
                        }
                    }
                }
            case NewSeasonCellIdType.textColor.rawValue:    /// 字体颜色
                if let models: TextColorModel = section.items.first as? TextColorModel {
                    for model in models.colors {
                        if model.isSelected {
                            newSeason.textColorModel = model
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - load dataSource
    func loadDataSource() {
        AddNewSeasonViewModel.loadListSections(originSeason: newSeason) { [weak self] (sections) in
            self?.dataSource = sections
            self?.tableView.reloadData()
            self?.setupSeasion()
        }
        
        AddNewSeasonViewModel.loadUnitsModel(originSeason: newSeason) { [weak self] (model) in
            self?.unitAlertModel = model
        }
        AddNewSeasonViewModel.loadClassifyModel(originSeason: newSeason) { [weak self] (model, categorys) in
            self?.categoryAlertModel = model
            self?.categoryModels = categorys
        }
        AddNewSeasonViewModel.loadAnimationModels(originSeason: newSeason) { [weak self] (model) in
            self?.animationAlertModel = model
        }
        AddNewSeasonViewModel.loadRemindVoicesModel(originSeason: newSeason) { [weak self] (model) in
            self?.reminderAlertModel = model
        }
    }
    
    // MARK: - actions
    @objc func saveSeasonAction() {
        view.endEditing(true)
        view.showLeftAnimationLoading("保存中...")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.view.hideHud()
            self.addNewSeason()
        }
    }
    
    func addNewSeason() {
        guard !newSeason.title.isEmpty else {
            view.hideWithMessage("请输入标题!")
            return
        }
        guard !newSeason.categoryId.isEmpty else {
            view.hideWithMessage("请选择分类!")
            return
        }
        if newSeason.backgroundModel.type == .custom, newSeason.backgroundModel.name.isEmpty {
            view.hideWithMessage("请选择自定义背景图片!")
            return
        }
        
        var isLater = true
        if let date = NSDate(newSeason.startDate.gregoriandDataString, withFormat: StartSeasonDateFormat) {
            isLater = date.isLaterThanDate(Date())
            if isLater { /// 重置本地通知
                newSeason.hasCancelNotification = false
            }
        }
        
        var success = false
        if isModifySeason {
            success = AddNewSeasonViewModel.saveSeason(season: newSeason)
        } else {
            success = AddNewSeasonViewModel.addNewSeason(season: newSeason)
        }
        if success {
            /// 只要是未过期的时节，都添加本地通知
            if isLater {
                addNewAlarm()
            }
            
            addSeasonIntoSpotlight(newSeason)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NotificationAddNewSeason, object: nil)
                
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            view.hideWithError("保存失败!")
        }
    }
    
    /// 把时节信息添加系统的Spotlight，方便搜索
    func addSeasonIntoSpotlight(_ season: SeasonModel) {
        let image = UIImage(named: "InTime")
        let (_, _, dateInfo, _) = SeasonTextManager.handleSeasonInfo(season)
        
        let set = CSSearchableItemAttributeSet.init(itemContentType: season.id)
        set.title = season.title
        set.contentDescription = dateInfo
        set.contactKeywords = [season.title, "知时节", "闹钟", "时节", "纪念日", "备忘录", "生日"]
        set.thumbnailData = image?.pngData()
        
        let item = CSSearchableItem.init(uniqueIdentifier: season.id, domainIdentifier: season.id, attributeSet: set)
        
        CSSearchableIndex.default().indexSearchableItems([item], completionHandler: { (error) in
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            }
        })
    }
    
    // MARK: - 添加新闹钟
    func addNewAlarm() {
        guard let date = NSDate(newSeason.startDate.gregoriandDataString, withFormat: StartSeasonDateFormat) else {
            return
        }
        let isLater = date.isLaterThanDate(Date())
        if isLater {
            var dateStr = newSeason.startDate.isGregorian ? newSeason.startDate.gregoriandDataString : newSeason.startDate.lunarDataString
            dateStr = "\(dateStr) \(newSeason.startDate.weakDay)"
            let subTitle = "已悄悄到来\n" + dateStr
            LocalNotificationManage.shared.sendLocalNotification(title: newSeason.title,
                                                                 subTitle: subTitle,
                                                                 body: subTitle,
                                                                 identifier: newSeason.id,
                                                                 soundName: "JazzLogo.mp3",
                                                                 date: date as Date,
                                                                 isOpenRemind: newSeason.isOpenRemind)
        } else {}
    }
    
    @objc func endTextFieldEditing() {
        view.endEditing(true)
    }
    
    // MARK: - 选择相片
    func selectedBgImageFromPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            view.showLeftAnimationLoading("加载中...")
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.navigationBar.tintColor = UIColor.white
            picker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.navigationBar.setBackgroundImage(UIImage.creatImage(color: UIColor.tintColor), for: .default)
            self.present(picker, animated: true, completion: { [weak self] in
                self?.view.hideHud()
            })
        } else {
            /// 跳转到设置界面开启相册权限
            let settingUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension AddNewSeasonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].showCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = dataSource[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as! BaseTableViewCell
        cell.setupContent(model: section.items.first)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - 输入框
extension AddNewSeasonViewController: InputTextFieldDelegate {
    func didClickedEndEditing(model: InputModel) {
        if !model.text.isEmpty {
            newSeason.title = model.text
        }
    }
}

// MARK: - 时间选择
extension AddNewSeasonViewController: SelectedTimeDelegate {
    /// 提示
    func didClickedNoteInfoAction() {
        view.endEditing(true)
        CommonTools.printLog(message: "选择时间提示")
    }
    
    func didClickedShowCalendarViewAction(model: TimeModel) {
        view.endEditing(true)
        
        var selectedDate: Date = NSDate(minutesFromNow: 5) as Date
        let dateStr = newSeason.startDate.gregoriandDataString
        if let date = NSDate(dateStr, withFormat: StartSeasonDateFormat) {
            selectedDate = date as Date
        }
        let datePicker = WSDatePickerView(dateStyle: DateStyleShowYearMonthDayHourMinute, scrollTo: selectedDate, complete: { [weak self] (date) in
            guard let strongSelf = self else { return }
            guard let currentDate = date else { return }
            model.lunarDataString = currentDate.solarToLunar()
            model.weakDay = currentDate.weekDay()
            model.gregoriandDataString = (currentDate as NSDate).string(withFormat: StartSeasonDateFormat)
            for index in 0..<strongSelf.dataSource.count {
                var section = strongSelf.dataSource[index]
                if section.cellIdentifier == NewSeasonCellIdType.timeSelected.rawValue {
                    section.items = [model]
                    strongSelf.dataSource[index] = section
                    break
                }
            }
            strongSelf.newSeason.startDate = model
            strongSelf.tableView.reloadData()
        })
        datePicker?.dateLabelColor  = UIColor.white
        datePicker?.datePickerColor = UIColor.white
        datePicker?.doneButtonColor = UIColor.tintColor.withAlphaComponent(0.8)
        datePicker?.show()
    }
    
    /// 切换农历和公历
    func didClickedOpenGregorianSwitchAction(isGregorian: Bool) {
        view.endEditing(true)
        
        for index in 0..<dataSource.count {
            var section = dataSource[index]
            if section.cellIdentifier == NewSeasonCellIdType.timeSelected.rawValue {
                if let model: TimeModel = section.items.first as? TimeModel {
                    model.isGregorian = isGregorian
                    section.items = [model]
                    dataSource[index] = section
                    newSeason.startDate = model
                    break
                }
            }
        }
        tableView.reloadData()
    }
}

// MARK: - 信息选择
extension AddNewSeasonViewController: InfoSelectedDelegate {
    func didClickedInfoSelectedAction(model: InfoSelectedModel) {
        view.endEditing(true)
        
        switch model.type {
        /// 显示单位
        case .unit:
            let alert = CommonAlertTableView(model: unitAlertModel, selectedAction: { [weak self] (alertModel, textModel) in
                guard let strongSelf = self else { return }
                let unitModel = model
                unitModel.info = textModel.text
                strongSelf.newSeason.unitModel = unitModel
                strongSelf.unitAlertModel = alertModel
                
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.unit.rawValue:
                            section.items = [unitModel]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            })
            alert.showAlertView(inViewController: self, leftOrRightMargin: margin)
            
            
        /// 分类管理
        case .classification:
            let categoryManagerVC = CategoryManagerViewController()
            categoryManagerVC.currentCategoryId = newSeason.categoryId
            categoryManagerVC.didSelectedCategory = { [weak self] (category) in
                guard let strongSelf = self else { return }
                strongSelf.newSeason.categoryId = category.id
                /// 更新列表视图
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.category.rawValue:
                            let catgory = model
                            catgory.id = category.id
                            catgory.info = category.title
                            section.items = [catgory]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            }
            let NAV = UINavigationController(rootViewController: categoryManagerVC)
            navigationController?.present(NAV, animated: true, completion: nil)
            
        /// 动画效果
        case .animation:
            let alert = CommonAlertTableView(model: animationAlertModel, selectedAction: { [weak self] (alertModel, textModel) in
                guard let strongSelf = self else { return }
                strongSelf.newSeason.animationType = CountdownEffect(rawValue: textModel.type) ?? CountdownEffect.Fall
                strongSelf.animationAlertModel = alertModel
                
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.animation.rawValue:
                            let ring = model
                            ring.info = textModel.text
                            section.items = [ring]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            })
            alert.showAlertView(inViewController: self, leftOrRightMargin: margin)
            break
            
        /// 提醒铃声
        case .ring:
            let alert = CommonAlertTableView(model: reminderAlertModel, selectedAction: { [weak self] (alertModel, textModel) in
                guard let strongSelf = self else { return }
                strongSelf.newSeason.ringType = RemindVoiceType(rawValue: textModel.type) ?? RemindVoiceType.defaultType
                strongSelf.reminderAlertModel = alertModel
                
                DispatchQueue.main.async {
                    for index in 0..<strongSelf.dataSource.count {
                        var section = strongSelf.dataSource[index]
                        switch section.cellIdentifier {
                        case NewSeasonCellIdType.ring.rawValue:
                            let ring = model
                            ring.info = textModel.text
                            section.items = [ring]
                            strongSelf.dataSource[index] = section
                        default:
                            break
                        }
                    }
                    strongSelf.tableView.reloadData()
                }
            })
            alert.showAlertView(inViewController: self, leftOrRightMargin: margin)
        }
    }
}

// MARK: - 是否开启时节提醒
extension AddNewSeasonViewController: NoteSwitchDelegate {
    func didClickedReminderSwitchAction(isOpen: Bool) {
        view.endEditing(true)
        newSeason.isOpenRemind = isOpen
    }
}

// MARK: - 重复提醒
extension AddNewSeasonViewController: RepeatRemindersDelegate {
    func didSelectedRepeatRemindersAction(model: RepeatReminderTypeModel) {
        view.endEditing(true)
        newSeason.repeatRemindType = model.type
    }
}

// MARK: - 自定义背景
extension AddNewSeasonViewController: BackgroundImageDelegate {
    func didSelectedBackgroundImageAction(model: BackgroundImageModel) {
        view.endEditing(true)
        newSeason.backgroundModel = model
        /// 自定义背景图片
        if model.type == .custom {
            selectedBgImageFromPhotoLibrary()
        } else {}
    }
}

// MARK: - 字体颜色
extension AddNewSeasonViewController: TextColorDelegate {
    func didSelectedTextColorAction(model: ColorModel) {
        view.endEditing(true)
        newSeason.textColorModel = model
    }
}

// MARK: - 选择相片
extension AddNewSeasonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /// 裁剪并保存图片
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                let originalImage = info[UIImagePickerController.InfoKey.originalImage]
                if originalImage is UIImage {
                    let image: UIImage = originalImage as! UIImage
                    let cropVC = CropViewController(image: image)
                    cropVC.delegate = self
                    self.navigationController?.pushViewController(cropVC, animated: true)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.popToViewController(self, animated: true)
    }
}

// MARK: - <CropViewControllerDelegate>
extension AddNewSeasonViewController: CropViewControllerDelegate {

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        /// 保存图片到沙盒
        let imageData = image.pngData()
        let success = HandlerDocumentManager.saveCustomImage(seasonId: newSeason.id, imageData: imageData)
        if success {
            newSeason.backgroundModel.name = newSeason.id
            
            /// 更新列表视图
            for index in 0..<dataSource.count {
                var section = dataSource[index]
                if section.cellIdentifier == NewSeasonCellIdType.background.rawValue {
                    if let item = section.items.first, item is BackgroundModel, let bgModel: BackgroundModel = item as? BackgroundModel {
                        var images = bgModel.images
                        for i in 0..<images.count {
                            let model = images[i]
                            if model.type == .custom {
                                model.name = newSeason.id
                                images[i] = model
                                bgModel.images = images
                                section.items[0] = bgModel
                                dataSource[index] = section
                                break
                            }
                        }
                    }
                    break
                }
            }
            tableView.reloadData()
        } else {
            newSeason.backgroundModel.name = ""
            view.showText("获取图片失败！")
        }
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.navigationController?.popToViewController(self, animated: true)
    }
}
