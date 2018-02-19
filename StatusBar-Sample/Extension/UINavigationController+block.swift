//
//  UINavigationController+block.swift
//  StatusBar-Sample
//
//  Created by Takuya Ohsawa on 2018/02/19.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func setNavigationBarHidden(hidden: Bool,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        setNavigationBarHidden(hidden, animated: animated)
        CATransaction.commit()
    }
    
}
