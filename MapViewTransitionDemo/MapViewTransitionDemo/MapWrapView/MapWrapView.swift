//
//  MapWrapView.swift
//  MapViewTransitionDemo
//
//  Created by huangxh on 2020/4/1.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit
import MapKit


/// MapWrapView,对mapview的包装,内部可以根据需要换成别的地图视图,如高德
class MapWrapView: UIView {
    let mapview: MKMapView
    
    override init(frame: CGRect) {
        mapview = MKMapView()
        super.init(frame: frame)
        addSubview(mapview)
        mapview.translatesAutoresizingMaskIntoConstraints = false
        mapview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mapview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        mapview = MKMapView()
        super.init(coder: coder)
        addSubview(mapview)
        mapview.translatesAutoresizingMaskIntoConstraints = false
        mapview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mapview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
