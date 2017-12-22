//
//  ViewController.swift
//  XBCustomPopView
//
//  Created by xubin on 2017/12/21.
//  Copyright © 2017年 xubin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var popView: XBHomeWarnPopView = {
        let popView = XBHomeWarnPopView()
        return popView
    }()
    lazy var sheetView: XBActionSheetView = {
        let sheetView = XBActionSheetView()
        return sheetView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scaleAction(_ sender: UIButton) {//缩放和frame有冲突
        XBPopView().showWithContentView(XBHomeWarnPopView(), animoteType: .scale, bgEnable: false, action: nil)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        XBPopView().showWithContentView(popView, animoteType: .menu, bgEnable: false, action: nil)
    }
    
    @IBAction func downAction(_ sender: UIButton) {
        XBPopView().showWithContentView(popView, animoteType: .down, bgEnable: false, action: nil)
    }
    
    @IBAction func popAction(_ sender: UIButton) {
        XBPopView().showWithContentView(popView, animoteType: .pop, bgEnable: false, action: nil)
    }
    @IBAction func presentAction(_ sender: UIButton) {
        XBPopView().showWithContentView(popView, animoteType: .present, bgEnable: false, action: nil)
    }
    
    @IBAction func sheetAction(_ sender: UIButton) {
        sheetView.showSheetWith(["1","2","3","4","5"]) { (index) in
            print("\(index)")
        }
    }
    
    @IBAction func topMenuAction(_ sender: UIButton) {
        XBPopView().showWithContentView(popView, animoteType: .topMenu, bgEnable: false, action: nil)
    }
    
}

