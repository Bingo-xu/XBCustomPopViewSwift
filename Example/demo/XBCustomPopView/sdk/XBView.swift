//
//  JNBView.swift
//  JNBAirCleaner
//
//  Created by 徐斌 on 2017/3/14.
//  Copyright © 2017年 徐斌. All rights reserved.
//

import UIKit

class XBView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.white
    }
    
}
