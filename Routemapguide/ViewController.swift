//
//  ViewController.swift
//  Routemapguide
//
//  Created by hyu on R 2/07/15.
//  Copyright © Reiwa 2 hyu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet weak var naviButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    var pin1 = MKPointAnnotation()
    var pin2 = MKPointAnnotation()
    var color = UIColor.purple
    var route = MKDirections.Request().transportType
    var line:CGFloat = 3.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        pin1.coordinate = CLLocationCoordinate2D(latitude: 35.68124, longitude: 139.76672)
        pin1.title = "東京駅"
        
        pin2.coordinate = CLLocationCoordinate2D(latitude: 35.69555, longitude: 139.75074)
        pin2.title = "九段下駅"
        //pin1.pinColor = MKPointAnnotationColorGreen;
        mapView.addAnnotation(pin1)
        mapView.addAnnotation(pin2)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let centerPoint = CLLocationCoordinate2D(latitude: (pin1.coordinate.latitude + pin2.coordinate.latitude)/2, longitude: (pin1.coordinate.longitude + pin2.coordinate.longitude)/2)
        
        let region = MKCoordinateRegion(center: centerPoint, span: span)
        self.mapView.setRegion(region, animated: true)
        }


      func getRoute() {
        
        let fromPlaceMark = MKPlacemark(coordinate: pin1.coordinate, addressDictionary: nil)
        let toPlaceMark = MKPlacemark(coordinate: pin2.coordinate, addressDictionary: nil)
        
        let fromItem = MKMapItem(placemark: fromPlaceMark)
        let toItem = MKMapItem(placemark: toPlaceMark)
        
        var myRoute: MKRoute!
        let directionRequest = MKDirections.Request()
        directionRequest.transportType = route
        directionRequest.source = fromItem
        directionRequest.destination = toItem
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate(completionHandler:{(response, error) in
            
            if error == nil {
                myRoute = response?.routes[0]
                print("目的地まで \(myRoute.distance)m")
                print("所要時間 \(Int(myRoute.expectedTravelTime/60))分")
                self.mapView.addOverlay(myRoute.polyline, level: .aboveRoads)
             
            }
        })
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let route:MKPolyline = overlay as! MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline: route)
        routeRenderer.strokeColor = color
        routeRenderer.lineWidth = line
        return routeRenderer
    
    }

    @IBAction func walkingNavi(_ sender: UIButton) {
       
        color = UIColor.purple
        route = .walking
        line = 5.0
        getRoute()
    }
    
    @IBAction func carNavi(_ sender: UIButton) {
        color = UIColor.blue
        route = .automobile
        line = 8.0
        getRoute()
    
    }
}


