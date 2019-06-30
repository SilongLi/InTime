//
//  HomeViewController.swift
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import SnapKit
import FDFullscreenPopGesture
import CoreSpotlight

let ShowAlertInfoToAppStoreWriteReviewWithNumKey = "ShowAlertInfoToAppStoreWriteReviewWithNum"

class HomeViewController: BaseViewController {
    
    
    /// 图片展示动画
    let AnimateDuration: TimeInterval = 1.0
    let blurViewTag = 999
    
    static let HeaderHeight: CGFloat = 300.0
    let BGViewHiehgt: CGFloat = IT_SCREEN_HEIGHT - IT_NaviHeight - HeaderHeight
    
    let defalutBgImage: UIImage? = {
        var image: UIImage? = nil
        if let path = Bundle.main.path(forResource: "bg/bg13", ofType: "png") {
            image = UIImage(contentsOfFile: path)
        }
        return image
    }()
    
    /// 导航栏
    lazy var iconView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "showDetail"))
        return icon
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: FontName, size: 17.0)
        label.textColor = UIColor.white
        label.text = "全部"
        return label
    }()
    
    /// 导航栏
    lazy var settingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "blur"), for: .normal)
        btn.addTarget(self, action: #selector(gotoSettingViewAction), for: .touchUpInside)
        return btn
    }()
    lazy var sortBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "sort"), for: .normal)
        btn.addTarget(self, action: #selector(sortSeasonAction), for: .touchUpInside)
        return btn
    }()
    lazy var titleActionBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(selectedTypeAction), for: .touchUpInside)
        return btn
    }()
    lazy var addNewSeasonBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add"), for: .normal)
        btn.addTarget(self, action: #selector(gotoAddNewSeasonView), for: .touchUpInside)
        return btn
    }()
    lazy var finishSortSeasonBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "save"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(finishSortSeasonAction), for: .touchUpInside)
        return btn
    }()
    lazy var sortInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: FontName, size: 16)
        label.textColor = UIColor.pinkColor
        label.text = "请长按最右侧按钮\n拖动按钮进行排序"
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let iconW: CGFloat = 26.0
        let bottom: CGFloat = 10.0
        
        view.addSubview(settingBtn)
        settingBtn.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-bottom)
            make.size.equalTo(CGSize.init(width: iconW, height: iconW))
        })
        
        /// 选择展示类型
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(80.0)
        })
 
        view.addSubview(iconView)
        iconView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 16.0, height: 16.0))
        })
        
        view.addSubview(titleActionBtn)
        titleActionBtn.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 80.0, height: 60.0))
        })
        
        view.addSubview(finishSortSeasonBtn)
        finishSortSeasonBtn.isHidden = true
        finishSortSeasonBtn.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-7)
            make.size.equalTo(CGSize.init(width: 30.0, height: 30.0))
        })
        
        view.addSubview(sortInfoLabel)
        sortInfoLabel.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.width.equalTo(160.0)
            make.height.greaterThanOrEqualTo(44.0)
        })
        
        view.addSubview(addNewSeasonBtn)
        addNewSeasonBtn.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-bottom)
            make.size.equalTo(CGSize.init(width: iconW, height: iconW))
        })
        
        view.addSubview(sortBtn)
        sortBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(addNewSeasonBtn.snp.left).offset(-15)
            make.bottom.equalToSuperview().offset(-bottom)
            make.size.equalTo(CGSize.init(width: iconW, height: iconW))
        })
        return view
    }()
    
    /// 分类
    lazy var selectedCategoryView: SelectedCategoryView = {
        let view = SelectedCategoryView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let HomeCellId = "HomeCellId"
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
  
    /// 背景图片
    lazy var bgTableView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var topBgImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.image = defalutBgImage
        view.contentMode = .scaleAspectFill
        return view
    }()
    lazy var bottomBgImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFill
        view.isHidden = true
        return view
    }()
    /// 交替背景图片，用于切换时的过度动画
    lazy var bgImageViewAlternate: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tintColor
        view.alpha = 0.0
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    /// 磨砂背景
    lazy var topBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame.size = UIScreen.main.bounds.size
        view.tag = blurViewTag
        return view
    }()
    lazy var bottomBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame.size = UIScreen.main.bounds.size
        view.tag = blurViewTag
        return view
    }()
    lazy var blurViewAlternate: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame.size = UIScreen.main.bounds.size
        view.tag = blurViewTag
        return view
    }()
    
    lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    /// 当没有时节的时候，显示提示
    lazy var emptyInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.isHidden = true
        label.text = "您还没有新建任何时节，\n点击右上角“+”号添加时节"
        label.it.setLineSpacing(lineSpacing: 8.0, availableWidth: IT_SCREEN_WIDTH)
        label.textAlignment = .center
        return label
    }()
    
    var isShowCategoryView: Bool = false
    var currentSeason: SeasonModel = SeasonModel() {
        didSet {
            headerView.season = currentSeason
        }
    }
    var currentSelectedCategory: CategoryModel?
    var seasons: [SeasonModel] = [SeasonModel]()
    var allSeasons: [SeasonModel] = [SeasonModel]()
    var cacheImages: Dictionary<String, UIImage>?
    
    private var sourceIndexPath: IndexPath?
    private var cellSnapshot: UIImageView? = UIImageView()
    var currentShowtopBgImageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupSubviews()
        loadCategorys()
        cancleExpiredAndNoRepeatSeasons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 回来的时候重新刷新界面（恢复动画）
        headerView.season = currentSeason
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /// 消失的时候，取消所有定时器
        disableAllTimer()
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - setup
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadseasons), name: NotificationAddNewSeason, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadCategorys), name: NotificationUpdateSeasonCategory, object: nil)
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.tintColor
        
        fd_prefersNavigationBarHidden = true
        
        view.addSubview(topBgImageView)
        view.addSubview(bgImageViewAlternate)
        view.addSubview(headerView)
        view.addSubview(bgTableView)
        bgTableView.addSubview(bottomBgImageView)
        view.addSubview(tableView)
        view.addSubview(emptyInfoLabel)
        view.addSubview(navigationView)
        view.addSubview(selectedCategoryView)
        
        headerView.snp.updateConstraints { (make) in
            make.top.equalTo(IT_NaviHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(HomeViewController.HeaderHeight)
        }
        
        let height: CGFloat = BGViewHiehgt
        let y: CGFloat = IT_SCREEN_HEIGHT - height
        bgTableView.frame = CGRect.init(x: 0.0, y: y, width: IT_SCREEN_WIDTH, height: height)
        bgTableView.clipsToBounds = true
        bottomBgImageView.frame = CGRect.init(x: 0.0, y: -y, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
        
        topBgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgImageViewAlternate.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(IT_NaviHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(IT_NaviHeight)
            make.left.right.bottom.equalToSuperview()
        }
        emptyInfoLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(300.0)
        }
        selectedCategoryView.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.01)
        }
        
        /// 添加磨砂效果
        let isBlurEffect = UserDefaults.standard.bool(forKey: IsOpenBlurEffect)
        handleBgBlurEffect(isBlurEffect)
        
        /// 分类处理回调
        selectedCategoryView.selectedCategoryBlock = { [weak self] (model) in
            let isShow = !(self?.isShowCategoryView ?? false)
            if isShow {
                self?.iconView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            } else {
                self?.iconView.transform = CGAffineTransform.identity
            }
            self?.isShowCategoryView = isShow
            
            if let category = model {
                self?.currentSelectedCategory = category
                self?.titleLabel.text = category.title
                
                /// 保存分类
                if let categoryModels = self?.selectedCategoryView.dataSource {
                    for index in 0..<categoryModels.count {
                        var temp = categoryModels[index]
                        temp.isSelected = false
                        if temp.id == category.id {
                            temp.isSelected = true
                        }
                    }
                    self?.selectedCategoryView.dataSource = categoryModels
                    HomeSeasonViewModel.saveAllCategorys(categoryModels)
                }
                
                /// 根据分类加载时节，并刷新数据
                self?.loadseasons()
            }
        }
    }
    
    // MARK: - load DataSource
    @objc func loadCategorys() {
        HomeSeasonViewModel.loadLocalCategorys { [weak self] (models) in
            self?.selectedCategoryView.dataSource = models
            for model in models {
                if model.isSelected {
                    self?.currentSelectedCategory = model
                    self?.titleLabel.text = model.title
                    self?.loadseasons()
                    break
                }
            }
        }
    }
    
    @objc func loadseasons() {
        guard let category = currentSelectedCategory else {
            CommonTools.printLog(message: "[Debug] 分类ID为空！")
            return
        }
        if category.isDefault {
            HomeSeasonViewModel.loadAllSeasons { [weak self] (seasons) in
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    self?.seasons = seasons
                    self?.updateContentView()
                    
                    // 跳转到AppStore评价
                    let num = UserDefaults.standard.integer(forKey: ShowAlertInfoToAppStoreWriteReviewWithNumKey)
                    if num != seasons.count, seasons.count % 3 == 0 {
                        self?.gotoAppStoreWriteReview()
                    }
                })
            }
        } else {
            HomeSeasonViewModel.loadLocalSeasons(categoryId: category.id) { [weak self] (seasons) in
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    self?.seasons = seasons
                    self?.updateContentView()
                    
                    // 跳转到AppStore评价
                    let num = UserDefaults.standard.integer(forKey: ShowAlertInfoToAppStoreWriteReviewWithNumKey)
                    if num != seasons.count, seasons.count % 3 == 0 {
                        self?.gotoAppStoreWriteReview()
                    }
                })
            }
        }
    }
    
    
    /// 跳转到AppStore评价
    func gotoAppStoreWriteReview() {
        guard seasons.count > 0 else {
            return
        }
        
        UserDefaults.standard.set(seasons.count, forKey: ShowAlertInfoToAppStoreWriteReviewWithNumKey)
        UserDefaults.standard.synchronize()
        
        let alert = ITCustomAlertView.init(title: "", detailTitle: "您的意见是我们最珍贵的财富，现在就去评论吧~", topIcon: nil, contentIcon: nil, isTwoButton: true, cancelAction: nil) {
            DispatchQueue.main.async {
                var urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1470847029&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
                
                if #available(iOS 11.0, *) {
                    urlStr = "itms-apps://itunes.apple.com/cn/app/id1470847029?mt=8&action=write-review"
                    
                }
                
                if let url = URL.init(string: urlStr) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        alert.doneButton.setTitleColor(UIColor.pinkColor, for: UIControl.State.normal)
        alert.doneButton.setTitle("去评论", for: UIControl.State.normal)
        alert.cancelButton.setTitle("残忍拒绝", for: UIControl.State.normal)
        alert.showAlertView(inViewController: self, leftOrRightMargin: 35.0)
    }
    
    func updateContentView() {
        /// 刷新界面之前，先取消定时器
        disableAllTimer()
        
        sortBtn.isHidden = (tableView.isEditing || seasons.isEmpty) ? true : false
        
        UIView.animate(withDuration: AnimateDuration) {
            self.emptyInfoLabel.isHidden = self.seasons.count > 0
            self.headerView.isHidden = self.seasons.count == 0
        }
        
        if seasons.count > 0 {
            currentSeason = seasons.first!
            updateBGView()
        } else {
            bottomBgImageView.alpha = 0.0
            bottomBgImageView.image = nil
            bottomBgImageView.backgroundColor = UIColor.clear
            
            let isTopBgViewShow = currentShowtopBgImageView == topBgImageView
            if isTopBgViewShow {
                bgImageViewAlternate.image = defalutBgImage
            } else {
                topBgImageView.image = defalutBgImage
            }
            UIView.animate(withDuration: AnimateDuration) {
                self.topBgImageView.alpha = isTopBgViewShow ? 0.0 : 1.0
                self.bgImageViewAlternate.alpha = isTopBgViewShow ? 1 : 0.0
            }
            currentShowtopBgImageView = isTopBgViewShow ? bgImageViewAlternate : topBgImageView
        }
        tableView.reloadData()
        
        /// 缓存自定义图片
        DispatchQueue.main.async {
            self.cacheImages = Dictionary<String, UIImage>()
            for model in self.seasons {
                if model.backgroundModel.type == .custom {
                    let imageData = HandlerDocumentManager.getCustomImage(seasonId: model.backgroundModel.name)
                    if imageData != nil {
                        let image = UIImage(data: imageData!)
                        self.cacheImages?[model.id] = image
                    }
                }
            }
        }
    }
    
    // MARK: - 取消所有定时器
    func disableAllTimer() {
        headerView.countDownLabel.disposeTimer()
        
        for view in tableView.subviews {
            if view is HomeTableViewCell {
                let cell: HomeTableViewCell = view as! HomeTableViewCell
                cell.disableTimer()
            }
        }
    }
    
    /// 切换背景样式
    func updateBGView() {
        bottomBgImageView.alpha = 0.0
        bottomBgImageView.image = nil
        bottomBgImageView.backgroundColor = UIColor.clear
        
        var bgImage: UIImage? = nil
        if let path = Bundle.main.path(forResource: "bg/\(currentSeason.backgroundModel.name)", ofType: "png") {
            bgImage = UIImage(contentsOfFile: path)
        }
        
        let bgColor = UIColor.color(hex: currentSeason.backgroundModel.name)
        if currentSeason.backgroundModel.type == .custom {
            if let image = self.cacheImages?[currentSeason.id] {  // 取缓存
                bgImage = image
            } else {
                let imageData = HandlerDocumentManager.getCustomImage(seasonId: currentSeason.backgroundModel.name)
                if imageData != nil {
                    bgImage = UIImage(data: imageData!)
                }
            }
        }
        
        let isImage = currentSeason.backgroundModel.type == .custom || currentSeason.backgroundModel.type == .image
        let isTopBgViewShow = currentShowtopBgImageView == topBgImageView
        if isTopBgViewShow {
            bgImageViewAlternate.image = nil
            if isImage {
                bgImageViewAlternate.image = bgImage
            } else {
                bgImageViewAlternate.backgroundColor = bgColor
            }
        } else {
            topBgImageView.image = nil
            if isImage {
                topBgImageView.image = bgImage
            } else {
                topBgImageView.backgroundColor = bgColor
            }
        }
        
        UIView.animate(withDuration: AnimateDuration, animations: {
            self.topBgImageView.alpha = isTopBgViewShow ? 0.0 : 10.0
            self.bgImageViewAlternate.alpha = isTopBgViewShow ? 1.0 : 0.0
        }) { (_) in
            if self.seasons.count > 0 {
                self.bottomBgImageView.alpha = 1.0
                if isImage {
                    self.bottomBgImageView.image = bgImage
                } else {
                    self.bottomBgImageView.backgroundColor = bgColor
                }
            }
        }
        
        currentShowtopBgImageView = isTopBgViewShow ? bgImageViewAlternate : topBgImageView
    }
    
    
    // MARK: - actions
    
    /// 更多操作视图
    @objc func gotoSettingViewAction() {
        var isBlurEffect = UserDefaults.standard.bool(forKey: IsOpenBlurEffect)
        isBlurEffect = !isBlurEffect
        UserDefaults.standard.set(isBlurEffect, forKey: IsOpenBlurEffect)
        UserDefaults.standard.synchronize()
        
        handleBgBlurEffect(isBlurEffect)
    }
    
    /// 进入排序
    @objc func sortSeasonAction() {
        handlerSortSeason(isSort: true)
        HomeSeasonViewModel.loadAllSeasons { [weak self] (seasons) in
            self?.allSeasons = seasons
        }
    }
    
    /// 完成排序
    @objc func finishSortSeasonAction() {
        handlerSortSeason(isSort: false)
    }
    
    func handlerSortSeason(isSort: Bool) {
        tableView.setEditing(isSort, animated: true)

        settingBtn.isHidden = isSort
        sortBtn.isHidden = isSort
        titleLabel.isHidden = isSort
        iconView.isHidden = isSort
        titleActionBtn.isHidden = isSort
        addNewSeasonBtn.isHidden = isSort
        finishSortSeasonBtn.isHidden = !isSort
        sortInfoLabel.isHidden = !isSort
    }
    
    /// 添加新“时节”
    @objc func gotoAddNewSeasonView() {
        let VC = AddNewSeasonViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    
    /// 展示分类视图
    @objc func selectedTypeAction() {
        guard !selectedCategoryView.isShow else {
            return
        }
        isShowCategoryView = !isShowCategoryView
        if isShowCategoryView {
            iconView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            selectedCategoryView.showListView()
        } else {
            iconView.transform = CGAffineTransform.identity
            selectedCategoryView.hiddenListView()
        }
    }
    
    // MARK: - 处理磨砂效果
    func handleBgBlurEffect(_ isBlurEffect: Bool) {
        if isBlurEffect {
            topBlurView.frame = topBgImageView.bounds.isEmpty ? UIScreen.main.bounds : topBgImageView.bounds
            if topBgImageView.viewWithTag(blurViewTag) == nil {
                topBgImageView.addSubview(topBlurView)
            }
            
            bottomBlurView.frame = bottomBgImageView.bounds.isEmpty ? UIScreen.main.bounds : bottomBgImageView.bounds
            if bottomBgImageView.viewWithTag(blurViewTag) == nil {
                bottomBgImageView.addSubview(bottomBlurView)
            }
            
            blurViewAlternate.frame = bgImageViewAlternate.bounds.isEmpty ? UIScreen.main.bounds : bgImageViewAlternate.bounds
            if bgImageViewAlternate.viewWithTag(blurViewTag) == nil {
                bgImageViewAlternate.addSubview(blurViewAlternate)
            }
        } else {
            if let view = topBgImageView.viewWithTag(blurViewTag) {
                view.removeFromSuperview()
            }
            if let view = bottomBgImageView.viewWithTag(blurViewTag) {
                view.removeFromSuperview()
            }
            if let view = bgImageViewAlternate.viewWithTag(blurViewTag) {
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: - 取消已过期且不重复提醒的“时节”
    func cancleExpiredAndNoRepeatSeasons() {
        DispatchQueue.main.async {
            HomeSeasonViewModel.loadAllSeasons { (seasons) in
                var seasonModels = seasons
                var hasChanged = false
                for index in 0..<seasonModels.count {
                    var season = seasonModels[index]
                    if let date = NSDate(season.startDate.gregoriandDataString, withFormat: StartSeasonDateFormat) {
                        let isLater = date.isLaterThanDate(Date())
                        if isLater == false, season.repeatRemindType == .no, season.hasCancelNotification == false {
                            season.hasCancelNotification = true
                            seasonModels[index] = season
                            LocalNotificationManage.shared.cancelLocalNotification(identifier: season.id, title: season.title)
                            hasChanged = true
                        }
                    }
                }
                if hasChanged {
                    AddNewSeasonViewModel.saveAllSeasons(seasons: seasonModels)
                }
            }
        }
    }
}

// MARK: - <UIScrollViewDelegate>
extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard seasons.count > 0 else { return }
        
        /// 更新背景图片布局
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0.0 {
            let height: CGFloat = BGViewHiehgt + offsetY
            let y: CGFloat = IT_SCREEN_HEIGHT - height
            if height <= IT_SCREEN_HEIGHT {
                bgTableView.frame = CGRect.init(x: 0.0, y: y, width: IT_SCREEN_WIDTH, height: height)
                bottomBgImageView.frame = CGRect.init(x: 0.0, y: -y, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
            }
        }
        bgTableView.isHidden = offsetY <= 20.0
        bottomBgImageView.isHidden = bgTableView.isHidden
        
        /// 更新HeaderView布局
        if offsetY < 0.0 {
            headerView.snp.updateConstraints { (make) in
                make.top.equalTo(IT_NaviHeight - offsetY)
                make.left.right.equalToSuperview()
                make.height.equalTo(HomeViewController.HeaderHeight)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard seasons.count > 0 else { return }
        
        /// 停止拖拽之后，返回到原位
        let contentOffsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        let currentY = bgTableView.frame.origin.y
        let originY: CGFloat = IT_SCREEN_HEIGHT - BGViewHiehgt
        if contentOffsetY == 0.0, abs(currentY) < originY {
            bgTableView.frame = CGRect.init(x: 0.0, y: originY, width: IT_SCREEN_WIDTH, height: BGViewHiehgt)
            bottomBgImageView.frame = CGRect.init(x: 0.0, y: -originY, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
        }
        
        /// 更新HeaderView布局
        headerView.snp.updateConstraints { (make) in
            make.top.equalTo(IT_NaviHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(HomeViewController.HeaderHeight)
        }
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellId, for: indexPath) as! HomeTableViewCell
        cell.setContent(seasons[indexPath.row])
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeViewController.HeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = SeaSonDetailViewController()
        detail.category = currentSelectedCategory
        detail.seasons  = seasons
        detail.currentSelectedIndex = indexPath.row
        navigationController?.pushViewController(detail, animated: true)
    }
    
    // MARK: - 拖拽排序 
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row != destinationIndexPath.row {
            if destinationIndexPath.row == 0 || sourceIndexPath.row == 0 {
                tableView.setContentOffset(CGPoint.zero, animated: true)
            }
            
            let sourceSeason = seasons[sourceIndexPath.row]
            let destinationSeason = seasons[destinationIndexPath.row]
            
            seasons.remove(at: sourceIndexPath.row)
            if destinationIndexPath.row > seasons.count {
                seasons.append(sourceSeason)
            } else {
                seasons.insert(sourceSeason, at:destinationIndexPath.row)
            }
            if let firstSeason = seasons.first, firstSeason.id != currentSeason.id {
                currentSeason = firstSeason
                updateBGView()
            }
            
            /// 保存数据
            if self.currentSelectedCategory?.isDefault ?? false {
                AddNewSeasonViewModel.saveAllSeasons(seasons: seasons)
            } else {
                var sourceIndex = -1
                var destinationIndex = -1
                for index in 0..<allSeasons.count {
                    let model = allSeasons[index]
                    if model.id == sourceSeason.id {
                        sourceIndex = index
                    }
                    if model.id == destinationSeason.id {
                        destinationIndex = index
                    }
                }
                if sourceIndex != -1, destinationIndex != -1 {
                    let sourceS = allSeasons[sourceIndex]
                    allSeasons[sourceIndex] = allSeasons[destinationIndex]
                    allSeasons[destinationIndex] = sourceS
                    AddNewSeasonViewModel.saveAllSeasons(seasons: allSeasons)
                }
            }
        }
    }

    // MARK: - 添加左滑修改和删除功能
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let season = seasons[indexPath.row]
        let delete = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "删除") { [weak self] (action, indexPath) in
            guard let strongSelf = self else { return }
            
            let alert = ITCustomAlertView.init(title: "温馨提示", detailTitle: "您确定要删除“\(season.title)”吗？", topIcon: nil, contentIcon: nil, isTwoButton: true, cancelAction: nil) {
                if AddNewSeasonViewModel.deleteSeason(season: season) {
                    /// 取消本地通知
                    LocalNotificationManage.shared.cancelLocalNotification(identifier: season.id, title: season.title)
                    /// 删除自定义图片
                    HandlerDocumentManager.deleteCustomImage(seasonId: season.id)
                    
                    /// 从Spotlight中删除时节搜索
                    CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [season.id], completionHandler: { (error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                    })
                    
                    strongSelf.seasons.remove(at: indexPath.row)
                    if indexPath.row == 0 || strongSelf.seasons.isEmpty {
                        strongSelf.tableView.setContentOffset(CGPoint.zero, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                            strongSelf.tableView.setEditing(false, animated: true)
                            strongSelf.updateContentView()
                        })
                    } else {
                        strongSelf.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.right)
                    }
                } else {
                    strongSelf.view.showText("删除失败！")
                }
            }
            alert.doneButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
            alert.showAlertView(inViewController: strongSelf, leftOrRightMargin: 35.0)
        }
        
        let modify = UITableViewRowAction.init(style: UITableViewRowAction.Style.default, title: "修改") { [weak self] (action, indexPath) in
            guard let strongSelf = self else { return }
            tableView.setEditing(false, animated: true)
            strongSelf.finishSortSeasonAction()
            
            let modifySeasonVC = AddNewSeasonViewController()
            modifySeasonVC.newSeason = season
            strongSelf.navigationController?.pushViewController(modifySeasonVC, animated: true)
        }
        modify.backgroundColor = UIColor.garyColor
        
        return [delete, modify]
    }
}

// MARK: - <HomeTableViewCellDelegate>
extension HomeViewController: HomeTableViewCellDelegate {
    func didLongPressGestureRecognizer(indexPath: IndexPath) {
    }
}
