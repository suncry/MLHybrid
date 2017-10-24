//
//  MLHybridButton.swift
//  Pods
//
//  Created by yang cai on 2017/8/18.
//
//

import Foundation

class MLHybridButton: UIButton {
    let margin: CGFloat = 13
    var model: Hybrid_naviButtonModel = Hybrid_naviButtonModel()
    var webView: UIWebView = UIWebView()
    
    class func setUp(models: [Hybrid_naviButtonModel], webView: UIWebView) -> [UIBarButtonItem] {
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
            if model.icon.characters.count > 0 {
                button.kf.setImage(with: URL(string: model.icon), for: .normal)
            }
            else if model.tagname.characters.count > 0 {
                print("加载图片 \(NaviImageHeader + model.tagname)")
                print(UIImage(named: NaviImageHeader + model.tagname) ?? "未找到对应图片资源")
                button.setImage(UIImage(named: NaviImageHeader + model.tagname), for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
            }
            if let _ = UIImage(named: NaviImageHeader + model.tagname) {
            } else {
                if model.value.characters.count > 0 {
                    button.setTitle(model.value, for: .normal)
                }
            }

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
    
    
    @objc func click(sender: MLHybridButton) {
        if sender.model.callback.characters.count == 0 {
            var nextResponder = sender.webView.next
            while !(nextResponder is MLHybridViewController) {
                nextResponder = nextResponder?.next ?? MLHybridViewController()
            }
            let vc = nextResponder as? MLHybridViewController
            if let _ = vc?.presentingViewController {
                vc?.dismiss(animated: true, completion: nil)
            } else {
                vc?.navigationController?.popViewController(animated: true)
            }
        }
        let _ = MLHybridTools().callBack(callback: sender.model.callback, webView: sender.webView) { (str) in }
    }

}
