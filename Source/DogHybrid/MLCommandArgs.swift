//
//  Args.swift
//  Pods
//
//  Created by yang cai on 2017/8/17.
//
//

import UIKit

open class MLCommandArgs: NSObject {
    
    var type: String = "h5" //页面类型
    var isH5: Bool = true //页面类型是否为H5
    var topage: String = "" //跳转页面地址
    var display: Bool = true //显示/隐藏导航栏
    var animate: Bool = true //显示/隐藏导航栏动画
    var open: Bool = true //是否打开离线包
    var payInfo: String = "" //支付信息
    var status: Int = 0 //支付状态
    var pid: String = "" //productID
    var content: String = "" //复制的内容
    var url: String = "" //第三方地址
    var num: Int = 0 //回退页面数
    
    var dic: [String: AnyObject] = [:] //储存原始数据
    
    var header: Hybrid_headerModel = Hybrid_headerModel() //导航栏设置数据模型
    
    
    
    
    class func convert(_ dic: [String: AnyObject]) -> MLCommandArgs {
        let args = MLCommandArgs()
        args.dic = dic
        args.type = dic["type"] as? String ?? "h5"
        
        if args.type == "h5" {
            args.isH5 = true
        } else {
            args.isH5 = false
        }
        args.topage = dic["topage"] as? String ?? ""
        args.display = dic["display"] as? Bool ?? true
        args.animate = dic["animate"] as? Bool ?? true
        args.open = dic["open"] as? Bool ?? true
        args.payInfo = dic["payInfo"] as? String ?? ""
        args.status = dic["status"] as? Int ?? 0
        args.pid = dic["pid"] as? String ?? ""
        args.content = dic["content"] as? String ?? ""
        args.url = dic["url"] as? String ?? ""
        args.num = dic["num"] as? Int ?? 0
        args.header = Hybrid_headerModel.convert(dic)
        return args
    }
    
}
