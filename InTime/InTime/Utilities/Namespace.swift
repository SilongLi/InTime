//
//  CloudKeeper
//
//  Created by BruceLi on 2018/8/15.
//  Copyright © 2018 BruceLi. All rights reserved.
//

import UIKit

public protocol NamespaceWrappable {
    associatedtype WrapperType
    var it: WrapperType { get set }
    static var it: WrapperType.Type { get }
}

public extension NamespaceWrappable {
    var it: NamespaceWrapper<Self> {
        get {
            return NamespaceWrapper(value: self)
        }
        set {}
    }

    static var it: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public struct NamespaceWrapper<Base> {
    public var wrappedValue: Base
    public init(value: Base) {
        self.wrappedValue = value
    }
}

extension UIView: NamespaceWrappable {}
extension String: NamespaceWrappable {}
extension UIViewController: NamespaceWrappable {}
extension Bool: NamespaceWrappable {}
extension NSMutableAttributedString: NamespaceWrappable {}
extension UITapGestureRecognizer: NamespaceWrappable {}
