////
////  directionViewController.swift
////  google map test
////
////  Created by 정민우 on 2020/09/24.
////  Copyright © 2020 hayannoon. All rights reserved.
////
//import UIKit
//import GooglePlaces
//
//
//class DirectionViewController: UIViewController,UITextFieldDelegate {
//
//      override func viewDidLoad() {
//             super.viewDidLoad()
//               let controller = GMSAutocompleteViewController() //구글 자동완성 뷰컨트롤러 생성
//               controller.delegate = self //딜리게이트
//               present(controller, animated: true, completion: nil) //보여주기
//               }
//
//
//
//    @IBAction func tesetButton(_ sender: Any) {
//        //옵셔널 바인딩
//               if let controller = self.storyboard?.instantiateViewController(identifier: "TimeSelectViewController"){
//
//                    // 2. 찾은 컨트롤러로 이동한다. (push Controller)
//                   self.navigationController?.pushViewController(controller, animated: true)
//               }
//
//
//    }
//
//
//}
//
//     extension DirectionViewController: GMSAutocompleteViewControllerDelegate { //해당 뷰컨트롤러를 익스텐션으로 딜리게이트를 달아준다.
//         func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//              print("Place name: \(String(describing: place.name))") //셀탭한 글씨출력
//              dismiss(animated: true, completion: nil) //화면꺼지게
//         } //원하는 셀 탭했을 때 꺼지게
//
//         func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//             print(error.localizedDescription)//에러났을 때 출력
//         } //실패했을 때
//
//         func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//             dismiss(animated: true, completion: nil) //화면 꺼지게
//         } //캔슬버튼 눌렀을 때 화면 꺼지게
//
//
//     }
//
//
//
//
//

//
//  DirectionSearchViewController.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import UIKit
import GooglePlaces
import GoogleMaps

let googleApiKey = "AIzaSyDZhs48L08E0PYN1ZZuepYI3p8D5daWujc"
let naverClientId: String = "hzdvp26eix"
let naverClientSecret: String = "rhHkuYItGK6PHR49pXOJFl8prgjRWxZiiFgri9FM"

var origin: GMSPlace!
var destination: GMSPlace!

var GMS_PATH: GMSMutablePath? = nil

var directionPathMaxLat: Double = 0.0
var directionPathMinLat: Double = 1000.0
var directionPathMaxLng: Double = 0.0
var directionPathMinLng: Double = 1000.0

class DirectionSearchViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationSearchBar: UITextField!
    @IBOutlet weak var srcSearchBar: UITextField!
    @IBOutlet weak var dstSearchBar: UITextField!
    var tappedSearchBar: UITextField!
  //  var origin: GMSPlace!
  //  var destination: GMSPlace!
    
    @IBAction func searchBarTappedHandler(_ sender: Any) {
        let button = sender as! UIButton
        switch (button.tag) {
        case 0:
            tappedSearchBar = locationSearchBar
        case 1:
            tappedSearchBar = srcSearchBar
        case 2:
            tappedSearchBar = dstSearchBar
        default:
            tappedSearchBar = nil
        }
        tappedSearchBar.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    @IBAction func searchDirectionHandler(_ sender: Any) {
        directionRequest()
    }
    
    func directionRequest() {
        let origin_lng = String(format: "%lf", Double(origin.coordinate.longitude))
        let origin_lat = String(format: "%lf", Double(origin.coordinate.latitude))
        let destination_lng = String(format: "%lf", Double(destination.coordinate.longitude))
        let destination_lat = String(format: "%lf", Double(destination.coordinate.latitude))
//        let option: String
        let parameters = "start=" + origin_lng + "," + origin_lat
                 + "&" + "goal=" + destination_lng + "," + destination_lat
//                 + "&" + "option=" + option
        
        let baseUrl: String = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving"

        let completeUrl = URL(string: baseUrl + "?" + parameters)
        var request = URLRequest(url: completeUrl!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(naverClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(naverClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
            var str = String(data: data, encoding: .utf8)!
//            print(str)
            
            let beg = str.range(of: "\"path\":")!
            str.removeSubrange(str.startIndex..<beg.upperBound)
            let end = str.range(of: ",\"section\"")!
            str.removeSubrange(end.lowerBound...)
            // str -> [[lng,lat],[lng, lat] ... [lng,lat]]
//            print(str)
            
            let directionPath = try! JSONDecoder().decode(DirectionPaths.self, from: str.data(using: .utf8)!)
            DispatchQueue.main.async {
                
                self.drawPath(directionPath)
            }
        }
        task.resume()
    }
    
    func drawPath(_ directionPath: DirectionPaths) {
        GMS_PATH = GMSMutablePath()
        for lnglat in directionPath.list! {
            GMS_PATH!.add(CLLocationCoordinate2D(latitude: lnglat[1], longitude: lnglat[0]))
            if Double(lnglat[1]) > directionPathMaxLat{
                directionPathMaxLat = Double(lnglat[1])
            } else if Double(lnglat[1]) < directionPathMinLat {
                directionPathMinLat = Double(lnglat[1])
            }
            
            if Double(lnglat[0]) > directionPathMaxLng{
                directionPathMaxLng = lnglat[0]
            } else if Double(lnglat[0]) < directionPathMinLng {
                directionPathMinLng = Double(lnglat[0])
            }
            
        }
        
        guard let dmvc = self.storyboard?.instantiateViewController(identifier: "DirectionMapViewController") as? DirectionMapViewController else { return }
        self.navigationController?.pushViewController(dmvc, animated: true)
    }
    
}

     extension DirectionSearchViewController: GMSAutocompleteViewControllerDelegate {
         func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
              print("Place name: \(String(describing: place.name))")
              dismiss(animated: true, completion: nil)
            
            switch (tappedSearchBar.tag) {
            case 1:
                origin = place
            case 2:
                destination = place
            default:
                break
            }
            
            tappedSearchBar.text = place.name
            let lat = String(format: "%lf", Double(place.coordinate.latitude))
            let lng = String(format: "%lf", Double(place.coordinate.longitude))
            print("lat: \(lat)")
            print("lng: \(lng)")
            
/*
            mapView camera setting exmaple
            let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
            self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
*/

            
         }
         
         func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
             print(error.localizedDescription)
         }
         
         func wasCancelled(_ viewController: GMSAutocompleteViewController) {
             dismiss(animated: true, completion: nil)
         }
         
         
     }
