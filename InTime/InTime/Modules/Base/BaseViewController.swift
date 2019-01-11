//
//  BaseViewController.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.strokeColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Custome view back button
        self.configBackButton()
    }
    
    deinit {
        CommonTools.printLog(message: "----\(self.classForCoder) is dealloc----")
    }
    
    fileprivate func initBackButton() {
        let backButtonImage = UIImage.init(named: "back")
        let backButton =  UIButton.init(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configBackButton() {
        guard (navigationController?.viewControllers.count) != nil else {
            return
        }
        if navigationController != nil && (navigationController?.viewControllers.count ?? 0) > 1 {
            initBackButton()
        }
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController {
    /// 侧滑假死
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewControllers = navigationController?.viewControllers else {
            return false
        }
        if viewControllers.count <= 1 {
            return false
        } else {
            return true
        }
    }
}

