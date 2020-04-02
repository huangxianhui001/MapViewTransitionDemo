//
//  MapManager.swift
//  MapViewTransitionDemo
//
//  Created by huangxh on 2020/4/1.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit
import MapKit

/// 地图代理的实现者
class MapManager : NSObject{
    
    var startAnnotation = MKPointAnnotation()
    var endAnnotation = MKPointAnnotation();
    
    weak var mapView: MKMapView?
    var inset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    
    var bottomInset: CGFloat {
        set {
            inset.bottom = newValue
        }
        get {
            return inset.bottom
        }
    }
    
    func addRoutes(_ routes:[MKRoute]) {
        
        if let mapView = self.mapView {
            mapView.removeOverlays(mapView.overlays)
            
            for route in routes {
                mapView.addOverlay(route.polyline)
                if mapView.overlays.count == 1 {
                    mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                              edgePadding: inset,
                                              animated: false)
                }
                else {
                    let polylineBoundingRect =  mapView.visibleMapRect.union(route.polyline.boundingMapRect)
                    mapView.setVisibleMapRect(polylineBoundingRect,
                                              edgePadding: inset,
                                              animated: false)
                }
            }
            
        }
    }
}

extension MapManager: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pointIdentifier = "point"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pointIdentifier)
            annotationView?.pinTintColor = MKPinAnnotationView.redPinColor()
            annotationView?.canShowCallout = true
        }
        return annotationView
            
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
          if mapView.overlays.count == 1 {
            polylineRenderer.strokeColor =
                UIColor.blue.withAlphaComponent(0.75)
          } else if mapView.overlays.count == 2 {
            polylineRenderer.strokeColor =
                UIColor.green.withAlphaComponent(0.75)
          } else if mapView.overlays.count == 3 {
            polylineRenderer.strokeColor =
                UIColor.red.withAlphaComponent(0.75)
          }
          polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
}


struct MapUtility {
    static let geocoder = CLGeocoder()
    static var directions: MKDirections?
    
    static func searchLocationsWith(keyword: String, complete:(([Location]?) -> Void)?) -> Void{
        if MapUtility.geocoder.isGeocoding {
            MapUtility.geocoder.cancelGeocode()
        }
        MapUtility.geocoder.geocodeAddressString(keyword) { placemarks, error in
            if error != nil || placemarks?.count == 0 {
                print("error: " + (error?.localizedDescription ?? ""))
                complete?(nil)
                return
            }
            var locations = [Location]()
            for placemark in placemarks! {
                let name = placemark.name
                let address = placemark.thoroughfare
                let coordinate = placemark.location?.coordinate
                let model = LocationModel(name:name,address: address,coordinate: coordinate)
                if model != nil {
                    locations.append(model!)
                }
            }
            complete?(locations)
        }
    }
    
    static func calculateRouteWith(start:Location,destination:Location, complete:(([MKRoute]?) -> Void)?){
        let source = MKMapItem(placemark: MKPlacemark(coordinate: start.coordination!))
        let dest = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordination!))
        let request: MKDirections.Request = MKDirections.Request()
        request.source = source
        request.destination = dest
        request.transportType = .automobile
        MapUtility.directions = MKDirections(request: request)
        MapUtility.directions?.calculate(completionHandler: { (response, error) in
            if error != nil || response?.routes.count == 0 {
                complete?(nil)
            }
            complete?(response?.routes)
        })
        
    }
}
