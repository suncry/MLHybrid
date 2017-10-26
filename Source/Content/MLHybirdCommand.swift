//
//  MLHybirdCommand.swift
//  Pods
//
//  Created by yang cai on 2017/8/23.
//
//

import Foundation

open class MLHybirdCommand {
    
    //指令名
    public var name = ""
    //外部使用参数
    var params: [String: AnyObject] = [:]
    //内部使用参数
    var args: MLCommandArgs = MLCommandArgs()
    //发出指令的控制器
    public weak var viewController: MLHybridViewController!
    var callbackId: String = ""
    public weak var webView: UIWebView! = UIWebView() {
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
        if let callbackWeb = self.webView {
            if let resultStr = callbackWeb.stringByEvaluatingJavaScript(from: HybridEvent + "(\(dataString));") {
                completion(resultStr)
            } else {
                completion("")
            }
        }
    }
    
    /// 获取字符串参数
    public func stringFor(key: String) -> String {
        return self.params[key] as? String ?? ""
    }

    /// 获取整型参数
    public func intFor(key: String) -> Int {
        return self.params[key] as? Int ?? 1
    }
    
    /// 获取BOOL参数
    public func boolFor(key: String) -> Bool {
        return self.params[key] as? Bool ?? false
    }

    public func anyFor(key: String) -> AnyObject {
        return self.params[key] ?? "" as AnyObject
    }
    
    //获取发出命令的控制器
    private func commandFromVC() -> MLHybridViewController {
        var nextResponder = self.webView.next
        while !(nextResponder is MLHybridViewController) {
            nextResponder = nextResponder?.next ?? MLHybridViewController()
        }
        return nextResponder as? MLHybridViewController ?? MLHybridViewController()
    }

    /// 解析并执行hybrid指令
    ///
    /// - Parameters:
    ///   - urlString: 原始指令串
    ///   - webView: 触发指令的容器
    ///   - appendParams: 附加到指令串中topage地址的参数 一般情况下不需要
    class func analysis(request: URLRequest, webView: UIWebView) -> MLHybirdCommand? {
        guard let url = request.url else  { return nil }
        if url.scheme != MLHybrid.shared.scheme {
            return nil
        }
        let command = MLHybirdCommand()
        let result = command.contentResolver(url: url)
        command.name = result.function
        command.params = result.params
        command.args = result.args
        command.callbackId = result.callbackId
        command.webView = webView
        return command
    }
    
    /// 解析hybrid指令
    ///
    /// - Parameters:
    ///   - urlString: 原始指令串
    /// - Returns: 执行方法名、参数、回调ID
    private func contentResolver(url: URL) -> (function: String, params:[String: AnyObject], args: MLCommandArgs, callbackId: String) {
        let functionName = url.host ?? ""
        let paramDic = url.hybridURLParamsDic()
        let argsDic = (paramDic["param"] ?? "").hybridDecodeURLString().hybridDecodeJsonStr()
        let args = MLCommandArgs.convert(argsDic)
        let callBackId = paramDic["callback"] ?? ""
        return (functionName, argsDic, args, callBackId)
    }
    
}
