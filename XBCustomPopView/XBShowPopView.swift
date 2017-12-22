//
//  JNBShowPopView.swift
//  JNBAirCleaner
//
//  Created by 徐斌 on 2017/3/24.
//  Copyright © 2017年 徐斌. All rights reserved.
//

import UIKit

/** 弹出动画效果 **/
enum PopAnimoteType {
    case `default`       //默认
    case menu         //下拉菜单
    case pop          //中间弹出
    case present      //下方弹出
    case down        //从上往下滑落
    case sheet      //下方弹出
    case topMenu     //上方弹出菜单
    case scale     //缩放
}

// MARK: 屏幕宽
let kScreenHeight = UIScreen.main.bounds.size.height
// MARK: 屏幕高
let kScreenWidth = UIScreen.main.bounds.size.width

func applicationKeyWindow() -> UIWindow {
    return UIApplication.shared.keyWindow ?? UIWindow()
}

typealias funcVoidVoidBlock = () -> () //或者 () -> Void

class XBShowPopView: XBView {
    
    var bgView: UIView?
    var popType:PopAnimoteType = .default //弹出形式
    var bgFrame:CGRect = CGRect.zero
    var dissMissAction:funcVoidVoidBlock?
    
    
    lazy var bgColorView: UIView = {
        let bgColorView = UIView()
        bgColorView.alpha = 0.6
        bgColorView.frame = UIScreen.main.bounds
        return bgColorView
    }()
    
    lazy var bgBtn: UIButton = {
        let bgBtn = UIButton()
        bgBtn.frame = UIScreen.main.bounds
        return bgBtn
    }()
    
//    lazy var cancleBtn: UIButton = {
//        let cancleBtn = UIButton()
//        cancleBtn.setImage(UIImage.init(named: "home_cancle"), forState: .Normal)
//        return cancleBtn
//    }()

   override func commonInit() {
        self.backgroundColor = UIColor.clear
        self.addSubview(bgColorView)
        self.addSubview(bgBtn)
        
        bgBtn.addTarget(self, action: #selector(bgBtnViewAction), for: .touchUpInside)
    }
    
    @objc fileprivate func bgBtnViewAction() {
        dismiss()
    }
    
    @objc fileprivate  func cancleBtnAction() {
        dismiss()
    }
    
    fileprivate func showWith(_ enable:Bool)  {
        applicationKeyWindow().addSubview(self)
        setInfoViewFrame(true,enable: enable)
    }

    
    fileprivate  func dissMissAnimote(_ frame:CGRect,disFrame:CGRect,duration:TimeInterval = 0.3){
        UIView.animate(withDuration: duration, delay: 0.0, options: .layoutSubviews, animations: {
            self.bgView?.frame = disFrame
            self.removeFromSuperview()
            self.bgView?.removeFromSuperview()
            }, completion: {(finished) in
                self.bgView?.frame = frame
                self.bgView = nil
                if self.dissMissAction != nil {
                    self.dissMissAction!()
                }
        })
    }
    //隐藏
   open  func dismiss(){
        setInfoViewFrame(false)
    }
    //显示
   open func showWithContentView(_ contentView:UIView,animoteType:PopAnimoteType,bgEnable:Bool = true, action:funcVoidVoidBlock?){
        dissMissAction = nil
        bgBtn.isEnabled = false
        popType = animoteType
        if popType == PopAnimoteType.menu || popType == PopAnimoteType.topMenu{
            bgColorView.backgroundColor = UIColor.clear
        }else{
            bgColorView.backgroundColor = UIColor.black
        }
        bgView = contentView
        self.addSubview(bgView!)
        bgFrame = bgView!.frame
        if action != nil {
            dissMissAction = action
        }
        showWith(bgEnable)
    }

}

//MARK:动画类型
extension XBShowPopView{
    fileprivate func setInfoViewFrame(_ isShow:Bool,enable:Bool = false) {
        let frame = bgFrame
        switch popType {
        case .present:
            if isShow {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y - 35, width: frame.size.width, height: frame.size.height+25)
                    }, completion: { (finished) in
                        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: {
                            self.bgView?.frame = frame
                            self.bgBtn.isEnabled = enable
                            }, completion: nil)
                })
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y - 40, width: frame.size.width, height: frame.size.height+30)
                    }, completion: { (finished) in
                        self.dissMissAnimote(frame,disFrame: CGRect(x: frame.origin.x, y: kScreenHeight, width: frame.size.width, height: frame.size.height))
                })
            }
            break
        case .menu:
            if isShow {
                self.bgView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 0)
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = frame
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 10)
                    }, completion: { (finished) in
                        self.dissMissAnimote(frame,disFrame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 10))})
            }
            break
        case .pop:
            if isShow {
                self.bringSubview(toFront: bgBtn)
                self.bgView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion:nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    }, completion: { (finished) in
                        self.removeFromSuperview()
                        self.bgView?.removeFromSuperview()
                        self.bgView = nil
                        if self.dissMissAction != nil {
                            self.dissMissAction!()
                        }
                })
            }
            break
        case .down:
            if isShow {
                self.bgView?.frame = CGRect(x: frame.origin.x, y: -(frame.size.height), width: frame.size.width, height: frame.size.height)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = frame
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion:nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = CGRect(x: frame.origin.x, y: kScreenHeight, width: frame.size.width, height: frame.size.height)
                    }, completion: { (finished) in
                        self.removeFromSuperview()
                        self.bgView!.removeFromSuperview()
                        self.bgView?.frame = frame
                        self.bgView = nil
                        if self.dissMissAction != nil {
                            self.dissMissAction!()
                        }
                })
            }
            break
        case .sheet:
            if isShow {
                self.bgView?.frame = CGRect(x: frame.origin.x,y: kScreenHeight, width: frame.size.width, height: frame.size.height)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = frame
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion:nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = CGRect(x: frame.origin.x,y: kScreenHeight, width: frame.size.width, height: frame.size.height)
                    }, completion: { (finished) in
                        self.removeFromSuperview()
                        self.bgView!.removeFromSuperview()
                        self.bgView?.frame = frame
                        self.bgView = nil
                        if self.dissMissAction != nil {
                            self.dissMissAction!()
                        }
                })
            }
            break
        case .topMenu:
            if isShow {
                self.bgView?.frame = CGRect(x: frame.origin.x,y: frame.origin.y + frame.size.height, width: frame.size.width, height: 0)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = frame
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion:nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.frame = CGRect(x: frame.origin.x,y: frame.origin.y + frame.size.height, width: frame.size.width, height: 0)
                    }, completion: { (finished) in
                        self.removeFromSuperview()
                        self.bgView?.removeFromSuperview()
                        self.bgView?.frame = frame
                        self.bgView = nil
                        if self.dissMissAction != nil {
                            self.dissMissAction!()
                        }
                })
            }
            break
            
        case .scale:
            if isShow {
                self.bgView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion:nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                    self.bgView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    }, completion: { (finished) in
                        self.removeFromSuperview()
                        self.bgView?.removeFromSuperview()
                        if self.dissMissAction != nil {
                            self.dissMissAction!()
                        }
                })
            }
            break
            
        default:
            if isShow {
                self.alpha = 0
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .layoutSubviews, animations: {
                    self.alpha = 1
                    GCD.afterMainQueue(0.2, block: {[weak self]  in
                        guard let `self` = self else {
                            return
                        }
                        self.bgBtn.isEnabled = enable
                    })
                    }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0
                    }, completion: { (finish) in
                        self.removeFromSuperview()
                        self.bgView?.removeFromSuperview()
                        self.bgView = nil
                        self.alpha = 1
                        if self.dissMissAction != nil {
                            self.dissMissAction!()
                        }
                })
            }
            break
        }
    }

}
