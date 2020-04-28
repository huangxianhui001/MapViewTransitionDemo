//
//  ViewController.swift
//  MapViewTransitionDemo
//
//  Created by huangxh on 2020/4/1.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit
import MapKit

enum SegueType : String {
    case startLocation
    case endLocation
}

/// 首页
class ViewController: UIViewController,SmoothMapViewAnimateProtocol {
        
    var needPushPopAnimate: Bool
    
    var mapWrapView: MapWrapView?
    
    var mapContainerView: UIView?{
        return self.mapContainerView
    }
    

    @IBOutlet weak var startLocation: UIButton!
    @IBOutlet weak var endLocation: UIButton!
    var startLocationModel: Location?
    var endLocationModel: Location?
    let mapManager = MapManager()
    
//    @IBOutlet weak var mapWrapView: MapWrapView!
    
    var mapView: MKMapView {
        get {
            return self.mapWrapView.mapview
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self.mapManager
        self.mapManager.mapView = self.mapView
        self.navigationController?.delegate = self;
        
    }


    @IBAction func onAddAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "viewController") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: SelectAddressViewController.self) {
            let selectAddress: SelectAddressViewController = segue.destination as! SelectAddressViewController
            let addressType: AddressType
            if let identifier = segue.identifier {
                switch identifier {
                case SegueType.startLocation.rawValue:
                    addressType = .start
                case SegueType.endLocation.rawValue:
                    addressType = .end
                default:
                    addressType = .start
                }
            }else {
                addressType = .start
            }
            selectAddress.addressType = addressType
            selectAddress.didSelectAddressCallback = { [unowned self] location,addressType in
                switch addressType {
                case .start:
                    self.startLocation.setTitle(location.name, for: .normal)
                    self.startLocationModel = location
                    self.mapManager.startAnnotation.coordinate = location.coordination ?? kCLLocationCoordinate2DInvalid
                    self.mapManager.startAnnotation.title = location.name
                    self.mapManager.startAnnotation.subtitle = location.address
                    self.mapView.removeAnnotation(self.mapManager.startAnnotation)
                    self.mapView.addAnnotation(self.mapManager.startAnnotation)
                case .end:
                    self.endLocation.setTitle(location.name, for: .normal)
                    self.endLocationModel = location
                    self.mapManager.endAnnotation.coordinate = location.coordination ?? kCLLocationCoordinate2DInvalid
                    self.mapManager.endAnnotation.title = location.name
                    self.mapManager.endAnnotation.subtitle = location.address
                    self.mapView.removeAnnotation(self.mapManager.endAnnotation)
                    self.mapView.addAnnotation(self.mapManager.endAnnotation)
                }
                if self.startLocationModel != nil && self.endLocationModel != nil {
                    self.calculateRoute()
                }
            }
        }
    }
    
    func calculateRoute() {
        MapUtility.calculateRouteWith(start: self.startLocationModel!, destination: self.endLocationModel!) {[weak self] (routes) in
            guard let self = self else { return }
            if routes == nil {
                let alertController = UIAlertController(title: "Error", message: "No Route", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.mapView.removeOverlays(self.mapView.overlays)
            }else{
                let bottom = self.view.frame.height - self.startLocation.frame.origin.y
                self.mapManager.bottomInset = bottom
                self.mapManager.addRoutes(routes!)
                
            }
        }
    }
    
}

