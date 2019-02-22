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

class HomeViewController: BaseViewController {
    
    /// 图片展示动画
    let AnimateDuration: TimeInterval = 1.0
    
    static let HeaderHeight: CGFloat = 280.0
    let BGViewHiehgt: CGFloat = IT_SCREEN_HEIGHT - IT_NaviHeight - HeaderHeight
    
    let defalutBgImage: UIImage? = UIImage(named: "bg7")
    
    /// 导航栏
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
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let iconW: CGFloat = 26.0
        let bottom: CGFloat = 10.0
        
        /// 设置
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "setting"), for: .normal)
        leftBtn.addTarget(self, action: #selector(gotoSettingView), for: .touchUpInside)
        view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints({ (make) in
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
            make.bottom.equalToSuperview().offset(2)
            make.size.equalTo(CGSize(width: 20.0, height: 14.0))
        })
        
        let titleBtn: UIButton = UIButton()
        titleBtn.addTarget(self, action: #selector(selectedTypeAction), for: .touchUpInside)
        view.addSubview(titleBtn)
        titleBtn.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 80.0, height: 60.0))
        })
        
        /// 添加新计划
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage(named: "add"), for: .normal)
        rightBtn.addTarget(self, action: #selector(gotoAddNewTimeView), for: .touchUpInside)
        view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-15)
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
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.image = defalutBgImage
        return view
    }()
    lazy var bgTableView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var bgImageTableView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    /// 交替背景图片，用于切换时的过度动画
    lazy var bgImageViewAlternate: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tintColor
        view.alpha = 0.0
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
    
    private var sourceIndexPath: IndexPath?
    private var cellSnapshot: UIImageView? = UIImageView()
    var currentShowBgImageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupSubviews()
        loadCategorys()
    }
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - setup
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadseasons), name: NotificationAddNewSeason, object: nil)
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.tintColor
        
        fd_prefersNavigationBarHidden = true
        
        view.addSubview(bgImageView)
        view.addSubview(bgImageViewAlternate)
        view.addSubview(headerView)
        view.addSubview(bgTableView)
        bgTableView.addSubview(bgImageTableView)
        view.addSubview(tableView)
        view.addSubview(selectedCategoryView)
        view.addSubview(emptyInfoLabel)
        view.addSubview(navigationView)
        
        headerView.snp.updateConstraints { (make) in
            make.top.equalTo(IT_NaviHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(HomeViewController.HeaderHeight)
        }
        
        let height: CGFloat = BGViewHiehgt
        let y: CGFloat = IT_SCREEN_HEIGHT - height
        bgTableView.frame = CGRect.init(x: 0.0, y: y, width: IT_SCREEN_WIDTH, height: height)
        bgTableView.clipsToBounds = true
        bgImageTableView.frame = CGRect.init(x: 0.0, y: -y, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
        
        bgImageView.snp.makeConstraints { (make) in
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
            make.top.equalToSuperview().offset(IT_NaviHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.01)
        }
        
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
    func loadCategorys() {
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
        let categoryId: String = currentSelectedCategory?.id ?? ""
        guard !categoryId.isEmpty else {
            CommonTools.printLog(message: "[Debug] 分类ID为空！")
            return
        }
        HomeSeasonViewModel.loadLocalSeasons(categoryId: categoryId) { [weak self] (seasons) in
            self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            self?.seasons = seasons
            self?.updateContentView()
        }
    }
    
    func updateContentView() {
        UIView.animate(withDuration: AnimateDuration) {
            self.emptyInfoLabel.isHidden = self.seasons.count > 0
            self.headerView.isHidden = self.seasons.count == 0
        }
        
        if seasons.count > 0 {
            currentSeason = seasons.first!
            updateBGView()
        } else {
            bgImageView.image = defalutBgImage
            bgImageTableView.image = nil
            UIView.animate(withDuration: AnimateDuration) {
                self.bgImageView.alpha = 1
            }
        }
        
        tableView.reloadData()
    }
    
    /// 切换背景样式
    func updateBGView() {
        if currentShowBgImageView == bgImageView {
            bgImageViewAlternate.image = nil
            if currentSeason.backgroundModel.type == .image {
                bgImageViewAlternate.image = UIImage(named: currentSeason.backgroundModel.name)
            } else {
                bgImageViewAlternate.backgroundColor = UIColor.color(hex: currentSeason.backgroundModel.name)
            }
            UIView.animate(withDuration: AnimateDuration, animations: {
                self.bgImageView.alpha = 0.0
                self.bgImageViewAlternate.alpha = 1.0
                self.bgImageTableView.alpha = 0.0
            }) { (_) in
                self.bgImageTableView.alpha = 1.0
                self.bgImageTableView.image = nil
                if self.currentSeason.backgroundModel.type == .image {
                    self.bgImageTableView.image = UIImage(named: self.currentSeason.backgroundModel.name)
                } else {
                    self.bgImageTableView.backgroundColor = UIColor.color(hex: self.currentSeason.backgroundModel.name)
                }
            }
            
            currentShowBgImageView = bgImageViewAlternate
            
        } else {
            bgImageView.image = nil
            if currentSeason.backgroundModel.type == .image {
                bgImageView.image = UIImage(named: currentSeason.backgroundModel.name)
            } else {
                bgImageView.backgroundColor = UIColor.color(hex: currentSeason.backgroundModel.name)
            }
            UIView.animate(withDuration: AnimateDuration, animations: {
                self.bgImageView.alpha = 1.0
                self.bgImageViewAlternate.alpha = 0.0
                self.bgImageTableView.alpha = 0.0
            }) { (_) in
                self.bgImageTableView.alpha = 1.0
                self.bgImageTableView.image = nil
                if self.currentSeason.backgroundModel.type == .image {
                    self.bgImageTableView.image = UIImage(named: self.currentSeason.backgroundModel.name)
                } else {
                    self.bgImageTableView.backgroundColor = UIColor.color(hex: self.currentSeason.backgroundModel.name)
                }
            }
            
            currentShowBgImageView = bgImageView
        }
    }
    
    
    // MARK: - actions
    @objc func gotoSettingView() {
//        let VC = SettingViewController()
//        navigationController?.pushViewController(VC, animated: true)
        
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @objc func gotoAddNewTimeView() {
        let VC = AddNewSeasonViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    
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
                bgImageTableView.frame = CGRect.init(x: 0.0, y: -y, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
            }
        }
        bgTableView.isHidden = offsetY <= 0.0
        
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
            bgImageTableView.frame = CGRect.init(x: 0.0, y: -originY, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
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
        cell.season = seasons[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
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
        detail.seasons = seasons
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
            
            let season = seasons[sourceIndexPath.row]
            seasons.remove(at: sourceIndexPath.row)
            if destinationIndexPath.row > seasons.count {
                seasons.append(season)
            } else {
                seasons.insert(season, at:destinationIndexPath.row)
            }
            if let firstSeason = seasons.first, firstSeason.id != currentSeason.id {
                currentSeason = firstSeason
                updateBGView()
            }
            AddNewSeasonViewModel.saveAllSeasons(seasons: seasons)
        }
    }
    
    // MARK: - 添加左滑删除功能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let season = seasons[indexPath.row]
        let alert = ITCustomAlertView.init(title: "温馨提示", detailTitle: "您确定要删除“\(season.title)”吗？", topIcon: nil, contentIcon: nil, isTwoButton: true, cancelAction: nil) { [weak self] in
            if AddNewSeasonViewModel.deleteSeason(season: season) {
                /// 取消本地通知
                LocalNotificationManage.shared.cancelLocalNotification(identifier: season.id)
                
                self?.seasons.remove(at: indexPath.row)
                if indexPath.row == 0 || (self?.seasons.isEmpty ?? false) {
                    self?.tableView.setContentOffset(CGPoint.zero, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        self?.updateContentView()
                    })
                } else {
                    self?.tableView.reloadData()
                }
            } else {
                self?.view.showText("删除失败！")
            }
        }
        alert.doneButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
        alert.showAlertView(inViewController: self, leftOrRightMargin: 35.0)
    }
}
