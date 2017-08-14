//
//  MLHybridCookies.swift
//  MECRM
//
//  Created by liushuoyu on 2017/8/5.
//  Copyright © 2017年 medlinker. All rights reserved.
//

import Foundation
import WebKit

@objc protocol MLUserCookiesDataSource:NSObjectProtocol{
    @objc optional func userCookiesValue()->MLUserCookies
}

class MLUserCookies:NSObject{
    var sess:String = ""
    var platform:String = ""
    init (sess:String,platform:String){
        self.sess = sess
        self.platform = platform
    }
}

class MLHybridCookies:NSObject {
    static let shared = MLHybridCookies()
    weak var  dataSource:MLUserCookiesDataSource?
    class func clearHybridCookies() {
        if #available(iOS 9.0, *) {
//            let  websiteDataTypes = [NSSet set]
            WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970:0), completionHandler: {
                
            })
        } else {
            // Fallback on earlier versions
            if let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first{
               try? FileManager.default.removeItem(atPath: libraryPath)
            }
        }
        
    }
}


