//
//  DirectionMapViewController.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import Foundation
import UIKit
import GoogleMaps

var originLatitude = Double(origin.coordinate.latitude)
var originLongitude = Double(origin.coordinate.longitude)

let INIT_CAMERA = GMSCameraPosition.camera(withLatitude: originLatitude, longitude: originLongitude, zoom: 15.0)

let CHARGERS_PATH = String(#file[...#file.index(#file.lastIndex(of: "/")!, offsetBy: -7)] + "allchargers.json")


//let MARKER_LIST = makeMarke  rList()

func makeMarkerList() -> [GMSMarker] {
    var markerList: [GMSMarker] = [] //마커들을 저장할 배열 생성
    
    if let contents = try? String(contentsOfFile: CHARGERS_PATH) {
        
        let chargerData = contents.data(using: .utf8)!
        do {
            let chargerArray = try JSONDecoder().decode(Chargers.self, from: chargerData)
            for charger in chargerArray.chargers! {
                markerList.append(makeGMS(charger)!)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    return markerList
}


class DirectionMapViewController: UIViewController,GMSMapViewDelegate {
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //여기까진 마커 시작
        var markerList: [GMSMarker] = [] //마커들을 저장할 배열 생성
        
        if let contents = try? String(contentsOfFile: fullPath){ //json 다 string형식으로 읽어온다.
            
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
        //여기까지 마커 끝
        
        
        
        
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: INIT_CAMERA)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true;
        mapView.camera = INIT_CAMERA
        self.view.addSubview(mapView)
        
        mapView.delegate = self
        
        if GMS_PATH != nil {
            let direction = GMSPolyline(path: GMS_PATH)
            direction.strokeWidth = 5.0 // 선 굵기
            direction.map = mapView
        }
        
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
