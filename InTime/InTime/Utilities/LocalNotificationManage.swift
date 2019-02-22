//
//  LocalNotificationManage.swift
//  InTime
//
//  Created by lisilong on 2019/2/22.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationManage: NSObject {

    static let shared = LocalNotificationManage()
    
    // MARK: - 发送本地推送方法
    func sendLocalNotification(title: String, subTitle: String, body: String?, identifier: String, soundName: String, date: Date, isRepeats: Bool) -> () {
        LocalNotificationManage.shared.cancelLocalNotification(identifier: identifier, title: title)
        if #available(iOS 10.0, *) {
            LocalNotificationManage.shared.sendLocalNotificationOniOS10(title: title,
                                                                        subTitle: subTitle,
                                                                        body: body,
                                                                        identifier: identifier,
                                                                        soundName: soundName,
                                                                        date: date,
                                                                        isRepeats: isRepeats)
        } else {
            // TODO:
        }
    }
    
    /// iOS 10.0以上系统，发送本地推送方法
    @available(iOS 10.0, *)
    private func sendLocalNotificationOniOS10(title: String, subTitle: String, body: String?, identifier: String, soundName: String, date: Date, isRepeats: Bool) -> () {
        
        // 通知内容
        let content = UNMutableNotificationContent()
        content.title       = title
        content.subtitle    = subTitle
        content.body        = body ?? ""
        content.badge       = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.launchImageName = "InTime"
        content.categoryIdentifier = identifier
        
        // 通知附件内容
        let path = Bundle.main.path(forResource: "ring.caf", ofType: nil)
        let url  = URL(fileURLWithPath: path ?? "")
        let attachment = try? UNNotificationAttachment(identifier: identifier, url: url, options: nil)
        if let att: UNNotificationAttachment = attachment {
            content.attachments = [att]
        }
        
        // 闹铃
        if !soundName.isEmpty {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
        } else {
            content.sound = UNNotificationSound.default
        }
        
        // 触发模式
        let timeInterval = date.timeIntervalSinceNow
        guard timeInterval > 0 else {
            return
        }
        var repeats = isRepeats
        if repeats, timeInterval <= 60.0 {
            repeats = false
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // 把通知加到UNUserNotificationCenter, 到指定触发点会被触发
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                CommonTools.printLog(message: error?.localizedDescription)
            } else {
                CommonTools.printLog(message: "[知时节]：设置闹铃成功！")
            }
        }
    }
    
    // MARK: - 取消本地通知
    func cancelLocalNotification(identifier: String, title: String) {
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            for noti: UILocalNotification in notifications {
                if noti.category == identifier {
                    UIApplication.shared.cancelLocalNotification(noti)
                    CommonTools.printLog(message: "[知时节]：取消”\(title)“闹铃成功！")
                }
            }
        }
    }
}
