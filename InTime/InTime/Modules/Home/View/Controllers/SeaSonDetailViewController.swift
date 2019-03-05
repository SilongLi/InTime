//
//  SeaSonDetailViewController.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class SeaSonDetailViewController: BaseViewController {
    
    /// 交替显示背景图片
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tintColor
        return view
    }()
    lazy var bgImageViewAlternate: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tintColor
        view.alpha = 0.0
        return view
    }()
    
    let CellId = "SeasonDetailCellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: IT_SCREEN_WIDTH, height: IT_SCREEN_HEIGHT)
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.register(SeasonDetailCollectionViewCell.self, forCellWithReuseIdentifier: CellId)
        return collection
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "share"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(gotoShareSeasonAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    /// 图片展示动画的时间
    let AnimateDuration: TimeInterval = 1.0
    
    var category: CategoryModel?
    var seasons: [SeasonModel] = [SeasonModel]()
    var currentSelectedIndex: Int = 0
    
    var originContentOffsetX: CGFloat = 0.0
    var currentShowBgImageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupSubviews()
        setupContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - setup
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadSeasions), name: NotificationAddNewSeason, object: nil)
    }
    
    func setupSubviews() {
        view.backgroundColor = UIColor.tintColor
        
        // 添加修改“时节”按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "revise"), style: UIBarButtonItem.Style.done, target: self, action: #selector(gotoModifySeasonAction))
        
        view.addSubview(bgImageView)
        view.addSubview(bgImageViewAlternate)
        view.addSubview(collectionView)
        view.addSubview(shareBtn)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgImageViewAlternate.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(IT_IPHONE_X ? -50 : -30)
            make.size.equalTo(CGSize.init(width: 40.0, height: 40.0))
        }
        
        // 处理系统右滑返回手势和scrollView滑动手势冲突问题
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            collectionView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
    }
    
    func setupContentView() {
        guard currentSelectedIndex < seasons.count else {
            return
        }
        navigationItem.title = "\(currentSelectedIndex + 1) / \(seasons.count)"
        
        let seasion = seasons[currentSelectedIndex]
        if seasion.backgroundModel.type == .image {
            bgImageView.image = UIImage(named: seasion.backgroundModel.name)
        } else {
            bgImageView.image = nil
            bgImageView.backgroundColor = UIColor.color(hex: seasion.backgroundModel.name)
        }
        currentShowBgImageView = bgImageView
        
        // 滚动到选中页
        collectionView.reloadData()
        collectionView.performBatchUpdates({
        }) { (_) in
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentSelectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK: - load DataSource
    @objc func loadSeasions() {
        guard let categoryModel = category else {
            CommonTools.printLog(message: "[Debug] 分类ID为空！")
            return
        }
        if categoryModel.isDefault {
            HomeSeasonViewModel.loadAllSeasons { [weak self] (seasons) in
                self?.seasons = seasons
                self?.setupContentView()
            }
        } else {
            HomeSeasonViewModel.loadLocalSeasons(categoryId: categoryModel.id) { [weak self] (seasons) in
                self?.seasons = seasons
                self?.setupContentView()
            }
        }
    }
    
    // MARK: - actions
    @objc func gotoModifySeasonAction() {
        guard currentSelectedIndex > -1, currentSelectedIndex < seasons.count else {
            return
        }
        let modifySeasonVC = AddNewSeasonViewController()
        modifySeasonVC.newSeason = seasons[currentSelectedIndex]
        navigationController?.pushViewController(modifySeasonVC, animated: true)
    }
    
    @objc func gotoShareSeasonAction() {
        // TODO: 分享时节
        print("分享")
    }
}

// MARK: - <UICollectionViewDataSource, UICollectionViewDelegate>
extension SeaSonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! SeasonDetailCollectionViewCell
        cell.season = seasons[indexPath.row]
        return cell
    }
}

// MARK: - <UIScrollViewDelegate>
extension SeaSonDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard seasons.count > 0 else { return }
        let contentOffsetX = scrollView.contentOffset.x
        let isFroward = contentOffsetX - originContentOffsetX > 0
        let offsetX = abs(contentOffsetX - CGFloat(currentSelectedIndex) * IT_SCREEN_WIDTH)
        if offsetX > IT_SCREEN_WIDTH * 0.5 {
            updateContentView(isForward: isFroward)
        }
        originContentOffsetX = contentOffsetX
    }
    
    func updateContentView(isForward: Bool) {
        /// 修改背景图
        let index = currentSelectedIndex
        let newIndex = isForward ? index + 1 : index - 1
        guard newIndex > -1, newIndex < seasons.count, currentSelectedIndex != newIndex else {
                return
        }
        let seasion = seasons[index]
        let newSeasion = seasons[newIndex]
        if currentShowBgImageView == bgImageView {
            if seasion.backgroundModel.type == .image {
                bgImageView.image = UIImage(named: seasion.backgroundModel.name)
            } else {
                bgImageView.image = nil
                bgImageView.backgroundColor = UIColor.color(hex: seasion.backgroundModel.name)
            }
            
            if newSeasion.backgroundModel.type == .image {
                bgImageViewAlternate.image = UIImage(named: newSeasion.backgroundModel.name)
            } else {
                bgImageViewAlternate.image = nil
                bgImageViewAlternate.backgroundColor = UIColor.color(hex: newSeasion.backgroundModel.name)
            }
            
            UIView.animate(withDuration: AnimateDuration) {
                self.bgImageView.alpha = 0.0
                self.bgImageViewAlternate.alpha = 1.0
            }
            
        } else {
            if newSeasion.backgroundModel.type == .image {
                bgImageView.image = UIImage(named: newSeasion.backgroundModel.name)
            } else {
                bgImageView.image = nil
                bgImageView.backgroundColor = UIColor.color(hex: newSeasion.backgroundModel.name)
            }
            
            if seasion.backgroundModel.type == .image {
                bgImageViewAlternate.image = UIImage(named: seasion.backgroundModel.name)
            } else {
                bgImageViewAlternate.image = nil
                bgImageViewAlternate.backgroundColor = UIColor.color(hex: seasion.backgroundModel.name)
            }
            
            UIView.animate(withDuration: AnimateDuration) {
                self.bgImageView.alpha = 1.0
                self.bgImageViewAlternate.alpha = 0.0
            }
        }
        currentSelectedIndex = newIndex
        currentShowBgImageView = currentShowBgImageView == bgImageView ? bgImageViewAlternate : bgImageView
        
        /// 修改标题
        navigationItem.title = "\(currentSelectedIndex + 1) / \(seasons.count)"
    }
}
