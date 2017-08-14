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
    
    var sess: String = "unregistered"
    var platform: String = "unregistered"
    var userAgent: String = "unregistered"
    var scheme: String = "unregistered"

    //注册信息
    //应用启动、登陆、注销 都需要调用
    open class func register(sess: String,
                             platform: String,
                             userAgent: String,
                             scheme: String) {
        shared.sess = sess
        shared.platform = platform
        shared.userAgent = userAgent
        shared.scheme = scheme

    }

    //加载页面
    open class func load(urlString: String) -> MLHybridViewController? {
        
        guard let url = URL(string: urlString.hybridUrlPathAllowedString()) else {return nil}
        let webViewController = MLHybridViewController()
        webViewController.URLPath = url
        return webViewController        
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
