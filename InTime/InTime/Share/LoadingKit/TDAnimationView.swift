//
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation
import UIKit

public enum AnimationType {
    case normal         // 默认动画
    case group          // 自定义动画
    case gif            // gif动画
}

class TDAnimationView: UIView {

    var animationType: AnimationType = .normal

    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var animationView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var gifView: AImageView = {
        let view = AImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    convenience init(type: AnimationType?,
                     animationGifName: String? = nil,
                     animations: [UIImage]?,
                     imageSize: CGSize,
                     animationDuring: TimeInterval) {

        self.init()
        self.setupAnimations(type: type,
                             animationGifName: animationGifName,
                             animations: animations,
                             size: imageSize,
                             animationDuring: animationDuring)
    }

    //设置动画
    func setupAnimations(type: AnimationType?,
                         animationGifName: String? = nil,
                         animations: [UIImage]?,
                         size: CGSize,
                         animationDuring: TimeInterval) {
        if type != nil {
            self.animationType = type!
        }

        let metrics = ["width": size.width, "height": size.height]

        switch self.animationType {
        case .normal:
            self.addSubview(self.indicatorView)
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[indicatorView(==width)]-0-|", options: [], metrics: metrics, views: ["indicatorView": indicatorView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[indicatorView(==height)]-0-|", options: [], metrics: metrics, views: ["indicatorView": indicatorView]))

        case .group:
            assert(animations != nil, "animations不能为nil")

            self.animationView.animationDuration = TimeInterval(animationDuring)
            self.animationView.animationImages = animations
            self.addSubview(self.animationView)
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[animationView(==width)]-0-|", options: [], metrics: metrics, views: ["animationView": animationView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[animationView(==height)]-0-|", options: [], metrics: metrics, views: ["animationView": animationView]))

        case .gif:
            assert(animationGifName != nil, "animationGifName不能为nil")

            let url = Bundle.main.url(forResource: animationGifName, withExtension: "gif")
            gifView.add(image: AImage(url: url!)!)
            gifView.play = true
            self.addSubview(gifView)
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[gifView(==width)]-0-|", options: [], metrics: metrics, views: ["gifView": gifView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[gifView(==height)]-0-|", options: [], metrics: metrics, views: ["gifView": gifView]))
        }
    }

    func startAnimating() {
        switch self.animationType {
        case .normal:
            self.indicatorView.startAnimating()
        case .group:
            self.animationView.startAnimating()
        case .gif:
            self.gifView.play = true
        }
    }

    func stopAnimating() {
        switch self.animationType {
        case .normal:
            self.indicatorView.stopAnimating()
        case .group:
            self.animationView.stopAnimating()
        case .gif:
            self.gifView.play = false
        }
    }
}
