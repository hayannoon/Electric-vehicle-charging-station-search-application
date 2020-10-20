//
//  Chargers.swift
//  google map test
//
//  Created by 정민우 on 2020/09/24.
//  Copyright © 2020 hayannoon. All rights reserved.
//

import Foundation
import GoogleMaps



//여기서부터는 구조체정의
struct Chargers:Codable{
    var chargers: [Charger]?
    
    enum CKeys:String,CodingKey{
        case chargers = "chargers"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CKeys.self)
        chargers = try values.decodeIfPresent([Charger].self, forKey: .chargers)
    }
}

struct Charger:Codable
{
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
 
    enum Keys: String,CodingKey{
        case statNm
        case statId
        case chgerId
        case chgerType
        case addr
        case lat
        case lng
        case useTime
        case busiId
        case busiNm
        case busiCall
        case stat
        case statUpdDt
        case powerType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        statNm = try values.decodeIfPresent(String.self, forKey: .statNm)
        statId = try values.decodeIfPresent(String.self, forKey: .statId)
        chgerId = try values.decodeIfPresent(String.self, forKey: .chgerId)
        chgerType = try values.decodeIfPresent(String.self, forKey: .chgerType)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
        useTime = try values.decodeIfPresent(String.self, forKey: .useTime)
        busiId = try values.decodeIfPresent(String.self, forKey: .busiId)
        busiNm = try values.decodeIfPresent(String.self, forKey: .busiNm)
        busiCall = try values.decodeIfPresent(String.self, forKey: .busiCall)
        stat = try values.decodeIfPresent(String.self, forKey: .stat)
        statUpdDt = try values.decodeIfPresent(String.self, forKey: .statUpdDt)
        powerType = try values.decodeIfPresent(String.self, forKey: .powerType)
    }
}




// Creates a marker in the center of the map.
func makeGMS(_ charger: Charger) -> GMSMarker?{
    let maker = GMSMarker()
    
    if(charger.lat != nil && charger.lng != nil){
        let latitude = Double(charger.lat!)
        let longitude = Double(charger.lng!)
        maker.position = CLLocationCoordinate2DMake(latitude!,longitude!)
        maker.title = charger.statId! //+ charger.addr!
        
        maker.snippet = charger.addr!
        /*
        if(charger.statId == "CV000000" || charger.statId == "GN000665"){
            maker.snippet = try? getChargerStatus(charger.statId!)
            
            //maker.snippet = "why not?"
        }
 */
       //try? getChargerStatus(charger.statId!)
      
        //print(charger.addr!)
        return maker
    }
    print("for debug")
        return nil
}



