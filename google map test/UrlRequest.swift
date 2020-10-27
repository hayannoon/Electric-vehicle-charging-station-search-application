//
//  urlRequest.swift
//  google map test
//
//  Created by 정민우 on 2020/09/29.
//  Copyright © 2020 hayannoon. All rights reserved.
//

import Foundation

func addJson(_ origin: String) -> String {
    return "{ \"chargers\" :" + origin + "}"
}

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


func httpRequestHandlerVer2(_ ChargerID:String)  throws -> String {
    let baseUrl = "http://34.64.73.242:3000/api/getChargerInfo/"
    let completedUrl = baseUrl + ChargerID
    let url = URL(string: completedUrl)
          let response = try String(contentsOf: url!)
          
    return addJson(response)
}


func splitTheResponse(_ origin: String) -> [String] {
    var splitedSegment = origin.components(separatedBy: "},")
    let count = splitedSegment.count
    var i = 0
    while i < count-1 {
        splitedSegment[i] += "}"
        i += 1
    }
    return splitedSegment
} // Response를 충전소별로 잘라서 배열에 넣어주는 Function

func getChargerStatus(_ charger: String) throws -> String{

    let urlResponse = try httpRequestHandler(charger)
    let parsedSegment = splitTheResponse(urlResponse)
    var i = 0
    var numberOfChargers = parsedSegment.count
    var numberOfAvailable = 0
    var returnValue:String = ""
    var isAvailable:String = "이용 불가능"
    while i < numberOfChargers{
        if let chargerData = parsedSegment[i].data(using: .utf8)
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
                    if chargerState == "2" {
                        numberOfAvailable += 1
                    }
                    if(i==0) {
                        if stateName != nil{
                    returnValue += ("충전소 명 : " + stateName! + "\n")
                        }
                        if chargerAddress != nil {
                            returnValue += ("충전소 주소 : " + chargerAddress! + "\n")
                        }
                        if chargerUseTime != nil {
                    returnValue += ("이용 시간 : " + chargerUseTime! + "\n")
                        }
                        if chargerBusinessName != nil {
                    returnValue += ("충전소 업체 : " + chargerBusinessName! + "\n")
                        }
                        if chargerState == "2" {
                            isAvailable = "이용 가능"
                        } else{
                            isAvailable = "이용 불가능"
                        }
                    returnValue += ("현재 충전소 상태 : " + isAvailable + "\n")
                    returnValue += "----------------------------\n"
                    }
                    i+=1
                }
                
                }
             catch {
                print(error.localizedDescription)
            }
        }
      
    }
    returnValue += "이용 가능한 충전소 개수 : "
    returnValue += "\(numberOfAvailable)"
    //여기서 리턴해줘야함
    return returnValue
       // return ""
    }


func getAllChargerStatus(_ charger: String) throws -> String{

    let urlResponse = try httpRequestHandler(charger)
    let parsedSegment = splitTheResponse(urlResponse)
    var i = 0
    var numberOfChargers = parsedSegment.count
    selectedNumberOfChargers = numberOfChargers //전역변수 변경
    var numberOfAvailable = 0
    var returnValue:String = ""
    var isAvailable = "이용 불가능"
    while i < numberOfChargers{
        if let chargerData = parsedSegment[i].data(using: .utf8)
        {
            let decoder = JSONDecoder()
            
            do {
           
                let chargerData = try decoder.decode(Charger.self, from: chargerData) //json을 디코드해서 데이터화
                if chargerData != nil{
                    let stateName:String? = chargerData.statNm
                    let chargerId:String? = chargerData.chgerId
                    let chargerAddress:String? = chargerData.addr
                    let chargerUseTime:String? = chargerData.useTime
                    let chargerBusinessName:String? = chargerData.busiNm
                    let chargerState:String? = chargerData.stat
                    if chargerState == "2" {
                        numberOfAvailable += 1
                    }
                    if stateName != nil{
                returnValue += ("충전소 명 : " + stateName! + "\n")
                    }
                    if chargerAddress != nil {
                        returnValue += ("충전소 주소 : " + chargerAddress! + "\n")
                    }
                    if chargerUseTime != nil {
                returnValue += ("이용 시간 : " + chargerUseTime! + "\n")
                    }
                    if chargerBusinessName != nil {
                returnValue += ("충전소 업체 : " + chargerBusinessName! + "\n")
                    }
                    if chargerState == "2" {
                        isAvailable = "이용 가능"
                    } else{
                        isAvailable = "이용 불가능"
                    }
                returnValue += ("현재 충전소 상태 : " + isAvailable + "\n")
                    returnValue += "-----------------------------------\n"
                   i+=1
                }
                  
                }
             catch {
                print(error.localizedDescription)
            }
        }
      
    }
    returnValue += "이용 가능한 충전소 개수 : "
    returnValue += "\(numberOfAvailable)"
    //여기서 리턴해줘야함
    return returnValue
       // return ""
    }


   
func getSelectedChargerStructures(_ charger: String) throws -> [Charger]?{
    //id받아서 충전기 배열로 반환하는 function
    let urlResponse = try httpRequestHandlerVer2(charger)
    
    if let chargerData = urlResponse.data(using: .utf8)
    {
        let decoder = JSONDecoder()
        
        do {
            let chargerArray = try decoder.decode(Chargers.self, from: chargerData) //json을 디코드해서 데이터화
            // json data를 파싱해서 chargerArray에 넣는다.
            if chargerArray.chargers?.self[0].addr != nil{
                return (chargerArray.chargers.self)!
            }
        } catch {
            print(error.localizedDescription)
        }
    }
        return nil
}
    
var statNm:String?
var statId:String?
var chgerId:String?
var chgerType:String?
var addr:String?
var lat:String?
var lng:String?
var useTime:String?
var busiId:String?
var busiNm:String?
var busiCall:String?
var stat:String?
var statUpdDt:String?
var powerType:String?

func explainChargerStatus(charger: Charger) -> String {
    var returnValue = ""
    if charger == nil {
        return returnValue
    } else{
        returnValue += "\n"
        returnValue += ("충전소 Id : " + charger.statId! + "\n")
        returnValue += ("충전기 Id : " + charger.chgerId! + "\n")
        returnValue += ("충전기 타입 : " + convertType(intValue: charger.chgerType!) + "\n")
        returnValue += ("충전기 파워 타입 : " + convertPowerType(intValue: charger.powerType) + "\n")
        returnValue += ("충전기 상태 : " + convertStatus(intValue: charger.stat!) )
        
        return returnValue
    }
}



/*
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
                    var chargerState:String? = chargerData.stat
                
                    var returnValue:String = ""
                    
                    if chargerState! == "2" {
                        chargerState = "사용 가능"
                    }else if chargerState! == "3"{
                        chargerState = "사용중"
                    } else{
                        chargerState = "점검중"
                    }
                    
                    
                    returnValue += ("충전소 명 : " + stateName! + "\n")
                    returnValue += ("충전소 주소 : " + chargerAddress! + "\n")
                    returnValue += ("이용 시간 : " + chargerUseTime! + "\n")
                //r    eturnValue += ("충전소 업체 : " + chargerBusinessName! + "\n")
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
    
 */
