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

class HomeViewController: UIViewController {
    
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
        view.backgroundColor = UIColor.tintColor
        
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
        view.backgroundColor = UIColor.tintColor
        return view
    }()
    
    var isShow: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.tintColor
        fd_prefersNavigationBarHidden = true
        setupSubviews()
        loadCategorys()
    }
    
    // MARK: - setup
    func setupSubviews() {
        view.addSubview(navigationView)
        view.addSubview(selectedCategoryView)
        navigationView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(IT_NaviHeight)
        }
        selectedCategoryView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(IT_NaviHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.01)
        }
        selectedCategoryView.selectedCategoryBlock = { [weak self] (model) in
            let isShow = !(self?.isShow ?? false)
            if isShow {
                self?.iconView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            } else {
                self?.iconView.transform = CGAffineTransform.identity
            }
            self?.titleLabel.text = model?.title
            self?.isShow = isShow
        }
    }
    
    // MARK: - load DataSource
    func loadCategorys() {
        var model1 = CategoryModel()
        model1.title = "全部"
        
        var model2 = CategoryModel()
        model2.title = "节假日"
        
        var model3 = CategoryModel()
        model3.title = "时节"
        
        var model4 = CategoryModel()
        model4.title = "生日"
        
        selectedCategoryView.dataSource = [model1, model2, model3, model4]
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
        isShow = !isShow
        if isShow {
            iconView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            selectedCategoryView.showListView()
        } else {
            iconView.transform = CGAffineTransform.identity
            selectedCategoryView.hiddenListView()
        }
    }

}
