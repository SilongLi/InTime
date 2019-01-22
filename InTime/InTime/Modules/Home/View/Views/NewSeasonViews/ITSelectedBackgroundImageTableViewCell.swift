//
//  ITSelectedBackgroundImageTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 自定义背景

import UIKit

class ITSelectedBackgroundImageTableViewCell: BaseTableViewCell {

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
    
    let CellId = "SelectedBackgroundImageCellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: NewSeasonMargin, bottom: 0.0, right: NewSeasonMargin)
        layout.minimumLineSpacing = 13.0
        layout.minimumInteritemSpacing = 5.0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90.0, height: 135.0)
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(BackgroundImageDetailCollectionViewCell.self, forCellWithReuseIdentifier: CellId)
        return collection
    }()
    
    var delegate: BackgroundImageDelegate?
    var bgModel: BackgroundModel?
    
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
        delegate = self.it.atViewController() as? BackgroundImageDelegate
        guard model is BackgroundModel else {
            return
        }
        let model = model as! BackgroundModel
        bgModel = model
        nameLabel.text = model.name
        collectionView.reloadData()
    }
}

// MARK: - <UICollectionViewDataSource, UICollectionViewDelegate>
extension ITSelectedBackgroundImageTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bgModel?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! BaseCollectionViewCell
        if let model = bgModel?.images[indexPath.item] {
            cell.setupContent(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bgM = bgModel {
            for model in bgM.images {
                model.isSelected = false
            }
            let model = bgM.images[indexPath.item]
            model.isSelected = true
            bgModel?.images[indexPath.item] = model
            delegate?.didSelectedBackgroundImageAction(model: model)
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    } 
}

class BackgroundImageDetailCollectionViewCell: BaseCollectionViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.greenColor
        label.isHidden = true
        return label
    }()
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var selectedIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "selected"))
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(bgImageView)
        addSubview(selectedIcon)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.left.right.equalToSuperview()
            make.height.equalTo(16.0)
        }
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        selectedIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.size.equalTo(CGSize(width: 20.0, height: 20.0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent<T>(model: T, indexPath: IndexPath) {
        guard model is BackgroundImageModel else {
            return
        }
        let model = model as! BackgroundImageModel
        
        layer.borderColor   = UIColor.greenColor.cgColor
        layer.borderWidth   = 0.0
        layer.cornerRadius  = 5.0
        layer.masksToBounds = true
        nameLabel.isHidden  = true
        bgImageView.isHidden = false
        bgImageView.image    = nil
        bgImageView.backgroundColor = UIColor.tintColor
        selectedIcon.isHidden = !model.isSelected
        
        switch model.type {
        case .custom:
            layer.borderWidth  = 1.0
            nameLabel.isHidden = false
            bgImageView.isHidden = true
            if model.name.isEmpty {
                nameLabel.text = "自定义"
            } else {
                bgImageView.image = UIImage(named: model.name)
            }
        case .image:
            bgImageView.image = UIImage(named: model.name)
        case .color:
            bgImageView.backgroundColor = UIColor.color(hex: model.name)
        }
    }
}
