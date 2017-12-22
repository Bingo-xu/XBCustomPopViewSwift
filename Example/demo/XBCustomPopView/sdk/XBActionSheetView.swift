//
//  XBActionSheetView.swift
//  JNBAirCleaner
//
//  Created by 徐斌 on 2017/4/13.
//  Copyright © 2017年 徐斌. All rights reserved.
//

import UIKit

//MARK: 随机颜色
func XBHexColor(_ hexString: String)  -> UIColor{
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
        (a, r, g, b) = (1, 1, 1, 0)
    }
    return UIColor.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
}

func kiOS(_ verson:Float) -> Bool {
    let os = ProcessInfo().operatingSystemVersion
    /**
     os.majorVersion, os.minorVersion, os.patchVersion
     对应版本号三个数
     UIDevice().systemVersion,字符串
     **/
    return  Float(os.majorVersion) + Float(os.minorVersion)/10 >= verson ? true :false
}

//MARK: 字体大小
func XBBoldFont(_ size:CGFloat) -> UIFont {
    if kiOS(9) {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    return UIFont.systemFont(ofSize: size)

}

class XBActionSheetTableViewCell: UITableViewCell {
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = XBHexColor("#dbdbdb")
        return lineView
    }()
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.textColor = XBHexColor("#333333")
        contentLabel.font = XBBoldFont(18)
        contentLabel.textAlignment = .center
        return contentLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // Class 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    func commonInit() {
        contentView.addSubview(contentLabel)
        
    }
}

 class XBActionSheetView: XBView {
    fileprivate var dissMissAction:funcVoidVoidBlock?
    fileprivate var selectAction:funcIntVoidBlock?
    fileprivate var contentColorArr:[UIColor]?
    fileprivate var titleArr:[String] = []
    fileprivate var isMiss:Bool = true
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    fileprivate lazy var cancleBtn: UIButton = {
        let cancleBtn = UIButton()
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.titleLabel?.font = XBBoldFont(18)
        cancleBtn.addTarget(self, action: #selector(cancleBtnAction), for: .touchUpInside)
        cancleBtn.backgroundColor = UIColor.white
        return cancleBtn
    }()

    override func commonInit() {
        self.backgroundColor = UIColor.white
        self.addSubview(tableView)
        self.addSubview(cancleBtn)
    }
    
   open func showSheetWith(_ itemArr:[String],colorArr:[UIColor] = [],cancleColor:UIColor = XBHexColor("#0060ff"),selct:@escaping funcIntVoidBlock) {
        self.isMiss = true
        selectAction = nil
        selectAction = selct
        contentColorArr = colorArr
        cancleBtn.setTitleColor(cancleColor, for: .normal)
        titleArr = itemArr
        var offset:CGFloat = 10
        if itemArr.count == 1 {
            offset = 0
        }
        let height:CGFloat = offset + CGFloat(itemArr.count + 1) * 44
        self.frame = CGRect(x: 0, y: kScreenHeight - height , width: kScreenWidth, height: height)
        tableView.frame = CGRect(x: 0, y: 0 , width: kScreenWidth, height: height - 44 - offset)
        cancleBtn.frame = CGRect(x: 0, y: height - 44, width: kScreenWidth, height: 44)
        XBPopView().showWithContentView(self, animoteType: .sheet, bgEnable: false, action: nil)
        tableView.reloadData()
    }
    
//    func showSheetCancleWith(_ itemArr:[String],view:UIView,isMiss:Bool=true,selct:@escaping funcIntVoidBlock,cancle:funcVoidVoidBlock? = nil) {
//        self.isMiss = isMiss
//        selectAction = nil
//        selectAction = selct
//        dissMissAction = nil
//        dissMissAction = cancle
//        contentColorArr = []
//        cancleBtn.setTitleColor(JNBBlueFontColor, for: .normal)
//        titleArr = itemArr
//
//        let height:CGFloat =  CGFloat(itemArr.count + 1) * 44
//        let frame = CGRect(x: 0, y: kScreenHeight - height , width: kScreenWidth, height: height)
//        tableView.reloadData()
//        view.addSubview(self)
//        show(frame)
//    }
    
    
    
    @objc fileprivate func cancleBtnAction() {
        if isMiss == true {
            XBPopView().dismiss()
        }else{
            dissMiss()
            if dissMissAction != nil {
                dissMissAction!()
            }
        }
    }
    
    fileprivate func show(_ frame:CGRect) {
        self.frame = CGRect(x: frame.origin.x,y: kScreenHeight, width: frame.size.width, height: frame.size.height)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
            self.frame = frame
            }, completion:nil)
    }
    
    func dissMiss() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
            self.frame = CGRect(x: self.frame.origin.x,y: kScreenHeight, width: self.frame.size.width, height: self.frame.size.height)
            }, completion: { (finished) in
                self.removeFromSuperview()
        })
    }
   
}

extension XBActionSheetView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:XBActionSheetTableViewCell? = tableView.dequeueReusableCell(withIdentifier: XBActionSheetTableViewCell.Identifier) as? XBActionSheetTableViewCell
        if (cell == nil) {
            cell = XBActionSheetTableViewCell.init(style:.default, reuseIdentifier: XBActionSheetTableViewCell.Identifier)
        }
        
        if contentColorArr!.count > 0 {
            let color = contentColorArr![indexPath.row]
            cell!.contentLabel.textColor = color
        }else{
            cell!.contentLabel.textColor = XBHexColor("#333333")
        }
        
        cell!.contentLabel.text = titleArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMiss == true {
            XBPopView().dismiss()
        }
        selectAction!(indexPath.row)
    }
}
