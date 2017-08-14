
//
//  MLHybridWebView.swift
//  MedLinker
//
//  Created by 蔡杨
//  Copyright © 2015年 MedLinker. All rights reserved.
//

import UIKit
import CoreMotion
import JavaScriptCore
import WebKit

class MLHybridContentView: WKWebView {
    static var sharedKPreferences = WKPreferences()
    static var sharedProcessPool = WKProcessPool()

    
    var tool: MLHybridTools = MLHybridTools()

//    let USER_AGENT_HEADER = "med_hybrid_mecrm_"
    var htmlString: String?
    
    public convenience init(frame: CGRect) {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = MLHybridContentView.sharedKPreferences
        configuration.preferences.minimumFontSize = 10;
        // 默认认为YES
        configuration.preferences.javaScriptEnabled = true;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false;
        configuration.processPool = MLHybridContentView.sharedProcessPool

        let  userContentController = WKUserContentController()
//        if let user =  MLHybridCookies.shared.dataSource?.userCookiesValue!() {
//            let cookieValue = String(format:"document.cookie ='platform=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2019 23:38:25 GMT；';document.cookie = 'sess=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2019 23:38:25 GMT；';",user.platform,user.sess)
//            let  cookieScript = WKUserScript(source: cookieValue, injectionTime: .atDocumentStart , forMainFrameOnly: false)
//            userContentController.addUserScript(cookieScript)
//        }
        let cookieValue = String(format:"document.cookie ='platform=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2019 23:38:25 GMT；';document.cookie = 'sess=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2019 23:38:25 GMT；';", MLHybrid.shared.platform, MLHybrid.shared.sess)
        let  cookieScript = WKUserScript(source: cookieValue, injectionTime: .atDocumentStart , forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)

        configuration.userContentController = userContentController
        self.init(frame: frame, configuration: configuration)
    }
    
    private override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame:frame,configuration:configuration)
        self.configUserAgent()
        self.initUI()
        self.uiDelegate = self
        self.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func initUI () {
        self.backgroundColor = UIColor.white
        self.uiDelegate = self
        self.navigationDelegate = self
        self.scrollView.bounces = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //设置userAgent
    func configUserAgent () {
        var userAgentStr: String = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        if (userAgentStr.range(of: MLHybrid.shared.userAgent) == nil) {
            guard let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {return}
            userAgentStr.append(" \(MLHybrid.shared.userAgent)\(versionStr) ")
            UserDefaults.standard.register(defaults: ["UserAgent" : userAgentStr])
        }
    }

}

extension MLHybridContentView: WKUIDelegate,WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /*
        if self.scrollView.mj_header != nil {
            self.scrollView.mj_header?.endRefreshing()
        }
        */
        /* if let title = webView.stringByEvaluatingJavaScript(from: "document.title"), title.characters.count > 0 {
         self.tool.viewControllerOf(webView).title = self.title
         }*/
            self.tool.viewControllerOf(webView).title = webView.title
        
        
        if let htmlString = self.htmlString {
            webView.evaluateJavaScript("document.body.innerHTML = document.body.innerHTML + '\(htmlString)'", completionHandler: { (any, error) in
            })
            self.htmlString = nil
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        var policy =  WKNavigationActionPolicy.allow
      //  let url = navigationAction.request.url
        if policy == WKNavigationActionPolicy.allow,(navigationAction.request.url?.absoluteString.hasPrefix("\(MLHYBRID_SCHEMES)://"))!{
            self.tool.analysis(urlString: navigationAction.request.url?.absoluteString, webView: webView)
            policy =  WKNavigationActionPolicy.cancel
        }
        
        decisionHandler(policy)
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        webView.reload()
    }
   /*
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.scrollView.mj_header != nil {
            self.scrollView.mj_header?.endRefreshing()
        }
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"), title.characters.count > 0 {
            self.tool.viewControllerOf(webView).title = title
        }
        if let htmlString = self.htmlString {
            webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML = document.body.innerHTML + '\(htmlString)'")
            self.htmlString = nil
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url!.absoluteString.hasPrefix("\(MLHYBRID_SCHEMES)://") {
            self.tool.analysis(urlString: request.url?.absoluteString, webView: webView)
            return false
        }
        return true
    }
 */
    
}




