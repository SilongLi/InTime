//
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation
import UIKit

open class TDTimerView: UIView {

    var second: Int           = 60
    var start: CFTimeInterval = 0     //记录回到前台的时间
    var end: CFTimeInterval   = 0     //记录退到后台的时间
    var leftMessage: String   = ""
    var rightMessage: String  = ""
    var source: DispatchSourceTimer?

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.removeNotification()
    }

    // APP进入后台定时器停止处理
    func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(notification:)), name: NSNotification.Name.NSExtensionHostWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: NSNotification.Name.NSExtensionHostDidEnterBackground, object: nil)

    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSExtensionHostWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSExtensionHostDidEnterBackground, object: nil)
    }

    @objc func applicationWillEnterForeground(notification: Notification) {
        if notification.object is UIApplication {
            end = CACurrentMediaTime()
            second = second - Int(abs(end - start))  // 重置当前定时器的时间，退到后台前的时间-后台停留的时间
        }
    }

    @objc func applicationDidEnterBackground(notification: Notification) {
        if notification.object is UIApplication {
            start = CACurrentMediaTime()
        }
    }

    func configData(counter: Int,
                    leftText: String = "",
                    rightText: String = "") {
        self.setupViews()
        second = counter
        leftMessage = leftText
        rightMessage = rightText

        self.addNotification()
    }

    func setupViews() {
        self.addSubview(textLabel)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[textLabel]-10-|", options: [], metrics: nil, views: ["textLabel": textLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[textLabel]-10-|", options: [], metrics: nil, views: ["textLabel": textLabel]))
    }

    func startTimer(finishBlock: @escaping (Int) -> Void) {
        let queue = DispatchQueue.global()
        // 创建事件源
        source = DispatchSource.makeTimerSource(flags: [], queue: queue)
        // leeway表示误差，0表示最大精度
        source?.schedule(deadline: .now(), repeating: 1, leeway: DispatchTimeInterval.milliseconds(0))
        source?.setEventHandler {
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    finishBlock(strongSelf.second)
                    if strongSelf.second <= 0 {
                        strongSelf.second = 0
                        strongSelf.textLabel.text = strongSelf.leftMessage + "0" + strongSelf.rightMessage
                        strongSelf.source?.cancel()
                    } else {
                        strongSelf.textLabel.text = strongSelf.leftMessage + String(strongSelf.second) + strongSelf.rightMessage
                        strongSelf.second -= 1
                    }
                }
            }
        }
        source?.resume()
    }

    func stopTimer() {
        source?.cancel()
    }
}
