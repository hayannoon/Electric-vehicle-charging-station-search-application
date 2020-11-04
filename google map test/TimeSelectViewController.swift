//
//  TimeSelectViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/10/30.
//  Copyright © 2020 hayannoon. All rights reserved.
//

import UIKit

class TimeSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   // @IBOutlet var timetableView: UITableView!
    
    var stationId: String?
    var chargerId: String?
    var httpGetList: [String]?
    
    var k = 0
    
    
    let timeList = ["00:00 - 01:00", "01:00 - 02:00" , "02:00 - 03:00", "03:00 - 04:00", "04:00 - 05:00" , "05:00 - 06:00", "06:00 - 07:00" , "07:00 - 08:00" , "08:00 - 09:00" , "09:00 - 10:00" , "10:00 - 11:00" , "11:00 - 12:00" , "12:00 - 13:00" , "13:00 - 14:00", "14:00 - 15:00", "15:00 - 16:00", "16:00 - 17:00" , "17:00 - 18:00" , "18:00 - 19:00", "19:00 - 20:00" , "20:00 - 21:00", "21:00 - 22:00", "22:00 - 23:00", "23:00 - 24:00"]
    
    var availableTime = [0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Why not?")

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? timeCell
        else{
            return UITableViewCell()
        }
        cell.timeLabel.text = timeList[indexPath.row] //시간으로 표 채운다.
        let newTable:[String] = try! httpRequestHandlerGetReservationInfo(stationId!, chargerId!)
        
        if newTable[indexPath.row] == "1" {
            cell.backgroundColor = UIColor.red
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---> \(indexPath.row)")
        print(stationId!)
        print(chargerId!)
        let newTable:[String] = try! httpRequestHandlerGetReservationInfo(stationId!, chargerId!)
        
        if newTable[indexPath.row] == "1" {
            //예약이 불가능한 경우 실행
            let alert = UIAlertController(title: "예약 불가", message: "이미 사용중이거나 예약되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print("3번이 눌림")
        } else{
            //예약이 가능한 경우 실행
            
            let selectedTime = indexPath.row
            //makeReservation(stid: stationId!, chgid: chargerId!, time: "\(indexPath.row)" )
            let alert = UIAlertController(title: "예약 확인", message: ("\(selectedTime)" + " ~ " + " \(selectedTime+1)" + " \n예약 하시겠습니까?"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(action) in
                
                makeReservation(stid: self.stationId!, chgid: self.chargerId!, time: "\(indexPath.row)" )
                
            }))
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }
         //여기서 예약 API 날리면 됨
    }
    
}

class timeCell: UITableViewCell {
    @IBOutlet weak var timeLabel : UILabel!
}
