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
    
    static let HeaderHeight: CGFloat = 220.0
    let BGViewHiehgt: CGFloat = IT_SCREEN_HEIGHT - IT_NaviHeight - HeaderHeight
    
    var isShowCategoryView: Bool = false
    var currentSeason: SeasonModel = SeasonModel()
    var currentSelectedCategory: CategoryModel?
    var seasions: [SeasonModel] = [SeasonModel]()

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
        NotificationCenter.default.addObserver(self, selector: #selector(loadSeasions), name: NotificationAddNewSeason, object: nil)
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.tintColor
        
        fd_prefersNavigationBarHidden = true
        
        view.addSubview(bgImageView)
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
                
                /// 根据分类加载时节
                self?.loadSeasions()
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
                    self?.loadSeasions()
                    break
                }
            }
        }
    }
    
    @objc func loadSeasions() {
        let categoryId: String = currentSelectedCategory?.id ?? ""
        guard !categoryId.isEmpty else {
            CommonTools.printLog(message: "[Debug] 分类ID为空！")
            return
        }
        HomeSeasonViewModel.loadLocalSeasons(categoryId: categoryId) { [weak self] (seasions) in
            self?.seasions = seasions
            self?.updateContentView()
        }
    }
    
    func updateContentView() {
        UIView.animate(withDuration: AnimateDuration) {
            self.emptyInfoLabel.isHidden = self.seasions.count > 0
            self.headerView.isHidden = self.seasions.count == 0
        }
        
        if seasions.count > 0 {
            currentSeason = seasions.first!
            if currentSeason.backgroundModel.type == .image {
                bgImageView.image = UIImage(named: currentSeason.backgroundModel.name)
            } else {
                bgImageView.backgroundColor = UIColor.color(hex: currentSeason.textColorModel.color)
            }
            UIView.animate(withDuration: AnimateDuration, animations: {
                self.bgImageView.alpha = 1
            }) { (_) in
                if self.currentSeason.backgroundModel.type == .image {
                    self.bgImageTableView.image = UIImage(named: self.currentSeason.backgroundModel.name)
                } else {
                    self.bgImageTableView.backgroundColor = UIColor.color(hex: self.currentSeason.textColorModel.color)
                }
            }
            
            headerView.season = currentSeason
            tableView.reloadData()
            
        } else {
            self.bgImageTableView.image = nil
            UIView.animate(withDuration: AnimateDuration, animations: {
                self.bgImageView.alpha = 0
            }) { (_) in
                self.bgImageView.image = nil
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - actions
    @objc func gotoSettingView() {
        let VC = SettingViewController()
        navigationController?.pushViewController(VC, animated: true)
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
        guard seasions.count > 0 else { return }
        
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard seasions.count > 0 else { return }
        
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
        return seasions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellId, for: indexPath) as! HomeTableViewCell
        cell.season = seasions[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = SeaSonDetailViewController()
        detail.seasons = seasions
        detail.currentSelectedIndex = indexPath.row
        navigationController?.pushViewController(detail, animated: true)
    }
}
