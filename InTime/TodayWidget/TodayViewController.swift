//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by lisilong on 2019/11/23.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation

private var CellHeight: CGFloat = 60.0

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let TodayWidgetTableViewCellID = "TodayWidgetTableViewCellID"
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodayWidgetTableViewCell.self, forCellReuseIdentifier: TodayWidgetTableViewCellID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    let defalutBgImage: UIImage? = {
        var image: UIImage? = nil
        if let path = Bundle.main.path(forResource: "bg/bg13", ofType: "png") {
            image = UIImage(contentsOfFile: path)
        }
        return image
    }()
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.image = defalutBgImage
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var seasons: [SeasonModel] = [SeasonModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
         
        extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
           
        view.addSubview(bgImageView)
        view.addSubview(tableView)
         
        loadseasons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgImageView.isHidden = !HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        bgImageView.frame =  view.bounds
        tableView.frame = view.bounds
    }
     
    // MARK: - widget
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let height: CGFloat = activeDisplayMode == .expanded ? 300.0 : 500.0
        self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: height)
        CellHeight = activeDisplayMode == .expanded ? 60.0 : 55.0
        self.tableView.reloadData()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - actions
      
    func gotoMainVC(_ season: SeasonModel) {
        guard let schema = URL.init(string: IncomeTodayWidgetSchema + "\(season.id)") else { return }
        self.extensionContext?.open(schema, completionHandler: { (success) in
            CommonTools.printLog(message: success ? "跳转到知时节主工程成功！" :  "跳转到知时节主工程失败！")
        })
    }
    
    func updateBgView() {
        guard let season = seasons.first, HandleAppGroupsDocumentMannager.isShowBgImageInMainScreen() else {
            return
        }
         
        bgImageView.image = nil
        bgImageView.backgroundColor = UIColor.clear
        
        var bgImage: UIImage? = nil
        if let path = Bundle.main.path(forResource: "bg/\(season.backgroundModel.name)", ofType: "png") {
            bgImage = UIImage(contentsOfFile: path)
        }
        
        let bgColor = UIColor.color(hex: season.backgroundModel.name)
        if season.backgroundModel.type == .custom {
           let imageData = HandleAppGroupsDocumentMannager.getCustomImage(imageName: season.backgroundModel.name)
            if imageData != nil {
                bgImage = UIImage(data: imageData!)
            }
        }
        
        if season.backgroundModel.type == .custom || season.backgroundModel.type == .image {
            bgImageView.image = bgImage
        } else {
            bgImageView.image = nil
            bgImageView.backgroundColor = bgColor
        }
    }
         
    // MARK: - load dataSource
    
    /// 加载所有的分类类别
    func loadLocalCategorys(completion: (_ categorys: [CategoryModel]) -> ()) {
        var models: [CategoryModel] = [CategoryModel]()
        if let data = HandleAppGroupsDocumentMannager.getCategorys() {
            let categoryJsons = NSKeyedUnarchiver.unarchiveObject(with: data)
            if categoryJsons is Array<String>, let jsonStrs: [String] = categoryJsons as? [String] {
                for jsonStr in jsonStrs {
                    let json = JSON(parseJSON: jsonStr)
                    let model = CategoryModel.convertToModel(json: json)
                    models.append(model)
                }
            }
        }
        completion(models)
    }
    
    /// 获取所有时节
    static func loadAllSeasons(completion: (_ seasons: [SeasonModel]) -> ()) {
        var seasons = [SeasonModel]()
        if let seasonsData = HandleAppGroupsDocumentMannager.getSeasons(seasonType: HomeRingSeasonsKey) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, let jsonStrs: [String] = seasonJsons as? [String] {
                for jsonStr in jsonStrs {
                    let json = JSON(parseJSON: jsonStr)
                    let model = SeasonModel.convertToModel(json: json)
                    if model.isShowInMainScreen {
                        seasons.append(model)
                    }
                }
            }
        }
        completion(seasons)
    }
    
    func loadseasons() {
        TodayViewController.loadAllSeasons { [weak self] (seasons) in
            DispatchQueue.main.async {
                self?.seasons = seasons
                self?.updateBgView()
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayWidgetTableViewCellID, for: indexPath) as! TodayWidgetTableViewCell
        cell.setContent(seasons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.gotoMainVC(seasons[indexPath.row])
    }
}

