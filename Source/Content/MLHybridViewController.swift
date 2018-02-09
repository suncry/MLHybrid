//
//  MLHybridViewController.swift
//  MedLinker
//
//  Created by 蔡杨
//  Copyright © 2015年 MedLinker. All rights reserved.
//

import UIKit
import NJKWebViewProgress

class MLHybridViewController: UIViewController {
    
    var locationModel = MLHybridLocation()
    var needSetHeader = true
    var naviBarHidden = false
    var URLPath: URL?
    var html: String?
    var injectedHtml: String?
    var onShowCallBack: String?
    var onHideCallBack: String?
    var contentView: MLHybridContentView!
    var scrollDelegate: UIScrollViewDelegate?
    
    var _webViewProgressView = NJKWebViewProgressView()
    let _webViewProgress = NJKWebViewProgress()
    
    //MARK: - init
    deinit {
        locationModel.stopUpdateLocation()
        if contentView != nil {
            contentView.delegate = nil
            _webViewProgress.webViewProxyDelegate = nil;
            _webViewProgress.progressDelegate = nil;
            _webViewProgressView.removeFromSuperview()
            contentView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
            contentView.stopLoading()
            contentView.removeFromSuperview()
            contentView = nil
        }
        NotificationCenter.default.removeObserver(self)

    }
    
    //MARK: - life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initContentView()
        self.initProgressView()
        NotificationCenter.default.addObserver(self, selector:#selector(playingVideoReload) , name: MLHybridNotification.playingVideoPause, object: nil)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let callback = self.onShowCallBack {
            MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in
            })
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
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
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = naviBarHidden
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.setUpBackButton()
    }
    
    func setUpBackButton() {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 44)
        button.addTarget(self, action: #selector(MLHybridViewController.back), for: .touchUpInside)
        let image = UIImage(named: MLHybrid.shared.backIndicator)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .left
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.setLeftBarButton(item, animated: true)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func playingVideoReload() {
        let playJS = "(document.getElementsByTagName(\"video\")[0]).src"
        if (contentView.stringByEvaluatingJavaScript(from: playJS) ??  "").count > 0 {
            contentView.reload()
        }
    }
    
    func initProgressView() {
        contentView.delegate = _webViewProgress
        _webViewProgress.webViewProxyDelegate = contentView;
        _webViewProgress.progressDelegate = self;
        
        let navBounds = self.navigationController?.navigationBar.bounds
        let barFrame = CGRect(x: 0, y: (navBounds?.size.height ?? 0) - 2, width: navBounds?.size.width ?? 0, height: 2)
        _webViewProgressView = NJKWebViewProgressView(frame: barFrame)
        _webViewProgressView.setProgress(0, animated: true)
        self.navigationController?.navigationBar.addSubview(_webViewProgressView)
    }
    
    func initContentView() {
        contentView = MLHybridContentView()
        contentView.scrollView.delegate = scrollDelegate
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        self.view.addConstraint(leftConstraint)
        let rightConstraint = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        self.view.addConstraint(rightConstraint)
        let topGuide = self.topLayoutGuide
        let topConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: topGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(topConstraint)
        let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(bottomConstraint)
        
        if let injectedHtml = self.injectedHtml {
            self.contentView.injectedHtml = injectedHtml
        }
        if let url = URLPath {
            self.contentView.loadRequest(URLRequest(url: url))
        } else {
            self.contentView.loadHTMLString(self.html ?? "", baseURL: nil)
        }
    }
    
}

extension MLHybridViewController: NJKWebViewProgressDelegate {
    public func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        if progress > 0.7 {
            _webViewProgressView.setProgress(progress, animated: true)
        } else {
            _webViewProgressView.setProgress(0.7, animated: true)
        }
    }
    
    open func setProgress(_ progress: Float) {
        _webViewProgressView.setProgress(progress, animated: true)
    }
    
}

