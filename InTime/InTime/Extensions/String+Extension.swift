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
    
    /// 通过逗号分隔格式化的数据
    ///
    /// - Returns: 格式化数据,生成带逗号的数据,返回整数
    public func stringSeparateByCommaInteger() -> String {
        if Double(wrappedValue) != nil {
            var newLong: Int64 = Int64(Double(wrappedValue)! * 1000)
            
            if newLong % 10 > 4 {
                newLong += 10
            }
            
            newLong -= newLong % 10
            let rev2: Double = Double(newLong) * 1.0 / 1000.0
            let numberFormatter = NumberFormatter()
            numberFormatter.positiveFormat = "###,##0;"
            let formattedNumberString = numberFormatter.string(for: rev2)
            return formattedNumberString ?? ""
        }
        return ""
    }
}
