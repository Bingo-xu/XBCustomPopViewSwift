//
//  XBTool.swift
//  XBCustomPopView
//
//  Created by xubin on 2017/12/21.
//  Copyright © 2017年 xubin. All rights reserved.
//

import UIKit
func XBPopView() -> XBShowPopView {
    return XBCustomPopViewTool.sharedInstance.popView
}
class XBCustomPopViewTool: NSObject {
    static let sharedInstance = XBCustomPopViewTool()
    fileprivate override init() {}
    //弹窗根视图
    fileprivate lazy var popView: XBShowPopView = {
        let popView = XBShowPopView()
        return popView
    }()

}

extension NSObject {
    
    /// className
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    /// Identifier
    class var Identifier: String {
        return self.className + "_Identifier"
    }
}
