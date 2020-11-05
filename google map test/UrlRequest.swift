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


func httpRequestHandlerGetReservationInfo(_ StatID:String, _ ChargerID:String)  throws -> String {
    let baseUrl = "http://34.64.73.242:3000/api/getReserveInfo/"
    let completedUrl = baseUrl + StatID + "/" + ChargerID
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


func httpRequestHandlerGetReservationInfo(_ StatID:String, _ ChargerID:String)  throws -> [String] {
    let baseUrl = "http://34.64.73.242:3000/api/getReserveInfo/"
    let completedUrl = baseUrl + StatID + "/" + ChargerID
    let url = URL(string: completedUrl)
          let response = try String(contentsOf: url!)
    let firstIndex = response.index(response.startIndex, offsetBy: 2)
    let lastIndex = response.index(response.endIndex, offsetBy: -2)
    let parsedResponse = "\(response[firstIndex..<lastIndex])"
    
    
    var splitedSegment = parsedResponse.components(separatedBy: ",")
    let count = splitedSegment.count
    var i = 0
    print("count : " + "\(count)")
    
    print(splitedSegment)
    
    while i < count-1 {
        var restSegment = splitedSegment[i].components(separatedBy: ":")
        splitedSegment[i] = restSegment[1]
        i += 1
    }
    
    return splitedSegment
}


func sendPost(paramText: String, urlString: String) {
    // paramText를 데이터 형태로 변환
    let paramData = paramText.data(using: .utf8)

    // URL 객체 정의
    let url = URL(string: urlString)

    // URL Request 객체 정의
    var request = URLRequest(url: url!)
    request.httpMethod = "PUT"
    request.httpBody = paramData

    // HTTP 메시지 헤더
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")

    // URLSession 객체를 통해 전송, 응답값 처리
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // 서버가 응답이 없거나 통신이 실패
        if let e = error {
          NSLog("An error has occured: \(e.localizedDescription)")
          return
        }

        // 응답 처리 로직
        DispatchQueue.main.async() {
            // 서버로부터 응답된 스트링 표시
            let outputStr = String(data: data!, encoding: String.Encoding.utf8)
            print("result: \(outputStr!)")
        }
      
    }
    // POST 전송
    task.resume()
}

func makeReservation(stid: String, chgid: String, time:String) {
let paramText = "statId=\(stid)&chgerId=\(chgid)&times=\(time)"
sendPost(paramText: paramText, urlString: "http://34.64.73.242:3000/api/reserves")
}

func cancelReservation(stid: String, chgid: String, time:String){
let paramText = "statId=\(stid)&chgerId=\(chgid)&times=\(time)"
sendPost(paramText: paramText, urlString: "http://34.64.73.242:3000/api/cancel")
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
