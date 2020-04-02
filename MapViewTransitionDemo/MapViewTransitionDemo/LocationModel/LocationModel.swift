//
//  LocationModel.swift
//  MapViewTransitionDemo
//
//  Created by huangxh on 2020/4/1.
//  Copyright © 2020 Alan. All rights reserved.
//

import Foundation
import MapKit

protocol Location {
    var name: String? {get}
    var address: String? {get}
    var coordination: CLLocationCoordinate2D? {get}
}

class LocationModel: Location {
    var name: String?
    var address: String?
    var coordination: CLLocationCoordinate2D?
    
    init?(name: String?,address: String?,coordinate: CLLocationCoordinate2D?) {
        if name == nil || coordinate == nil {
            return nil
        }else{
            self.name = name
            self.address = address
            self.coordination = coordinate
        }
    }
}
