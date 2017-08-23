//
//  MLHybirdCommand.swift
//  Pods
//
//  Created by yang cai on 2017/8/23.
//
//

import Foundation
import WebKit

open class MLHybirdCommand {
    
    public var name = ""
    public var args: MLCommandArgs = MLCommandArgs()
    public var viewController: MLHybridViewController!
    var callbackId: String = ""
    var webView: WKWebView = WKWebView() {
        didSet {
            viewController = self.commandFromVC()
        }
    }
    
    /// 执行回调
    ///
    /// - Parameters:
    ///   - data: 回调数据
    ///   - err_no: 错误码
    ///   - msg: 描述
    ///   - callback: 回调方法
    ///   - webView: 执行回调的容器
    public func callback(data:Any = "", err_no: Int = 0, msg: String = "succuess", completion: @escaping ((String) ->Void)) {
        let data = ["data": data,
                    "errno": err_no,
                    "msg": msg,
                    "callback": self.callbackId] as [String : Any]
        let dataString = data.hybridJSONString()
        self.webView.evaluateJavaScript(HybridEvent + "(\(dataString));") { (result, error) in
            if let resultStr = result as? String {
                completion(resultStr)
            }else  if  let error = error{
                completion(error.localizedDescription)
            }
            else {
                completion("")
            }
        }
    }
    
    func commandFromVC() -> MLHybridViewController {
        var nextResponder = self.webView.next
        while !(nextResponder is MLHybridViewController) {
            nextResponder = nextResponder?.next ?? MLHybridViewController()
        }
        return nextResponder as? MLHybridViewController ?? MLHybridViewController()
    }

}
