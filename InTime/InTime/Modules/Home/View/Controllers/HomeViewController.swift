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
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "showDetail"))
        return icon
    }()
    
    /// 标题
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
    
    lazy var selectedCategoryView: SelectedCategoryView = {
        let view = SelectedCategoryView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate let HomeCellId = "HomeCellId"
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HomeCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tintColor
        return view
    }()
    
    lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
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
    
    ///
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var bgImageView1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "night")
        view.backgroundColor = UIColor.tintColor
        return view
    }()
    let BGHiehgt: CGFloat = 400.0
    let HeaderHiehgt: CGFloat = 180.0
    
    var isShowCategoryView: Bool = false
    var currentTheme: ThemeModel = ThemeModel()
    var dataSource: [SeasonModel] = [SeasonModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.tintColor
        fd_prefersNavigationBarHidden = true
        setupSubviews()
        loadDataSource()
    }
    
    // MARK: - setup
    func setupSubviews() {
        view.addSubview(bgImageView)
        view.addSubview(headerView)
        view.addSubview(bgView)
        bgView.addSubview(bgImageView1)
        view.addSubview(tableView)
        view.addSubview(selectedCategoryView)
        view.addSubview(emptyInfoLabel)
        view.addSubview(navigationView)
        
        //
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(IT_NaviHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(HeaderHiehgt)
        }
        
        let height: CGFloat = BGHiehgt
        let y: CGFloat = IT_SCREEN_HEIGHT - height
        bgView.frame = CGRect.init(x: 0.0, y: y, width: IT_SCREEN_WIDTH, height: height)
        bgView.clipsToBounds = true
        bgImageView1.frame = CGRect.init(x: 0.0, y: -y, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
        
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
                self?.titleLabel.text = category.title
                // update content view
            }
        }
    }
    
    // MARK: - load DataSource
    func loadDataSource() {
        // 类别
        var model1 = CategoryModel()
        model1.title = "全部"
        model1.isSelected = true
        
        var model2 = CategoryModel()
        model2.title = "节假日"
        
        var model3 = CategoryModel()
        model3.title = "时节"
        
        var model4 = CategoryModel()
        model4.title = "生日"
        
        selectedCategoryView.dataSource = [model1, model2, model3, model4]
        
        // 主题
        var theme = ThemeModel()
        theme.bgImageName = "night"
        theme.bgHexColor = UIColor.tintHexColorString()
        currentTheme = theme
        
        // 时节
        var season = SeasonModel()
        season.title = "知时节"
        season.date = Date()
        
        var season1 = SeasonModel()
        season1.title = "过年"
        season1.date = Date()
        
        var season2 = SeasonModel()
        season2.title = "冬至"
        season2.date = Date()
        
        var season3 = SeasonModel()
        season3.title = "五一"
        season3.date = Date()
        
        dataSource = [season, season1, season2, season3,season, season1, season2, season3,season, season1, season2, season3]
        
        updateContentView()
    }
    
    func updateContentView() {
        // 背景图
        if currentTheme.bgImageName.count > 0 {
            bgImageView.image = UIImage(named: currentTheme.bgImageName)
        } else {
            bgImageView.backgroundColor = UIColor.color(hex: currentTheme.bgHexColor)
        }
        
        let season = dataSource.first
        headerView.season = season
        
        emptyInfoLabel.isHidden = dataSource.count > 0
        if dataSource.count > 0 {
            tableView.reloadData()
        }
    }
    
    // MARK: - actions
    @objc func gotoSettingView() {
        let VC = UIViewController()
        VC.navigationItem.title = "设置"
        VC.view.backgroundColor = UIColor.tintColor
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func gotoAddNewTimeView() {
        let VC = UIViewController()
        VC.navigationItem.title = "新建"
        VC.view.backgroundColor = UIColor.tintColor
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func selectedTypeAction() {
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
        /// 更新背景图片布局
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if offsetY > 0 {
            let height: CGFloat = BGHiehgt + offsetY
            let y: CGFloat = IT_SCREEN_HEIGHT - height
            if height <= IT_SCREEN_HEIGHT {
                bgView.frame = CGRect.init(x: 0.0, y: y, width: IT_SCREEN_WIDTH, height: height)
                bgImageView1.frame = CGRect.init(x: 0.0, y: -y, width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /// 停止滑动到指定位置后，开始加载数据
//        if abs(scrollView.contentOffset.y) == abs(scrollView.contentInset.top),
//            abs(scrollView.contentInset.top) == loadingOffsetY, loadingView.isAnimating {
//            self.loadHomeDataSource()
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        /// 松手后展示loading动画
//        let contentOffsetY = scrollView.contentOffset.y + scrollView.contentInset.top
//        let height: CGFloat = BGHiehgt + contentOffsetY
//        let y: CGFloat = IT_SCREEN_HEIGHT - height
//        if height <= IT_SCREEN_HEIGHT {
//            bgView.frame = CGRect.init(x: 0.0, y: y, width: IT_SCREEN_WIDTH, height: height)
//        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        /// 加载完成之后，回到原始位置
//        scrollView.contentInset.top = 0.0
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellId, for: indexPath) as UITableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle  = .none
        cell.backgroundColor = UIColor.clear
        cell.isAccessibilityElement = true
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.title
        
        // 分割线
        if cell.viewWithTag(777) == nil {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.tag = 777
            cell.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderHiehgt
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard dataSource.count > 0 else {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
//        }
//        let season = dataSource.first
//        headerView.season = season
//        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let season = dataSource[indexPath.row]
        let detail = SeaSonDetailViewController()
        detail.season = season
        navigationController?.pushViewController(detail, animated: true)
    }
}
