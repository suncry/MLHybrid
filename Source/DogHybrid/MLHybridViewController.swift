//
//  MLHybridViewController.swift
//  MedLinker
//
//  Created by 蔡杨
//  Copyright © 2015年 MedLinker. All rights reserved.
//

import UIKit

enum AnimateType {
    case normal
    case push
    case pop
}

class MLHybridViewController: UIViewController {

    var locationModel = MLHybridLocation()
    var naviBarHidden = false
    var statusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return statusBarStyle
    }
    var URLPath: String?
    var Cookie: String?
    var htmlString: String?

    var onShowCallBack: String?
    var onHideCallBack: String?
    
    fileprivate var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    weak var contentView: MLHybridContentView!
    
    var animateType: AnimateType = .normal

    //MARK: - init
    class func load(urlString: String) -> MLHybridViewController? {
        if let url = URL(string: urlString.hybridUrlPathAllowedString()) {
            let webViewController = MLHybridViewController()
            /*
            if let sess = LoginUserViewModel.shared.loginUser.value?.session {
                webViewController.Cookie = sess
            }*/
            webViewController.hidesBottomBarWhenPushed = true
            if url.scheme == MLHYBRID_SCHEMES {
                let contentResolver = MLHybridTools().contentResolver(urlString: urlString)
                if let topageURL = contentResolver.args["topage"] as? String {
                    webViewController.URLPath = topageURL
                    return webViewController
                }
            } else if url.host != nil {
                webViewController.URLPath = url.absoluteString
                return webViewController
            } else {
//                MLPageUrlParseManager(currentVC: MLHybridTools().currentVC()).handlePageJumpWithUrl(urlString)
            }
        }
        return nil
    }
    
    class func clearCookie (urlString: String) {
        if let url = URL(string: urlString) {
            guard let cookies = HTTPCookieStorage.shared.cookies(for: url) else { return }
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    deinit {
//        Log.debug("===================\n\(String(describing: self.title))   释放\n===================")
        if contentView != nil {
            contentView.load(URLRequest(url: URL(string: "about:blank")!))
            contentView.stopLoading()
            contentView.uiDelegate = nil
            contentView.navigationDelegate = nil
            contentView.removeFromSuperview()
            contentView = nil
        }
        locationModel.stopUpdateLocation()
        
        if let subviews = self.navigationController?.navigationBar.subviews {
            for view in subviews {
                if view is UIButton {
                    //移除旧的按钮
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let callback = self.onShowCallBack {
            MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let callback = self.onHideCallBack {
            let _ =  MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in
                
            })
        }
    }
    
    //MARK: - Method
    func initUI() {
        self.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = naviBarHidden
    }
    
    func initContentView() {
        self.contentView = MLHybridContentView()
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: self.contentView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        self.view.addConstraint(leftConstraint)
        let rightConstraint = NSLayoutConstraint(item: self.contentView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        self.view.addConstraint(rightConstraint)
        let topGuide = self.topLayoutGuide
        let topConstraint = NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: topGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(topConstraint)
        let bottomConstraint = NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(bottomConstraint)
        
        if let htmlString = self.htmlString {
            self.contentView.htmlString = htmlString
        }
        if let path = self.URLPath {
            if let request = self.getRequest(urlString: path) {
                self.contentView.load(request)
            }
        }
    }
    
    func getRequest(urlString: String) -> URLRequest? {
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            if let url = URL(string: urlString) {
                let urlRequest = NSURLRequest(url:url)
                let mutableRequest = urlRequest.mutableCopy() as? NSMutableURLRequest
                if let userCookies =  MLHybridCookies.shared.dataSource?.userCookiesValue!() {
                    let cookieValue = String(format:"platform=%@; sess=%@",userCookies.platform, userCookies.sess)
                    mutableRequest?.addValue(cookieValue, forHTTPHeaderField: "Cookie")
                }
                return  (mutableRequest! as URLRequest)
            }
        }
        return nil
    }
    
}

//MARK: - UINavigationControllerDelegate
extension MLHybridViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            if self.animateType == .pop {
                return HybridTransionPush()
            }
            else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is HybridTransionPush {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }

}
