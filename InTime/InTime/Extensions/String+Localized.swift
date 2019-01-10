//
//  CloudKeeper
//
//  Created by BruceLi on 2018/8/15.
//  Copyright © 2018 BruceLi. All rights reserved.
//

import Foundation

extension NamespaceWrapper where Base == String {

    /// 国际化
    ///
    /// - Parameter key: key
    /// - Returns: 字符串
    static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
