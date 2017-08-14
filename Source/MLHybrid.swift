//
//  MLHybrid.swift
//  Pods
//
//  Created by yang cai on 2017/8/9.
//
//

import Foundation
import WebKit

open class MLHybrid {
    open static let shared = MLHybrid()
    private init() {}
    
    var sess: String = "nil"
    var platform: String = "nil"
    var userAgent: String = "nil"


    //初始化
    open class func register(sess: String, platform: String, userAgent: String) {
        shared.sess = sess
        shared.platform = platform
        shared.userAgent = userAgent
        
        

    }

    //加载页面
    open class func load(urlString: String) -> MLHybridViewController? {
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

    
    //清理Cookie
    open func clearCookie (urlString: String) {
        if #available(iOS 9.0, *) {
            WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970:0), completionHandler: {})
        } else {
            if let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first{
                try? FileManager.default.removeItem(atPath: libraryPath)
            }
        }
    }
    
}
