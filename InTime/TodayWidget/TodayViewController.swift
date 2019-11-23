//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by lisilong on 2019/11/23.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        let btn = UIButton.init(frame: CGRect.init(x: 30.0, y: 20.0, width: 40.0, height: 40.0))
        btn.addTarget(self, action: #selector(gotoMainVC), for: UIControl.Event.touchUpInside)
        btn.setTitle("进入", for: UIControl.State.normal)
        view.addSubview(btn)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let height: CGFloat = activeDisplayMode == .expanded ? 200.0 : 500.0
        self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: height)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
     
    @objc func gotoMainVC() {
        guard let schema = URL.init(string: "IncomeTodayWidget://1987") else { return }
        self.extensionContext?.open(schema, completionHandler: { (success) in
            print(success ? "跳转到知时节主工程成功！" :  "跳转到知时节主工程失败！")
        })
    }
}
