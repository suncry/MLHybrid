//
//  MLHybridMethodType.swift
//  Pods
//
//  Created by yang cai on 2017/8/14.
//
//

import Foundation

//MARK: 事件类型

enum FunctionType: String {
    case UpdateHeader = "updateheader"
    case Back = "back"
    case Forward = "forward"
//    case Get = "get"
//    case Post = "post"
    case Gallery = "gallery"
    case ShowHeader = "showheader"
    case CheckVersion = "checkver"
    case OldPay = "oldpay"
    case OnWebViewShow = "onwebviewshow"
    case OnWebViewHide = "onwebviewhide"
    case SwitchCache = "switchcache"
    case CurrentPosition = "getcurlocpos"
    //支付相关
    case PayByAlipay = "paybyalipay"
    case PayByWXpay = "paybywxpay"
    case iOSBuy = "iosbuy"
    case PayCallBack = "paycallback"
    //5.0新增
    case CopyLink = "copyLink"
    case GetLocation = "getLocation"
//    case OpenMap = "openMap"
    case Pop = "pop"
    case Openlink = "openLink"
    //5.1
    case Addtoclipboard = "addtoclipboard"
    
}

