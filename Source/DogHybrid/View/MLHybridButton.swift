//
//  MLHybridButton.swift
//  Pods
//
//  Created by yang cai on 2017/8/18.
//
//

import Foundation
import WebKit

class MLHybridButton: UIButton {
    let margin: CGFloat = 13
    var model: Hybrid_naviButtonModel = Hybrid_naviButtonModel()
    var webView: WKWebView = WKWebView()
    
    class func setUp(models: [Hybrid_naviButtonModel], webView: WKWebView) -> [UIBarButtonItem] {
        let models = models.reversed()

        var items: [UIBarButtonItem] = []
        for model in models {
            let button = MLHybridButton()
            button.model = model
            button.webView = webView
            let titleWidth = model.value.hybridStringWidthWith(15, height: 20) + 2*button.margin
            
            let buttonWidth = titleWidth > 42 ? titleWidth : 42

            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 44)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(.black, for: .normal)
//            if model.icon.characters.count > 0 {
////                button.setZYHWebImage(buttonModel.icon as NSString?, defaultImage: "", isCache: true)
//            }
//            else if buttonModel.tagname.characters.count > 0 {
//                print("加载图片 \(NaviImageHeader + buttonModel.tagname)")
//                print(UIImage(named: NaviImageHeader + buttonModel.tagname) ?? "未找到对应图片资源")
//                button.setImage(UIImage(named: NaviImageHeader + buttonModel.tagname), for: .normal)
//                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
//            }
//            if let _ = UIImage(named: NaviImageHeader + buttonModel.tagname) {
//            } else {
//                if buttonModel.value.characters.count > 0 {
//                    button.setTitle(buttonModel.value, for: .normal)
//                }
//            }

            if model.tagname == "back" {
                let image = UIImage(named: MLHybrid.shared.backIndicator)
                button.setImage(image, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            }
            
            if model.value.characters.count > 0 {
                button.setTitle(model.value, for: .normal)
            }

            button.addTarget(button, action: #selector(MLHybridButton.click), for: .touchUpInside)
            items.append(UIBarButtonItem(customView: button))
        }
        return items
    }
    
    
    func click(sender: MLHybridButton) {
        let _ = MLHybridTools().callBack(callback: sender.model.callback, webView: sender.webView) { (str) in
            
        }
        if sender.model.tagname == "back" && sender.model.callback == "" {
            //假死 则执行本地的普通返回事件
            if sender.webView.canGoBack {
                sender.webView.goBack()
            } else {
//                self.back(["":"" as AnyObject], webView: webView)
            }
        } else if sender.model.tagname == "close" {
//            self.back(["":"" as AnyObject], webView: webView)
        }
    }

}
