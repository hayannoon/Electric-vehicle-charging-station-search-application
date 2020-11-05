//
//  ChargersTableViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/10/26.
//  Copyright © 2020 hayannoon. All rights reserved.
//

import UIKit

class ChargersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
  //  var chargerArray:[Charger]? = nil
    var listCount = 0
    
    var chargerArray: [Charger]? = try! getSelectedChargerStructures(selectedId)!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // DetailViewController 데이터 줄꺼에요
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? TimeSelectViewController
            if let index = sender as? Int {
                vc?.stationId = chargerArray![index].statId //name에는 충전소 id를 준다.
                
                vc?.chargerId = chargerArray![index].chgerId
                //vc?.bounty = explainChargerStatus(charger: chargerArray![index])
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블뷰를 몇개만들지 결정
        return chargerArray!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell
        else{
            return UITableViewCell()
        }
        
        
        //성립 되면 여기로
        
        if chargerArray![indexPath.row].stat! == "2" {
            cell.imgView.image = UIImage(named: "availIcon2.png")
        } else{
            cell.imgView.image = UIImage(named: "unavailIcon2.png")
            
        }
      //  let img = UIImage(named: "charger icon.jpg")
      //  cell.imgView.image = img
        cell.nameLabel.text = chargerArray![indexPath.row].statNm  //nameList[indexPath.row]
        
        cell.bountyLabel.text = try? getAllChargerStatus(chargerArray![indexPath.row].statId!)//"\(bountyList[indexPath.row])"
        
        cell.bountyLabel.text = explainChargerStatus(charger: chargerArray![indexPath.row])
        
        //print(try? getAllChargerStatus(chargerArray![indexPath.row].statId!))
        
        return cell
    }
    
//UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---> \(indexPath.row)")
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
        //옵셔널 바인딩
        
        /*
        if let controller = self.storyboard?.instantiateViewController(identifier: "ReservationViewController"){
         
             // 2. 찾은 컨트롤러로 이동한다. (push Controller)
            self.navigationController?.pushViewController(controller, animated: true)
        }
 */
 
        
    }
}


class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
}

