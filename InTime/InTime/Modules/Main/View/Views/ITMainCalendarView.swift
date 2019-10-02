//
//  ITMainCalendarView.swift
//  InTime
//
//  Created by lisilong on 2019/9/4.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class ITMainCalendarView: UIView {

    private static let menuViewHeight: CGFloat = 40.0
    private static let calendarViewWeekHeight: CGFloat = 50.0
    private static let calendarViewMonthHeight: CGFloat = 250.0
    
    lazy var menuView: CVCalendarMenuView = {
        let menuView = CVCalendarMenuView()
        return menuView
    }()
    
    lazy var calendarView: CVCalendarView = {
        let calendar = CVCalendarView()
        calendar.calendarMode = .weekView
        return calendar
    }()
    
    private lazy var currentCalendar: Calendar = {
        var currentCalendar = Calendar.current
        return currentCalendar
    }()
    
    public var calendarMode: CalendarMode = .weekView {
        didSet {
            calendarView.changeMode(calendarMode)
            self.setNeedsLayout()
        }
    }
    
    var didSelectedDateBlock: ((_ date: CVDate) -> ())?
     
    init(_ didSelectedDateBlock: ((_ date: CVDate) -> ())?) {
        super.init(frame: CGRect.zero)
        self.didSelectedDateBlock = didSelectedDateBlock
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        menuView.menuViewDelegate = self
        
        calendarView.calendarDelegate = self
        calendarView.calendarAppearanceDelegate = self
        calendarView.animatorDelegate = self
        
        addSubview(menuView)
        addSubview(calendarView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        menuView.frame = CGRect(x: 0, y: 0.0, width: self.frame.size.width, height: ITMainCalendarView.menuViewHeight)
        calendarView.frame = CGRect(x: 0, y: ITMainCalendarView.menuViewHeight, width: self.frame.size.width, height: calendarViewHeight())
        
        menuView.commitMenuViewUpdate()
        calendarView.commitMainCalendarViewUpdate()
    }
    
    private func calendarViewHeight() -> CGFloat {
        return calendarView.calendarMode == .monthView ? ITMainCalendarView.calendarViewMonthHeight : ITMainCalendarView.calendarViewWeekHeight
    }

    func heightForView() -> CGFloat { 
        return ITMainCalendarView.menuViewHeight + calendarViewHeight()
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension ITMainCalendarView: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    func presentationMode() -> CalendarMode {
        return .weekView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? {
        return currentCalendar
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return calendarView.calendarMode == .weekView
    }
    
    // Defaults to true
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        if let block = self.didSelectedDateBlock {
            block(dayView.date)
        }
    }
    
    func shouldSelectRange() -> Bool {
        return false
    }
    
    func presentedDateUpdated(_ date: CVDate) {
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = UIColor.heightLightGrayColor
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func disableScrollingBeforeDate() -> Date { return Date.init(timeIntervalSince1970: 0) }
    
    func maxSelectableRange() -> Int { return 1 }
    
    func earliestSelectableDate() -> Date { return Date.init(timeIntervalSince1970: 0) }
    
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 36500
        let calendar = Calendar(identifier: .chinese)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        }
        return Date()
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        if weekday == .sunday || weekday == .saturday {
            return UIColor.heightLightGrayColor
        }
        return UIColor.heightLightGrayNoPressColor
    }
    
    func dayOfWeekFont() -> UIFont {
        return UIFont(name: TimeNumberFontName, size: TimeNumberFontSize) ?? UIFont.systemFont(ofSize: TimeNumberFontSize)
    }
     
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.heightLightGrayNoPressColor.withAlphaComponent(0.1)
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension ITMainCalendarView: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor {
        return UIColor.greenColor
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont {
        return UIFont(name: TimeNumberFontName, size: TimeNumberFontSize) ?? UIFont.systemFont(ofSize: TimeNumberFontSize)
    }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _):
            return UIColor.white
        case (.sunday, .in, .present), (.saturday, .in, .present):
            return UIColor.white
        case (.sunday, _, _), (.saturday, _, _):
            return UIColor.heightLightGrayColor
        case (_, .in, _):
            return UIColor.heightLightGrayNoPressColor
        default:
            return UIColor.heightLightGrayNoPressColor
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _):
            return UIColor.greenColor
        case (_, .selected, _), (_, .highlighted, _):
            return UIColor.greenColor
        default:
            return nil
        }
    }
    
    func topMarkerColor() -> UIColor {
        return UIColor.clear
    }
}



// MARK: - Convenience API Demo

extension ITMainCalendarView {
    func toggleMonthViewWithMonthOffset(offset: Int) {
         // from today
        var components = Manager.componentsForDate(Date(), calendar: currentCalendar)
        components.month! += offset
        if let resultDate = currentCalendar.date(from: components) {
            self.calendarView.toggleViewWithDate(resultDate)
        }
    }
    
    
    func didShowNextMonthView(_ date: Date) {
    }
     
    func didShowPreviousMonthView(_ date: Date) {
    }
    
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
    }
    
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
    }
    
}
