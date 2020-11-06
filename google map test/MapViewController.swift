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


//let CHARGERS_PATH = String(#file[...#file.index(#file.lastIndex(of: "/")!, offsetBy: -7)] + "allchargers.json")

let fullPath = "/Users/minu/Downloads/allchargers.json" //json파일 경로
//let fullPath = "./allchargers.json" //json파일 경로
let CHARGERS_PATH: String = #file[...#file[..<#file.lastIndex(of: "/")!].lastIndex(of: "/")!] + "allchargers.json"
class MapViewController: UIViewController, GMSMapViewDelegate {
    
    
    override func viewDidLoad() {
             super.viewDidLoad()
            
        
        var markerList: [GMSMarker] = [] //마커들을 저장할 배열 생성
        
        if let contents = try? String(contentsOfFile: CHARGERS_PATH){ //json 다 string형식으로 읽어온다.
            
            if let chargerData = contents.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    let chargerArray = try decoder.decode(Chargers.self, from: chargerData) //json을 디코드해서 데이터화
                    // json data를 파싱해서 chargerArray에 넣는다.
                    if chargerArray.chargers?.self[0].addr != nil{
                        //charger의 주소가 있다면
                        for item in (chargerArray.chargers)!{ //marker 배열에 추가해준다.
                            let tmp = makeGMS(item)
                            if(tmp != nil) {
                             markerList.append(tmp!)
                            }
                        }
                        //print((chargerArray.chargers?.self[0].addr)!)
                    }
                    //print(chargerArray.chargers?.self[0].addr!)
                } catch {
                    print(error.localizedDescription)
                }
            }
         } //구조체 다 저장하고
        
        
           
        let camera = GMSCameraPosition.camera(withLatitude: 35.554539999999, longitude: 129.3081599999, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            mapView.delegate = self
            mapView.isMyLocationEnabled = true //내가 추가
            mapView.settings.myLocationButton = true; //내가 추가
            self.view.addSubview(mapView)
        self.view = mapView
        
        
        for mark in markerList{
                   mark.map = mapView
               }
       }
    
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool { //Marker에 거는 이벤트
        let statId = marker.title
        let desc = try? getChargerStatus(statId!)
        
        
        let alert = UIAlertController(title: "충전소 세부정보", message: desc, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "예약", style: .default, handler: { (action) in //예약버튼눌렀을때
                
            selectedId = statId!
            //옵셔널 바인딩
            if let controller = self.storyboard?.instantiateViewController(identifier: "ChargersTableViewController"){
                    
                 // 2. 찾은 컨트롤러로 이동한다. (push Controller)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        
        }))
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))

        self.present(alert, animated: true)

         return true
    }
}




