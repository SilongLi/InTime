//
//  ITSelectedTextColorTableViewCell.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 字体颜色

import UIKit

class ITSelectedTextColorTableViewCell: BaseTableViewCell {

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
    
    let CellId = "SelectedTextColorCellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: NewSeasonMargin, bottom: 0.0, right: NewSeasonMargin)
        layout.minimumLineSpacing = 13.0
        layout.minimumInteritemSpacing = 5.0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 46.0, height: 46.0)
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(BackgroundImageDetailCollectionViewCell.self, forCellWithReuseIdentifier: CellId)
        return collection
    }()
    
    var delegate: TextColorDelegate?
    var textColorModel: TextColorModel?
    
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
        delegate = self.it.atViewController() as? TextColorDelegate
        guard model is TextColorModel else {
            return
        }
        let model = model as! TextColorModel
        textColorModel = model
        nameLabel.text = model.name
    }
}

// MARK: - <UICollectionViewDataSource, UICollectionViewDelegate>
extension ITSelectedTextColorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textColorModel?.colors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! BaseCollectionViewCell
        cell.layer.cornerRadius  = 4.0
        cell.layer.masksToBounds = true
        if let model = textColorModel?.colors[indexPath.item] {
            var selectedIcon: UIImageView? = cell.contentView.viewWithTag(1997) as? UIImageView
            if selectedIcon == nil {
                selectedIcon = UIImageView(image: UIImage(named: "selected"))
                selectedIcon?.tag = 1997
                cell.contentView.addSubview(selectedIcon!)
                selectedIcon?.snp.makeConstraints({ (make) in
                    make.center.equalToSuperview()
                    make.size.equalTo(CGSize(width: 20.0, height: 20.0))
                })
            }
            selectedIcon?.isHidden = !model.isSelected
            cell.backgroundColor = UIColor.color(hex: model.color)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bgM = textColorModel {
            for model in bgM.colors {
                model.isSelected = false
            }
            let model = bgM.colors[indexPath.item]
            model.isSelected = true
            textColorModel?.colors[indexPath.item] = model
            delegate?.didSelectedTextColorAction(model: textColorModel!)
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
