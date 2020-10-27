//
//  ChargersTableViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/10/26.
//  Copyright © 2020 hayannoon. All rights reserved.
//

import UIKit

class ChargersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let nameList = ["brook", "chopper", "franky", "luffy", "nami", "robin", "sanji", "zoro"]
    let bountyList = [33000000, 50, 44000000, 300000000, 16000000, 80000000, 77000000, 120000000]
    var chargerArray:[Charger]? = nil
    var listCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블뷰를 몇개만들지 결정
        do{
        chargerArray = try getSelectedChargerStructures(selectedId)!
        } catch
        {
            print("Error")
        }
        return chargerArray!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell
        else{
            return UITableViewCell()
        }
        
       
        do{
        chargerArray = try getSelectedChargerStructures(selectedId)!
        } catch
        {
            print("Error")
        }
        
        var nameList:[String]
        
        
        //성립 되면 여기로
        //let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
        let img = UIImage(named: "charger icon.jpg")
        cell.imgView.image = img
        cell.nameLabel.text = chargerArray![indexPath.row].statNm //nameList[indexPath.row]
        
        cell.bountyLabel.text = "\(bountyList[indexPath.row])"
        return cell
    }
    
//UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---> \(indexPath.row)")
        
        //옵셔널 바인딩
        if let controller = self.storyboard?.instantiateViewController(identifier: "SpecificationViewController"){
         
             // 2. 찾은 컨트롤러로 이동한다. (push Controller)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}


class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
}

