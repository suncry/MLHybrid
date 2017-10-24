//
//  MLOpenWebViewController.swift
//  MLHybrid
//
//  Created by yang cai on 2017/10/18.
//

import UIKit
import NJKWebViewProgress

//private class MLOpenWebViewController: UIViewController, UIWebViewDelegate, NJKWebViewProgressDelegate {
//    let webview = UIWebView()
//    var _webViewProgressView = NJKWebViewProgressView()
//    let _webViewProgress = NJKWebViewProgress()
//    let tool: MLHybridTools = MLHybridTools()
//
//    class func loadURL(url: String) -> MLOpenWebViewController? {
//        let vc = MLOpenWebViewController()
//        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        if let url = URL(string: escapedAddress ) {
//            vc.webview.loadRequest(URLRequest(url: url))
//            vc.hidesBottomBarWhenPushed = true
//            return vc
//        }
//        return nil
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        webview.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 64)
//        self.view.addSubview(webview)
//
//        webview.delegate = _webViewProgress
//        _webViewProgress.webViewProxyDelegate = self;
//        _webViewProgress.progressDelegate = self;
//
//        let navBounds = self.navigationController?.navigationBar.bounds
//        let barFrame = CGRect(x: 0, y: (navBounds?.size.height ?? 0) - 2, width: navBounds?.size.width ?? 0, height: 2)
//        _webViewProgressView = NJKWebViewProgressView(frame: barFrame)
//        _webViewProgressView.setProgress(0, animated: true)
//        self.navigationController?.navigationBar.addSubview(_webViewProgressView)
//
//        let navigationItem = MLHybridTools().viewControllerOf(webview).navigationItem
//        let closeDic = ["tagname": "back"]
//        let closeDic2 = ["tagname": "close",
//                         "value": "关闭"]
//        let buttonArray = [Hybrid_naviButtonModel.yy_model(withJSON: closeDic2)!,Hybrid_naviButtonModel.yy_model(withJSON: closeDic)!]
//        MLHybridTools().setLeftButtons(buttonArray, navigationItem: navigationItem, webView: webview)
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        if let title = webView.stringByEvaluatingJavaScript(from: "document.title") {
//            self.title = title
//        }
//    }
//
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if request.url!.absoluteString.hasPrefix("\(MLHYBRID_SCHEMES)://") {
//            self.tool.analysis(urlString: request.url?.absoluteString, webView: webView)
//        }
//        return true
//    }
//
//    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
//        if progress > 0.7 && progress > _webViewProgressView.progress {
//            _webViewProgressView.setProgress(progress, animated: true)
//        } else if 0.7 > _webViewProgressView.progress {
//            _webViewProgressView.setProgress(0.7, animated: true)
//        }
//    }
//}

