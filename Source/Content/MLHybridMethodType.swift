//
//  MLHybridMethodType.swift
//  Pods
//
//  Created by yang cai on 2017/8/14.
//
//

import Foundation

//MARK: 事件类型

enum MLHybridMethodType: String {
    case UpdateHeader = "updateheader"
    case Back = "back"
    case Forward = "forward"
    case ShowHeader = "showheader"
    case CheckVersion = "checkver"
    case OnWebViewShow = "onwebviewshow"
    case OnWebViewHide = "onwebviewhide"
    case SwitchCache = "switchcache"
    case CurrentPosition = "getcurlocpos"
    //5.0新增
    case CopyLink = "copyLink"
    case GetLocation = "getLocation"
    case Pop = "pop"
    case Openlink = "openLink"
    //5.1
    case Addtoclipboard = "addtoclipboard"
    
}

