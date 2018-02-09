//
//  HybridNaviTitleView.swift
//  Hybrid_Medlinker
//
//  Created by caiyang on 16/5/13.
//  Copyright © 2016年 caiyang. All rights reserved.
//

import UIKit
import Kingfisher

class HybridNaviTitleView: UIView {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let lefticon = UIImageView()
    let righticon = UIImageView()
    let callBackButton = UIButton()
    var command: MLHybirdCommand?
    
    class func load(command: MLHybirdCommand) -> HybridNaviTitleView {
        
        //标题
        let titleModel = command.args.header.title
        let naviTitleView = HybridNaviTitleView()
        naviTitleView.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        
        naviTitleView.command = command
        naviTitleView.titleLabel.text = titleModel.title
        naviTitleView.titleLabel.font = UIFont.systemFont(ofSize: 18)
        naviTitleView.titleLabel.textColor = UIColor(red: 69/255.0, green: 69/255.0, blue: 83/255.0, alpha: 1)
        var titleWidth = titleModel.title.hybridStringWidthWith(18, height: 22)
        titleWidth = titleWidth > 150 ? 150 : titleWidth
        naviTitleView.titleLabel.frame = CGRect(x: 0, y: 0, width: titleWidth, height: 22)
        naviTitleView.titleLabel.center = naviTitleView.center
        naviTitleView.titleLabel.textAlignment = .center
        naviTitleView.addSubview(naviTitleView.titleLabel)
        
        let subtitle = titleModel.subtitle
        //副标题
        if subtitle.characters.count > 0 {
            naviTitleView.subtitleLabel.text = subtitle
            naviTitleView.subtitleLabel.font = UIFont.systemFont(ofSize: 13)
            let subtitleWidth = subtitle.hybridStringWidthWith(13, height: 15)
            naviTitleView.subtitleLabel.frame = CGRect(x: 0, y: 0, width: subtitleWidth, height: 22)
            naviTitleView.subtitleLabel.center = naviTitleView.center
            naviTitleView.subtitleLabel.center.y = naviTitleView.center.y + 10
            naviTitleView.titleLabel.center.y = naviTitleView.center.y - 10
            naviTitleView.subtitleLabel.textAlignment = .center
            naviTitleView.addSubview(naviTitleView.subtitleLabel)
        }
        
        //右图标
        naviTitleView.righticon.frame = CGRect(x: naviTitleView.titleLabel.frame.origin.x + naviTitleView.titleLabel.frame.size.width + 15, y: 0, width: 24, height: 24)
        if let righticonUrl = URL(string: titleModel.righticon), righticonUrl.absoluteString.characters.count > 0 {
            naviTitleView.righticon.kf.setImage(with: righticonUrl)
        }
        naviTitleView.righticon.center.y = naviTitleView.center.y
        naviTitleView.righticon.layer.cornerRadius = 12
        naviTitleView.righticon.layer.masksToBounds = true
        naviTitleView.addSubview(naviTitleView.righticon)
        
        //左图标
        naviTitleView.lefticon.frame = CGRect(x: naviTitleView.titleLabel.frame.origin.x - 30, y: 0, width: 24, height: 24)
        if let lefticonUrl = URL(string: titleModel.lefticon), lefticonUrl.absoluteString.characters.count > 0 {
            naviTitleView.lefticon.kf.setImage(with: lefticonUrl)
        }
        naviTitleView.lefticon.center.y = naviTitleView.center.y
        naviTitleView.lefticon.layer.cornerRadius = 12
        naviTitleView.lefticon.layer.masksToBounds = true
        naviTitleView.addSubview(naviTitleView.lefticon)
        //事件按钮
        naviTitleView.callBackButton.frame = naviTitleView.frame
        naviTitleView.callBackButton.backgroundColor = UIColor.clear
        
        naviTitleView.callBackButton.addTarget(naviTitleView, action: #selector(HybridNaviTitleView.titleClick), for: .touchUpInside)
        naviTitleView.addSubview(naviTitleView.callBackButton)
        return naviTitleView
    }
    
    @objc func titleClick() {
        guard let callback = self.command?.args.header.title.callback else { return }
        let data = ["data": "",
                    "errno": 0,
                    "msg": "",
                    "callback": callback] as [String : Any]
        let dataString = data.hybridJSONString()
        if let callbackWeb = self.command?.webView {
            callbackWeb.stringByEvaluatingJavaScript(from: HybridEvent + "(\(dataString));")
        }
    }
    
}

