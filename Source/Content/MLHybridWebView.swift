//
//  MLHybridWebView.swift
//  Kingfisher
//
//  Created by liushuoyu on 2017/12/21.
//

import UIKit
import WebKit

class LocalstorageManger {
    static var sharePreferences = WKPreferences()
    static var shareProcessPool = WKProcessPool()
}



protocol MLHybridWebViewDelegate {
    
    func webView(_ webView: MLHybridWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    
    func webViewDidStartLoad(_ webView: MLHybridWebView)
    
    func webViewDidFinishLoad(_ webView: MLHybridWebView)
    
    func webView(_ webView: MLHybridWebView, didFailLoadWithError error: Error)
    
}

class MLHybridWebView: UIView {
   
    var isUseWKWebVIew = false
    var wkrequest: URLRequest?
    var delegate: MLHybridWebViewDelegate? {
        didSet {
            if let wkWebview = hybridWebView as? WKWebView {
                wkWebview.uiDelegate = self
                wkWebview.navigationDelegate = self
            }
            
            if let uiWebview = hybridWebView as? UIWebView {
                uiWebview.delegate = self
            }
        }
    }
    
    var request: URLRequest?{
        return isUseWKWebVIew ?  wkrequest : uiWekView.request
    }
    
    var scrollView :UIScrollView {
        get {
            return isUseWKWebVIew ? wkWekView.scrollView : uiWekView.scrollView
        }
    }
    
    var canGoBack: Bool {
        get {
            return isUseWKWebVIew ? wkWekView.canGoBack : uiWekView.canGoBack
        }
    }
    
    var canGoForward: Bool {
        get {
            return isUseWKWebVIew ? wkWekView.canGoForward : uiWekView.canGoForward
        }
    }

    lazy var wkWekView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()

        configuration.preferences = LocalstorageManger.sharePreferences
        configuration.processPool = LocalstorageManger.shareProcessPool
        configuration.userContentController = userContentController
    
        let cookieValue = String(format:"document.cookie ='platform=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2019 23:38:25 GMT；';document.cookie = 'sess=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2018 23:38:25 GMT；';",MLHybrid.shared.platform,MLHybrid.shared.sess)
        let cookieScript = WKUserScript(source: cookieValue, injectionTime: .atDocumentStart , forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)
        configuration.userContentController = userContentController
        
        let  webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    lazy var uiWekView: UIWebView = {
       return UIWebView()
    }()
    
    var hybridWebView: UIView {
        get {
            return isUseWKWebVIew ? wkWekView : uiWekView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadRequest(_ request: URLRequest) {
        
        if let wkWebview = hybridWebView as? WKWebView {
            wkWebview.load(request)
        }
        
        if let uiWebview = hybridWebView as? UIWebView {
            uiWebview.loadRequest(request)
        }
    }
    
    func loadHTMLString(_ string: String, baseURL: URL?) {
        
        if let wkWebview = hybridWebView as? WKWebView {
            wkWebview.loadHTMLString(string, baseURL: baseURL)
        }
        
        if let uiWebview = hybridWebView as? UIWebView {
            uiWebview.loadHTMLString(string, baseURL: baseURL)
        }
    }
    
    func reload() {
        
        if let wkWebview = hybridWebView as? WKWebView {
            wkWebview.reload()
        }
        
        if let uiWebview = hybridWebView as? UIWebView {
            uiWebview.reload()
        }
    }
    
    open func stopLoading() {
        
        if let wkWebview = hybridWebView as? WKWebView {
            wkWebview.stopLoading()
        }
        
        if let uiWebview = hybridWebView as? UIWebView {
            uiWebview.stopLoading()
        }
    }
    
    
    open func goBack() {
        
        if let wkWebview = hybridWebView as? WKWebView {
            wkWebview.goBack()
        }
        
        if let uiWebview = hybridWebView as? UIWebView {
            uiWebview.goBack()
        }
    }
    
    open func goForward() {
        
        if let wkWebview = hybridWebView as? WKWebView {
            wkWebview.goForward()
        }
        
        if let uiWebview = hybridWebView as? UIWebView {
            uiWebview.goForward()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension MLHybridWebView: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return delegate?.webView(self, shouldStartLoadWith: request, navigationType: navigationType) ?? false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        delegate?.webViewDidStartLoad(self)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        delegate?.webViewDidFinishLoad(self)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        delegate?.webView(self, didFailLoadWithError: error)
    }
}

extension MLHybridWebView: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        let navigationType = navigationAction.navigationType.rawValue
        let isRequest =  delegate?.webView(self, shouldStartLoadWith: navigationAction.request, navigationType: UIWebViewNavigationType(rawValue:navigationType)!) ?? true
        if isRequest {
            wkrequest = navigationAction.request
            if  navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            decisionHandler(.allow)
        }else {
            decisionHandler(.cancel)
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webViewDidStartLoad(self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.webViewDidFinishLoad(self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.webView(self, didFailLoadWithError: error)
    }
}



