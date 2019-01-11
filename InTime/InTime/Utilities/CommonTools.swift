//
//  CommonTools.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

class CommonTools {
    public static func printLog<T>(message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
        // 1.获取文件名,包含后缀名
        let name = (file as NSString).lastPathComponent
        // 1.1 切割文件名和后缀名
        let fileArray = name.components(separatedBy: ".")
        // 1.2 获取文件名
        let fileName = fileArray[0]
        // 2.打印内容
        print("[\(fileName) \(funcName)](\(lineNum)): \(message)")
        #endif
    }
}
