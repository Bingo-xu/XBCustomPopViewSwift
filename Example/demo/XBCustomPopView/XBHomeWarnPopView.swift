//
//  JNBHomeWarnPopView.swift
//  JNBStarSmart
//
//  Created by xubin on 2017/12/14.
//  Copyright © 2017年 xubin. All rights reserved.
//

import UIKit

//MARK: 颜色默认透明度
func JNBRGB(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

func JNBMediumFont(_ size:CGFloat) -> UIFont {
    if kiOS(9) {
        return UIFont.init(name: "PingFangSC-Medium", size: size)!
    }
    return UIFont.systemFont(ofSize: size)
}



class XBHomeWarnPopView: XBView ,UITableViewDelegate,UITableViewDataSource{
    
    var titleArr:[String] = ["故障原因：面盖保护异常","故障原因：光照传感器异常","故障原因：温湿度传感器异常","故障原因：涡轮风机异常"]
    var contentArr:[String] = ["解决办法：建议用户检测面盖是否准确关闭","解决办法：建议用户重启净化器","解决办法：建议用户重启净化器","解决办法：建议用户重启净化器"]
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = JNBRGB(49,49, 49)
        titleLabel.font = JNBMediumFont(18)
        titleLabel.text = "安全警报"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var markLabel: UILabel = {
        let markLabel = UILabel()
        markLabel.textColor = JNBRGB(102, 102, 102)
        markLabel.font = XBBoldFont(13)
        markLabel.text = "若扔出现故障，请联系星智能客服电话："
        return markLabel
    }()
    
    lazy var phoneBtn: UIButton = {
        let phoneBtn = UIButton()
        phoneBtn.setTitle("0755-28895320", for: .normal)
        phoneBtn.setTitleColor(JNBRGB(26,133,255), for: .normal)
        phoneBtn.titleLabel?.font = JNBMediumFont(18)
        return phoneBtn
    }()
    
    lazy var cancleBtn: UIButton = {
        let cancleBtn = UIButton()
        cancleBtn.setImage(UIImage.init(named: "me_cancle"), for: .normal)
        return cancleBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        return tableView
    }()
    
    override func commonInit() {
        super.commonInit()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.frame = CGRect.init(x: 30, y: (kScreenHeight - 360)/2, width: kScreenWidth - 60, height: 360)
        self.addSubview(titleLabel)
        self.addSubview(cancleBtn)
        self.addSubview(tableView)
        self.addSubview(phoneBtn)
        self.addSubview(markLabel)
        let line = UIView()
        line.backgroundColor = XBHexColor("#dbdbdb")
        self.addSubview(line)
        titleLabel.frame = CGRect.init(x: 0, y: 25, width: kScreenWidth - 60, height: 25)
        
        cancleBtn.frame = CGRect.init(x: kScreenWidth - 100, y: 17, width: 40, height: 40)
        phoneBtn.frame = CGRect.init(x: kScreenWidth/2 - 120, y: 315, width: 180, height: 40)
        line.frame = CGRect.init(x: 0, y: 310, width: kScreenWidth - 60, height: 0.5)
        markLabel.frame = CGRect.init(x: 20, y: 280, width: kScreenWidth - 100, height: 20)
        tableView.frame = CGRect.init(x: 20, y: 70, width: kScreenWidth - 100, height: 200)
        
        
        phoneBtn.addTarget(self, action: #selector(callPhone), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
    }
    
    @objc func cancleAction()  {
        XBPopView().dismiss()
    }
    
    @objc func callPhone()  {
        XBPopView().dismiss()
        applicationOpenURL(URL.init(string: "tel:0755-28895320")!)
        
    }
    
    func applicationOpenURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            NSLog("%@", "打开失败")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:JNBHomeWarnPopTableViewCell? = tableView.dequeueReusableCell(withIdentifier: JNBHomeWarnPopTableViewCell.Identifier) as? JNBHomeWarnPopTableViewCell
        if (cell == nil) {
            cell = JNBHomeWarnPopTableViewCell.init(style:.default, reuseIdentifier: JNBHomeWarnPopTableViewCell.Identifier)
        }
        //刷新
        cell!.questionLabel.text = "\(indexPath.row + 1)." + titleArr[indexPath.row]
        cell!.solveLabel.text = contentArr[indexPath.row]

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
}


class JNBHomeWarnPopTableViewCell: UITableViewCell {
    lazy var solveLabel: UILabel = {
        let solveLabel = UILabel()
        solveLabel.textColor = JNBRGB(102, 102, 102)
        solveLabel.font = XBBoldFont(13)
        return solveLabel
    }()
    
    lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.textColor = JNBRGB(76, 76, 76)
        questionLabel.font = JNBMediumFont(15)
        return questionLabel
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
        selectionStyle = .none
        self.addSubview(solveLabel)
        self.addSubview(questionLabel)
        questionLabel.frame = CGRect.init(x: 0, y: 3, width: kScreenWidth - 60, height: 20)
        solveLabel.frame = CGRect.init(x: 0, y: 27, width: kScreenWidth - 60, height: 20)
        
    }
}

