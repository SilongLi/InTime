//
//  CommonAlertTableView.swift
//  InTime
//
//  Created by lisilong on 2019/1/18.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

class CommonAlertTableView: CKAlertCommonView {
    
    let CellHeight: CGFloat = 50.0
    let HeaderHeight: CGFloat = 44.0
    
    lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.backgroundColor = UIColor.garyColor.withAlphaComponent(0.6)
        return label
    }()
    
    lazy var modifyBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "revise"), for: .normal)
        return btn
    }()
    
    lazy var addNewBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "add"), for: .normal)
        return btn
    }()
    
    let AlertCellId = "AlertCellId"
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: AlertCellId)
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    public var selectedActionBlock: ((_ alertModel: AlertCollectionModel, _ selectedTextModel: TextModel) -> ())?
    var alertModel: AlertCollectionModel?

    init(model: AlertCollectionModel?, selectedAction: ((_ alertModel: AlertCollectionModel, _ selectedTextModel: TextModel) -> ())? = nil) {
        super.init(animationStyle: .CKAlertFadePop, alertStyle: .CKAlertStyleAlert)
        
        self.alertModel = model
        self.selectedActionBlock = selectedAction
        headerTitleLabel.text = model?.title
        
        setupSubviews()
        tableView.reloadData()
        
        backgroundAction = { [weak self] in
            self?.hiddenAlertView()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    func setupSubviews() {
        backgroundColor = UIColor.tintColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        addSubview(headerTitleLabel)
        addSubview(tableView)
        addSubview(modifyBtn)
        addSubview(addNewBtn)
        
        let btnWidth: CGFloat = 36.0
        addNewBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-10.0)
            make.width.equalTo(btnWidth)
        }
        modifyBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(addNewBtn.snp.left)
            make.width.equalTo(btnWidth)
        }
        headerTitleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(HeaderHeight)
        }
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(headerTitleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = CellHeight * CGFloat((alertModel?.texts.count ?? 5)) + HeaderHeight
        var bounds = self.bounds
        bounds.size.height = height
        self.bounds = bounds
        
        tableView.frame = CGRect.init(x: 0.0,
                                      y: HeaderHeight + 0.5,
                                      width: bounds.size.width,
                                      height: height - HeaderHeight - 0.5)
    }
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>
extension CommonAlertTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertModel?.texts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {let cell = tableView.dequeueReusableCell(withIdentifier: AlertCellId, for: indexPath) as! CategoryTableViewCell
        cell.model = alertModel?.texts[indexPath.row]
        cell.margin = 20.0
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
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let models = alertModel?.texts {
            for model in models {
                model.isSelected = false
            }
            let model = models[indexPath.item]
            model.isSelected = true
            alertModel?.texts[indexPath.item] = model
        }
        if let model = alertModel, let block = selectedActionBlock {
            let selectedModel = model.texts[indexPath.row]
            block(model, selectedModel)
        }
        hiddenAlertView()
    }
}
