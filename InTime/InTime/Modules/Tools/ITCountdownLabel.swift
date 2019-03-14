//
//  ITCountdownLabel.swift
//  InTime
//
//  Created by lisilong on 2019/3/9.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

/// 动画类型
public enum CountdownEffect: String {
    case Anvil      = "Anvil"
    case Burn       = "Burn"
    case Evaporate  = "Evaporate"
    case Fall       = "Fall"
    case Pixelate   = "Pixelate"
    case Scale      = "Scale"
    case Sparkle    = "Sparkle"
    case None       = "None"
    
    func toLTMorphing() -> LTMorphingEffect? {
        switch self {
        case .Anvil     : return .anvil
        case .Burn      : return .burn
        case .Evaporate : return .evaporate
        case .Fall      : return .fall
        case .None      : return nil
        case .Pixelate  : return .pixelate
        case .Scale     : return .scale
        case .Sparkle   : return .sparkle
        }
    }
    
    func desc() -> String {
        switch self {
        case .Anvil     : return "震撼"
        case .Burn      : return "燃烧"
        case .Evaporate : return "蒸发"
        case .Fall      : return "坠落"
        case .Pixelate  : return "像素化"
        case .Scale     : return "缩放"
        case .Sparkle   : return "魔法"
        case .None      : return "默认"
        }
    }
}

public class ITCountdownLabel: LTMorphingLabel {
    /// 动画刷新时间
    internal let defaultFireInterval = 1.0
    
    // 动画类型
    public var animationType: CountdownEffect? {
        didSet {
            if let effect = animationType?.toLTMorphing() {
                morphingEffect = effect
                morphingEnabled = true
            } else {
                morphingEnabled = false
            }
        }
    }
    
    /// 定时器
    private var refreshTimer: DispatchSourceTimer?
    
    /// 闹铃时间
    internal var targetDate: NSDate = NSDate()
    
    /// 时间显示格式
    var unitType: DateUnitType = DateUnitType.dayTime
    
    var completion: ((_ isLater: Bool) -> ())?
    
    // MARK: - Initialize
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    deinit {
        disposeTimer()
    }
    
    var aType: CountdownEffect?
    
    // MARK: - setup
    
    func setupContent(date: NSDate, unitType: DateUnitType, animationType: CountdownEffect, completion: ((_ isLater: Bool) -> ())?) {
        self.targetDate = date
        self.unitType = unitType
        self.animationType = animationType
        self.aType = animationType
        self.completion = completion
        
        setupTimer()
    }
    
    func setupTimer() {
        disposeTimer()
        
        refreshTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        refreshTimer?.schedule(deadline: .now(), repeating: 1.0)
        refreshTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.updateLabel()
                
                if let block = self?.completion {
                    let isLater = self?.targetDate.isLaterThanDate(Date()) ?? false
                    block(isLater)
                }
            }
        })
        refreshTimer?.resume()
    }
    
    func disposeTimer() {
        if refreshTimer != nil {
            refreshTimer?.cancel()
            refreshTimer = nil
        }
    }
    
    // MARK: - 时间显示格式处理
    @objc func updateLabel() {
        if let type = aType {
            self.animationType = type
        }
        text = (targetDate as Date).convertToTimeAndUnitString(type: unitType)
    }}
