//
//  Hybrid_naviButtonModel.swift
//  Hybrid_Medlinker
//
//  Created by caiyang on 16/5/13.
//  Copyright © 2016年 caiyang. All rights reserved.
//

import UIKit

class Hybrid_naviButtonModel: NSObject {
    
    var tagname: String = ""
    var value: String = ""
    var icon: String = ""
    var callback: String = ""
    
    class func convert(_ dic: [String: AnyObject]) -> Hybrid_naviButtonModel {
        let naviButtonModel = Hybrid_naviButtonModel()
        naviButtonModel.tagname = dic["tagname"] as? String ?? ""
        naviButtonModel.value = dic["value"] as? String ?? ""
        naviButtonModel.icon = dic["icon"] as? String ?? ""
        naviButtonModel.callback = dic["callback"] as? String ?? ""
        return naviButtonModel
    }

}
