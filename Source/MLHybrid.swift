//
//  MLHybrid.swift
//  Pods
//
//  Created by yang cai on 2017/8/9.
//
//

import Foundation
import WebKit

public protocol MLHybridMethodProtocol {
    func methodExtension(command: MLHybirdCommand)
}

struct MLHybridNotification {
    static let updateCookie: Notification.Name = Notification.Name(rawValue: "MLHybridUpdateCookie")
}

open class MLHybrid {
    open static let shared = MLHybrid()
    private init() {}
    
    var delegate: MLHybridMethodProtocol?
    static let unregistered = "unregistered"
    var sess: String = unregistered
    var platform: String = unregistered
    var userAgent: String = unregistered
    var scheme: String = unregistered
    var domain: String = unregistered
    var backIndicator: String = unregistered
    
    //注册信息
    //应用启动、登陆、注销 都需要调用
    open class func register(sess: String,
                             platform: String,
                             appName: String,
                             domain: String,
                             backIndicator: String,
                             delegate: MLHybridMethodProtocol) {
        shared.sess = sess
        shared.platform = platform
        shared.domain = domain
        shared.userAgent = "med_hybrid_" + appName + "_"
        shared.scheme = "med" + appName + "hybrid"
        shared.backIndicator = backIndicator
        shared.delegate = delegate
        URLProtocol.registerClass(MLHybridURLProtocol.self)
    }

    //加载页面
    open class func load(urlString: String) -> MLHybridViewController? {
        guard let url = URL(string: urlString.hybridUrlPathAllowedString()) else {return nil}
        let webViewController = MLHybridViewController()
        webViewController.URLPath = url
        return webViewController        
    }

    //更新Cookie
    open class func updateCookie(_ cookie: String) {
        MLHybrid.shared.sess = cookie
        NotificationCenter.default.post(name: MLHybridNotification.updateCookie, object: nil)
    }

    //清理Cookie
    open class func clearCookie (urlString: String) {
        if let url = URL(string: urlString) {
            guard let cookies = HTTPCookieStorage.shared.cookies(for: url) else { return }
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }

    //版本检测并更新
    open class func checkVersion() {
        MLHybridTools().checkVersion()
    }

}
