//
//  urlRequest.swift
//  google map test
//
//  Created by 정민우 on 2020/09/29.
//  Copyright © 2020 hayannoon. All rights reserved.
//

import Foundation



func httpRequestHandler(_ ChargerID:String)  throws -> String {
    let baseUrl = "http://34.64.73.242:3000/api/getChargerInfo/"
    let completedUrl = baseUrl + ChargerID
    let url = URL(string: completedUrl)
          let response = try String(contentsOf: url!)
    let firstIndex = response.index(response.startIndex, offsetBy: 1)
    let lastIndex = response.index(response.endIndex, offsetBy: -1)
    let parsedResponse = "\(response[firstIndex..<lastIndex])"
          
    return parsedResponse
}




func getChargerStatus(_ charger: String) throws -> String{

    
        let urlResponse = try httpRequestHandler(charger)
        if let chargerData = urlResponse.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            
            do {
                let chargerData = try decoder.decode(Charger.self, from: chargerData) //json을 디코드해서 데이터화
                if chargerData != nil{
                    let stateName:String? = chargerData.statNm
                    let chargerAddress:String? = chargerData.addr
                    let chargerUseTime:String? = chargerData.useTime
                    let chargerBusinessName:String? = chargerData.busiNm
                    let chargerState:String? = chargerData.stat
                    
                    var returnValue:String = ""
                    returnValue += ("충전소 명 : " + stateName! + "\n")
                    returnValue += ("충전소 주소 : " + chargerAddress! + "\n")
                    returnValue += ("이용 시간 : " + chargerUseTime! + "\n")
                    //returnValue += ("충전소 업체 : " + chargerBusinessName! + "\n")
                    returnValue += ("현재 충전소 상태 : " + chargerState!)
                    
                    return returnValue
                }
                }
                //print(chargerArray.chargers?.self[0].addr!)
             catch {
                print(error.localizedDescription)
            }
        }
      //구조체 다 저장하고
        return ""
    }
    
