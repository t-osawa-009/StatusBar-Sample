//
//  UIScrollView+Bouncing.swift
//  StatusBar-Sample
//
//  Created by Takuya Ohsawa on 2018/02/19.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/2853946/how-can-i-test-if-the-scroll-view-is-bouncing
extension UIScrollView {
    var isBouncing: Bool {
        return isBouncingTop || isBouncingLeft || isBouncingBottom || isBouncingRight
    }
    
    var isBouncingTop: Bool {
        return contentOffset.y < -contentInset.top
    }
    
    var isBouncingLeft: Bool {
        return contentOffset.x < -contentInset.left
    }
    
    var isBouncingBottom: Bool {
        let contentFillsScrollEdges = contentSize.height + contentInset.top + contentInset.bottom >= bounds.height
        return contentFillsScrollEdges && contentOffset.y > contentSize.height - bounds.height + contentInset.bottom
    }
    
    var isBouncingRight: Bool {
        let contentFillsScrollEdges = contentSize.width + contentInset.left + contentInset.right >= bounds.width
        return contentFillsScrollEdges && contentOffset.x > contentSize.width - bounds.width + contentInset.right
    }
}
