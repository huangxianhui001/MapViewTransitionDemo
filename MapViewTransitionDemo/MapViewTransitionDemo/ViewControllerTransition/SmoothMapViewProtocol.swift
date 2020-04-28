//
//  SmoothMapViewProtocol.swift
//  MapViewTransitionDemo
//
//  Created by huangxh on 2020/4/13.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit

protocol SmoothMapViewProtocol {
    var mapWrapView:MapWrapView?{ get set}
    var mapContainerView:UIView? { get }
    
}

protocol SmoothMapViewAnimateProtocol : SmoothMapViewProtocol {
    var needPushPopAnimate:Bool { get set }
}

extension SmoothMapViewAnimateProtocol {
    var needPushPopAnimate:Bool{
        get{ return false }
    }
}
