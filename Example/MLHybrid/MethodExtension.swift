//
//  MethodExtension.swift
//  MLHybrid
//
//  Created by yang cai on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import MLHybrid

class MethodExtension: MLHybridMethodProtocol {

    func methodExtension(command: MLHybirdCommand) {
        print("我也不知道怎么办 \(command.name)")
    }

}
