//
//  directionViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/09/24.
//  Copyright © 2020 hayannoon. All rights reserved.
//
import UIKit
import GooglePlaces


class DirectionViewController: UIViewController,UITextFieldDelegate {
    
      override func viewDidLoad() {
             super.viewDidLoad()
               let controller = GMSAutocompleteViewController() //구글 자동완성 뷰컨트롤러 생성
               controller.delegate = self //딜리게이트
               present(controller, animated: true, completion: nil) //보여주기
               }
               
}

     extension DirectionViewController: GMSAutocompleteViewControllerDelegate { //해당 뷰컨트롤러를 익스텐션으로 딜리게이트를 달아준다.
         func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
              print("Place name: \(String(describing: place.name))") //셀탭한 글씨출력
              dismiss(animated: true, completion: nil) //화면꺼지게
         } //원하는 셀 탭했을 때 꺼지게
         
         func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
             print(error.localizedDescription)//에러났을 때 출력
         } //실패했을 때
         
         func wasCancelled(_ viewController: GMSAutocompleteViewController) {
             dismiss(animated: true, completion: nil) //화면 꺼지게
         } //캔슬버튼 눌렀을 때 화면 꺼지게
         
         
     }


    
    
   
