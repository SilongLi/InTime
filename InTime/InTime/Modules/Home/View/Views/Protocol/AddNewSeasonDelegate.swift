//
//  AddNewSeasonDelegate.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

// 输入框
protocol InputTextFieldDelegate: class {
    func didClickedEndEditing(model: InputModel)
}

// 时间选择
protocol SelectedTimeDelegate: class {
    /// 选择时间提示
    func didClickedNoteInfoAction()
    func didClickedShowCalendarViewAction(model: TimeModel)
    /// 切换农历和公历
    func didClickedOpenGregorianSwitchAction(isGregorian: Bool)
}

// 信息选择
protocol InfoSelectedDelegate: class {
    func didClickedInfoSelectedAction(model: InfoSelectedModel)
}

// 是否开启时节提醒
protocol NoteSwitchDelegate: class {
    func didClickedReminderSwitchAction(isOpen: Bool)
}

// 重复提醒
protocol RepeatRemindersDelegate: class {
    func didSelectedRepeatRemindersAction(model: RepeatReminderModel)
}

// 自定义背景
protocol BackgroundImageDelegate: class {
    func didSelectedBackgroundImageAction(model: BackgroundModel)
}

// 字体颜色
protocol TextColorDelegate: class {
    func didSelectedTextColorAction(model: TextColorModel)
}
