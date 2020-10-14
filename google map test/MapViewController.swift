//
//  MapViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/09/24.
//  Copyright © 2020 hayannoon. All rights reserved.
//
import Foundation
import UIKit
import GoogleMaps


let fullPath = "/Users/minu/Downloads/allchargers.json"



class MapViewController: UIViewController, GMSMapViewDelegate {
    
    
    override func viewDidLoad() {
             super.viewDidLoad()
             // Do any additional setup after loading the view.
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
        
        var markerList: [GMSMarker] = []
        
        if let contents = try? String(contentsOfFile: fullPath){
            
            if let chargerData = contents.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    let chargerArray = try decoder.decode(Chargers.self, from: chargerData) //json을 디코드해서 데이터화
                    if chargerArray.chargers?.self[0].addr != nil{
                        
                        
                        for item in (chargerArray.chargers)!{
                            let tmp = makeGMS(item)
                            if(tmp != nil) {
                             markerList.append(tmp!)
                            }
                        }
                        
                        
                        print((chargerArray.chargers?.self[0].addr)!)
                    }
                    //print(chargerArray.chargers?.self[0].addr!)
                } catch {
                    print(error.localizedDescription)
                }
            }
         } //구조체 다 저장하고
        
        
        
        
        
        
        
           
        let camera = GMSCameraPosition.camera(withLatitude: 35.97039200000, longitude: 126.68426200000, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
             
            mapView.isMyLocationEnabled = true //내가 추가
            mapView.settings.myLocationButton = true; //내가 추가
            self.view.addSubview(mapView)
        
        for mark in markerList{
                   mark.map = mapView
               }
        
        
        let btn = UIButton(type: .custom) as UIButton
        
        btn.setTitle("Button", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        self.view.addSubview(btn)
       }
}




