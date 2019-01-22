
//
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation
import UIKit

class TDLoadingView: UIView {

    // 动画视图
    private var animationView: TDAnimationView!
    // 图片位置
    private var imageViewPosition: ImagePosition!
    // 图片大小
    private var imageViewSize: CGSize!
    // 图片间距
    private var imageInsets: UIEdgeInsets!
    // 文字间距
    private var textInsets: UIEdgeInsets!
    // 字体
    private var font: UIFont!

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 设置自定义loding视图
    ///
    /// - Parameters:
    ///   - string: 标题
    ///   - type: 自定义动画类型
    ///   - animations: 注意：如果type为defaultAnimations、animationGroup，则传动画图片名集合，如果type为gif，则传gif文件名
    ///   - style: loading框样式
    func configData(_ string: String,
                    type: AnimationType?,
                    animationGifName: String? = nil,
                    animations: [UIImage]? = nil,
                    style: LoadingStyle,
                    imagePosition: ImagePosition,
                    imageSize: CGSize,
                    imageEdgeInsets: UIEdgeInsets,
                    textEdgeInsets: UIEdgeInsets,
                    font: UIFont,
                    animationDuring: TimeInterval) {

        // 设置标题
        textLabel.text = string

        imageViewSize = imageSize

        imageViewPosition = imagePosition

        imageInsets = imageEdgeInsets

        textInsets = textEdgeInsets

        self.textLabel.font = font

        // 设置动画
        self.animationView = TDAnimationView(type: type,
                                             animationGifName: animationGifName,
                                             animations: animations,
                                             imageSize: imageSize,
                                             animationDuring: animationDuring)
        self.animationView.translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .normal:
            self.textLabel.textColor = .white
        case .gray:
            self.animationView.indicatorView.style = .gray
            self.textLabel.textColor = .gray
        case .orange:
            self.animationView.indicatorView.color = UIColor.orange
            self.textLabel.textColor = .orange
        }

        self.setupSubViews()
    }

    // 布局子视图
    func setupSubViews() {
        self.addSubview(self.animationView)
        self.addSubview(self.textLabel)

        let metrics = ["imageWidth": imageViewSize.width, "imageHeight": imageViewSize.height]

        switch imageViewPosition {
        case .left?:
            self.textLabel.sizeToFit()
            var width = self.textLabel.frame.size.width
            width = min(width, UIScreen.main.bounds.size.width-100)

            // 设置子视图左右对齐
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(imageInsets.left)-[animationView(==imageWidth)]-\(textInsets.left)-[textLabel(==\(width))]-\(textInsets.right)-|", options: [], metrics: metrics, views: ["animationView": animationView, "textLabel": textLabel]))
            // 设置animationView高
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[animationView(==imageWidth)]", options: [], metrics: metrics, views: ["animationView": animationView]))
            // 设置textLabel顶部、底部对齐
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(textInsets.top)-[textLabel]-\(textInsets.bottom)-|", options: [], metrics: metrics, views: ["textLabel": textLabel]))
            // 设置animationView与textLabel垂直居中对齐
            self.addConstraint(NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: textLabel, attribute: .centerY, multiplier: 1, constant: 0))
        case .top?:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(imageInsets.top)-[animationView(==imageHeight)]-\(textInsets.top)-[textLabel]-\(textInsets.bottom)-|", options: [], metrics: metrics, views: ["animationView": animationView, "textLabel": textLabel]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(textInsets.left)-[textLabel]-\(textInsets.right)-|", options: [], metrics: nil, views: ["textLabel": textLabel]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[animationView(==imageWidth)]", options: [], metrics: metrics, views: ["animationView": animationView]))

            self.addConstraint(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        default:
            break
        }
    }

    // 开始动画
    func startAnimating() {
        self.animationView.startAnimating()
    }

    // 结束动画
    func stopAnimating() {
        self.animationView.stopAnimating()
    }

}
