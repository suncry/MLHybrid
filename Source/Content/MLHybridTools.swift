//
//  MLHybridTools.swift
//  Hybrid_Medlinker
//
//  Created by caiyang on 16/5/31.
//  Copyright © 2016年 caiyang. All rights reserved.
//

import UIKit
import CoreLocation
import SSZipArchive

let HybridEvent = "Hybrid.callback"
let NaviImageHeader = "hybrid_navi_"

class MLHybridTools: NSObject {
    
    
    var command: MLHybirdCommand = MLHybirdCommand()
    
    //MARK: 资源路径相关
    fileprivate let checkVersionQAURL = "http://h5.qa.medlinker.com/app/version/latestList?app=medlinker&sys_p=i&cli_v="
    fileprivate let checkVersionURL = "http://h5.medlinker.com/app/version/latestList?app=medlinker&sys_p=i&cli_v="
    
    //MARK: Method
    func performCommand(request: URLRequest, webView: UIWebView) -> Bool {
        if let hybridCommand = MLHybirdCommand.analysis(request: request, webView: webView) {
            command = hybridCommand
            execute()
            return true
        } else {
            return false
        }
    }
    
    /// 根据指令执行对应的方法
    private func execute() {
        guard let funType = MLHybridMethodType(rawValue: command.name) else {
            MLHybrid.shared.delegate?.methodExtension(command: command)
            return
        }
        switch funType {
        case .UpdateHeader   : updateHeader()
        case .Back           : back()
        case .Forward        : forward()
        case .ShowHeader     : setNavigationBarHidden()
        case .CheckVersion   : checkVersion()
        case .OnWebViewShow  : onWebViewShow()
        case .OnWebViewHide  : onWebViewHide()
        case .SwitchCache    : switchCache()
        case .CurrentPosition: handleGetCurrentPosition()
        case .CopyLink       : handleCopyLink()
        case .GetLocation    : handleGetLocation()
        case .Pop            : pop()
        case .Openlink       : openlink()
        case .Addtoclipboard : copyContent()
        case .Gallery        : gallery()
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
    /// - Returns: 回调执行结果
    func callBack(data:Any = "", err_no: Int = 0, msg: String = "succuess", callback: String, webView: UIWebView , completion: @escaping ((String) ->Void))  {
        let data = ["data": data,
                    "errno": err_no,
                    "msg": msg,
                    "callback": callback] as [String : Any]
        let dataString = data.hybridJSONString()
        
        if let resultStr = webView.stringByEvaluatingJavaScript(from: HybridEvent + "(\(dataString));") {
            completion(resultStr)
        } else {
            completion("")
        }
    }
    
    func updateHeader() {
        //如果有父控制器则不设置header
        if let _ = command.viewController.parent { return }
        let header = command.args.header
        let navigationItem = command.viewController.navigationItem
        navigationItem.titleView = self.setUpNaviTitleView(header.title)
        self.setRightButtons(header.right, navigationItem: navigationItem)
        self.setLeftButtons(header.left, navigationItem: navigationItem)
    }
    
    func setLeftButtons(_ leftButtons:[Hybrid_naviButtonModel], navigationItem: UINavigationItem) {
        let barButtons = self.setUpButtons(leftButtons)
        self.command.viewController.navigationItem.setLeftBarButtonItems(barButtons, animated: true)
    }
    
    func setRightButtons(_ rightButtons:[Hybrid_naviButtonModel], navigationItem: UINavigationItem) {
        let barButtons = self.setUpButtons(rightButtons)
        self.command.viewController.navigationItem.setRightBarButtonItems(barButtons, animated: true)
    }

    func setUpNaviTitleView(_ titleModel:Hybrid_titleModel) -> HybridNaviTitleView {
        let naviTitleView = HybridNaviTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        let leftUrl = NSURL(string: titleModel.lefticon) ?? NSURL()
        let rightUrl = NSURL(string: titleModel.righticon) ?? NSURL()
        naviTitleView.loadTitleView(titleModel.title, subtitle: titleModel.subtitle, lefticonUrl: leftUrl as URL, righticonUrl: rightUrl as URL, callback: titleModel.callback, currentWebView: command.webView)
        return naviTitleView
    }
    
    func setUpButtons(_ buttonModels:[Hybrid_naviButtonModel]) -> [UIBarButtonItem] {
        var barButtons = MLHybridButton.setUp(models: buttonModels, webView: command.webView)
        let spaceBar = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceBar.width = -15
        barButtons.insert(spaceBar, at: 0)
        return barButtons
    }
    
    func back() {
        if let navi = self.command.viewController.navigationController {
            navi.popViewController(animated: true)
        } else {
            self.command.viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func forward() {
        if command.args.isH5 {
            guard let webViewController = MLHybrid.load(urlString: command.args.topage) else {return}
            guard let navi = self.command.viewController.navigationController else {return}
            navi.pushViewController(webViewController, animated: true)
        } else {
            //这里指定跳转到本地某页面   需要一个判断映射的方法
        }
    }
    
    func setNavigationBarHidden() {
        let vc = self.command.viewController
        if vc?.navigationController?.viewControllers.last == vc {
            vc?.navigationController?.setNavigationBarHidden(!command.args.display, animated: command.args.animate)
        }
    }
    
    /**
     * 获取设备位置
     */
    func handleGetCurrentPosition() {
        self.command.viewController.locationModel.getLocation { (success, errcode, resultData) in
            _ = self.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: errcode, callback: self.command.callbackId, webView: self.command.webView, completion: {js in
            })
        }
    }
    
    func oldPay() {
//        let payUrl = args["orderurl"] as? String ?? ""
//        MLPay.wallet(payUrl, currentController: self.currentVC() ?? UIViewController()) { (success, errorMsg, resultCode) in
//            webView.reload()
//            print("状态： \(success)  errorMsg: \(errorMsg) resultCode: \(resultCode)")
//        }
    }

    func onWebViewShow() {
        self.command.viewController.onShowCallBack = self.command.callbackId
    }
    
    func onWebViewHide() {
        self.command.viewController.onHideCallBack = self.command.callbackId
    }

    func switchCache() {
        UserDefaults.standard.set(!command.args.open, forKey: "HybridSwitchCacheClose")
    }
    
}


//MARK: 支付

extension MLHybridTools {
    /**
     * 支付宝支付
     */
    func handleAlipay() {
//        let orderString  = args["payInfo"] as? String ?? ""
//        MLPay.sharedInstance.alipay(orderString) { (success, errorMsg, resultCode) in
//            let payResult = ["code":resultCode,
//                             "result":errorMsg]
//            _ = self.callBack(data: payResult, err_no: 0, msg: errorMsg, callback: callbackID, webView: webView, completion: {js in
//            })
//            if let finishBlock = MLPay.sharedInstance.finishBlock {
//                finishBlock(success, errorMsg, resultCode)
//            }
//        }
    }
    
    /**
     * 微信支付
     */
    func handleWeChatPay() {
//        let orderString = args["payInfo"] as? String ?? ""
//        let data = orderString.data(using: String.Encoding.utf8)
//        let orderDic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//        MLPay.sharedInstance.weChat(orderDic as! [AnyHashable : Any], finishBlock: { (success, errorMsg, resultCode) in
//            let payResult = ["code":resultCode,
//                             "result":errorMsg]
//            _ = self.callBack(data: payResult, err_no: 0, msg: errorMsg, callback: callbackID, webView: webView, completion: {js in })
//            if let finishBlock = MLPay.sharedInstance.finishBlock {
//                finishBlock(success, errorMsg, resultCode)
//            }
//        })
    }
    
    /**
     * H5钱包支付回调
     */
    func handlePayCallBack() {
        print("handlePayCallBack")
//        print("args == \(args)")
        
//        if let finishBlock = MLPay.sharedInstance.finishBlock, let vc = self.currentVC() {
//            let status = args["status"] as? Int ?? 0
//            _ = vc.navigationController?.popViewController(animated: true)
//            switch status {
//            case 1:
//                //成功
//                finishBlock(true, "钱包支付成功", "")
//                break
//            case 2:
//                //失败
//                finishBlock(false, "钱包支付失败", "")
//                break
//            case 3:
//                //用户取消
//                finishBlock(false, "用户取消钱包支付", "")
//                break
//            default:
//                finishBlock(false, "钱包支付未知错误", "")
//                break
//            }
//        }
//        else {
//            if let vc = self.currentVC() {
//                _ = vc.navigationController?.popViewController(animated: true)
//            }
//        }
    }

    func iOSBuy() {
//        if MLIAPHelper.isIAPPurching {
//            return
//        }
//        MLIAPHelper.isIAPPurching = true
////        let productID = args["pid"] as? String ?? ""
//        let productID = args["pid"] as? String ?? ""
//        MLIAPHelper.buyWithProductID(productID) { (success, errorMsg) in
//            print("productID == \(productID)")
//            MLIAPHelper.isIAPPurching = false
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateAccount"), object: nil)
//            if success {
//                //                MLTosat.message("充值成功")
//            } else {
//                print("充值失败")
//            }
//        }
    }

    /**
     * 复制网页链接
     */
    func handleCopyLink() {
        if let urlString = command.webView.request?.url?.absoluteString {
            let pasteboard = UIPasteboard.general
            pasteboard.string = urlString
        }
    }
    
    /**
     * 获取位置
     */
    func handleGetLocation() {
        self.command.viewController.locationModel.getLocation { (success, errcode, resultData) in
            _ = self.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: errcode, callback: self.command.callbackId, webView: self.command.webView, completion: {js in })
        }
    }
    
    /**
     * pop 返回num个页面
     */
    func pop() {
        //推出所有hybrid页面
        if command.args.num == 999 {
            guard let vcs = self.command.viewController.navigationController?.viewControllers else {return}
            var toVC = vcs.first
            var i = 0
            while i < vcs.count {
                if vcs[vcs.count - i - 1] is MLHybridViewController {
                    toVC = vcs[vcs.count - i - 1]
                }
                i = i + 1
            }
            if let toVC = toVC {
                let _ = self.command.viewController.navigationController?.popToViewController(toVC, animated: true)
            }
        }
        //返回指定步骤
        if let vcs = self.command.viewController.navigationController?.viewControllers {
            if vcs.count > command.args.num {
                let vc = vcs[vcs.count - command.args.num - 1]
                let _ = self.command.viewController.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }

    func openlink() {
        self.jumpToThirdParty(url: command.args.url)
    }
    
    func copyContent() {
        UIPasteboard.general.string = command.args.content
//        MLToast.message("已复制")
    }
    
    func jumpToThirdParty(url: String) {
//        if let vc = MLOpenWebViewController.loadURL(url: url) {
//            self.currentNavi()?.pushViewController(vc, animated: true)
//        }
    }
    
    func logout() {
//        LoginUserViewModel.shared.logout { (data, error) in
//            if error != nil {
//                CyAlertView.message(error?.localizedDescription)
//            }
//        }
    }
    
    func uploadImage() {
//        let maxCount = args["maxCount"] as? Int ?? 1
//        let imageUploader = ImageUploader()
//        let currentVC = self.viewControllerOf(webView)
//        MLPhotoPicker.picker(maxCount: maxCount, delegateController: self.currentVC()!) { (assets, nil) in
//            currentVC.startAnimating()
//            imageUploader.uploadImages(assets, authority: .isPublic, warterMark: .withoutMark, bucket: .post, completion: { (error) in
//                currentVC.stopAnimating()
//                if error == nil {
//                    _ = self.callBack(data:( ["urls": imageUploader.imageURLPathes] as Any), err_no: 0 , callback: callbackID, webView: webView, completion: {js in
//                    })
//                } else {
//                    _ = self.callBack(data: "", err_no: 0 , callback: callbackID, webView: webView, completion: {js in
//                    })
//                }
//            })
//        }
    }
    func gallery() {
//        if let index = args["index"] as? Int, let imgs = args["imgs"] as? [String] {
//            guard imgs.count > 0 else {
//                CyAlertView.message("图片信息错误")
//                return
//            }
//            let imageBrowser = MLImageBrowserViewController(imageURLStrings: imgs)
//            imageBrowser.showWithIndex (index)
//        }
    }
}

//MARK: 离线包相关

extension MLHybridTools {
    open func showVersion() {
        let hybridVersionArray = UserDefaults.standard.value(forKey: "HybridVersion") as? NSMutableArray ?? ["未获取到版本信息"]
        let msg = hybridVersionArray.description
        let alert = UIAlertView(title: "离线包版本信息", message: msg, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    open func checkVersion() {
        let versionStr = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
//        let checkVersionURLString = MLConfiguration.mlHTTPType == .qa ? checkVersionQAURL : checkVersionURL

        let checkVersionURLString = checkVersionURL
        
        let url:URL! = URL(string: checkVersionURLString + "\(versionStr!)")
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = "GET"
        //响应对象
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
            do{//发送请求
                if let responseData = data {
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let dic = jsonData as? NSDictionary, let dataArray = dic["data"] as? [AnyObject] {
                        
                        UserDefaults.standard.setValue(dataArray, forKey: "HybridVersion")
                        for dataDic in dataArray {
                            let channel = dataDic["channel"] as? String ?? ""
                            let version = dataDic["version"] as? String ?? ""
                            let src = dataDic["src"] as? String ?? ""
                            if version.compare(self.localResourcesVersion(channel: channel), options: NSString.CompareOptions.numeric) == .orderedDescending {
                                self.loadZip(channel: channel, version: version, urlString: src, completion: nil)
                            }
                            else {
                                print("不更新 \(channel).zip")
                            }
                        }
                    }
                }
                else {
                    print("checkVersion data null")
                }
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
        })
    }
    
    private func loadZip(channel: String, version: String, urlString: String, completion: ((_ success: Bool, _ msg: String) -> Void)?) {
        if version == "forbidden" {
            let filePath = self.filePath(channel: channel)
            self.deleteAllFiles(path: filePath)
            return
        }
        if let url = URL(string: urlString) {
            let urlRequest:NSMutableURLRequest = NSMutableURLRequest(url: url)
            urlRequest.httpMethod = "GET"
            NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
                if error != nil {
                    completion?(false, error!.localizedDescription)
                }
                if let responseData = data {
                    let filePath = self.filePath(channel: channel)
                    let zipPath = filePath + ".zip"
                    self.deleteAllFiles(path: filePath)
                    if (try? responseData.write(to: URL(fileURLWithPath: zipPath), options: [.atomic])) != nil {
                        if SSZipArchive.unzipFile(atPath: zipPath, toDestination: filePath) {
                            self.setLocalResourcesVersion(channel: channel, version: version)
                            self.deleteAllFiles(path: zipPath)
                            print("下载并解压了 \(channel)")
                            completion?(true, "")
                        }
                        else {
                            completion?(false, "解压失败 \(zipPath)")
                        }
                    }
                    else {
                        completion?(false, "写入失败 \(zipPath)")
                    }
                }
                else {
                    completion?(false, "更新包 为空")
                }
            })
        }
    }
    
    private func filePath(channel: String) -> String {
        do {
            let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/h5"
            let fileManager = FileManager.default
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            return documentPath + "/" + channel
        } catch {
            return ""
        }
    }
    
    private func deleteAllFiles(path: String) {
        do {
            if let fileArray : [AnyObject] = FileManager.default.subpaths(atPath: path) as [AnyObject]? {
                for f in fileArray {
                    if FileManager.default.fileExists(atPath: path + "/\(f)") {
                        try FileManager.default.removeItem(atPath: path + "/\(f)")
                    }
                }
            }
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
        } catch {
        }
    }
    
    private func localResourcesVersion(channel:String) -> String {
        let versionDic = UserDefaults.standard.value(forKey: "LocalResourcesVersionDic") as? [String: String] ?? ["": ""]
        return versionDic[channel] ?? ""
    }
    
    private func setLocalResourcesVersion(channel:String, version: String) {
        var defaultsDic = UserDefaults.standard.value(forKey: "LocalResourcesVersionDic") as? [String: String] ?? ["": ""]
        defaultsDic[channel] = version
        UserDefaults.standard.set(defaultsDic, forKey: "LocalResourcesVersionDic")
    }

}