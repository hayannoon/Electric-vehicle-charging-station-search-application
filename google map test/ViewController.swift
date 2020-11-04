//
//  ViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/09/23.
//  Copyright © 2020 hayannoon. All rights reserved.
//



import UIKit
import GoogleMaps

var selectedId: String = ""
var selectedNumberOfChargers: Int = 0


class ViewController: UIViewController {

    @IBAction func click_move_btn(_ sender: Any) {
        // 1. 스토리보드에서 이동할 컨트롤러를 찾는다.
        
        //옵셔널 바인딩
        if let controller = self.storyboard?.instantiateViewController(identifier: "MapViewController"){
         
             // 2. 찾은 컨트롤러로 이동한다. (push Controller)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    

    
    @IBAction func directionBtn(_ sender: Any) {
        //옵셔널 바인딩
               if let controller = self.storyboard?.instantiateViewController(identifier: "DirectionSearchViewController"){
                
                    // 2. 찾은 컨트롤러로 이동한다. (push Controller)
                   self.navigationController?.pushViewController(controller, animated: true)
               }
        
    }
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
        
     }
}



