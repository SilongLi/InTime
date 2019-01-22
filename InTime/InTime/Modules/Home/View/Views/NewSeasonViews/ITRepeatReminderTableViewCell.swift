//
//  ITRepeatReminderTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 重复提醒

import UIKit

class ITRepeatReminderTableViewCell: BaseTableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var reminderView: UIView = {
        let view = UIView()
        return view
    }()
    
    let CellId = "RepeatReminderCellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: NewSeasonMargin, bottom: 0.0, right: NewSeasonMargin)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 5.0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 50.0, height: 36.0)
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellId)
        return collection
    }()
    
    var delegate: RepeatRemindersDelegate?
    var rrModel: RepeatReminderModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        addSubview(nameLabel)
        addSubview(reminderView)
        reminderView.addSubview(collectionView)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10.0)
            make.left.equalTo(NewSeasonMargin)
            make.width.greaterThanOrEqualTo(60.0)
            make.height.equalTo(20.0)
        }
        reminderView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5.0)
        }
        collectionView.snp.makeConstraints { (make) in 
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        delegate = self.it.atViewController() as? RepeatRemindersDelegate
        guard model is RepeatReminderModel else {
            return
        }
        let model = model as! RepeatReminderModel
        rrModel = model
        nameLabel.text = model.name
        collectionView.reloadData()
    }
}

// MARK: - <UICollectionViewDataSource, UICollectionViewDelegate>
extension ITRepeatReminderTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rrModel?.types.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath)
        cell.layer.borderColor   = UIColor.greenColor.cgColor
        cell.layer.borderWidth   = 1.0
        cell.layer.cornerRadius  = 3.0
        cell.layer.masksToBounds = true
        if let types = rrModel?.types {
            let model = types[indexPath.item]
            var titleLabel: UILabel? = cell.contentView.viewWithTag(1997) as? UILabel
            if titleLabel == nil {
                titleLabel = UILabel()
                titleLabel?.tag = 1997
                titleLabel?.font = UIFont.systemFont(ofSize: 13)
                titleLabel?.textAlignment = .center
                titleLabel?.textColor = UIColor.greenColor
                cell.contentView.addSubview(titleLabel!)
                titleLabel?.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
            }
            titleLabel?.text = model.title
            titleLabel?.textColor = model.isSelected ? UIColor.white : UIColor.greenColor
            titleLabel?.backgroundColor = model.isSelected ? UIColor.greenColor : UIColor.tintColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let repeatModel = rrModel {
            for model in repeatModel.types {
                model.isSelected = false
            }
            let model = repeatModel.types[indexPath.item]
            model.isSelected = true
            rrModel?.types[indexPath.item] = model
            delegate?.didSelectedRepeatRemindersAction(model: model)
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
