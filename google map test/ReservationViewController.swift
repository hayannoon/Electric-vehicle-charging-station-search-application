//
//  SpecificationViewController.swift
//  google map test
//
//  Created by 정민우 on 2020/10/17.
//  Copyright © 2020 hayannoon. All rights reserved.
//
import UIKit
import Foundation

class ReservationViewController : UIViewController ,UITextViewDelegate{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!

    var name: String?
    var bounty: String?
    let timeList = ["00:00 ~ 01:00","01:00 ~ 02:00","02:00 ~ 03:00","03:00 ~ 04:00","04:00 ~ 05:00","05:00 ~ 06:00","06:00 ~ 07:00","07:00 ~ 08:00","08:00 ~ 09:00","09:00 ~ 10:00","10:00 ~ 11:00","11:00 ~ 12:00","12:00 ~ 13:00","13:00 ~ 14:00","14:00 ~ 15:00","15:00 ~ 16:00","16:00 ~ 17:00","17:00 ~ 18:00" , "18:00 ~ 19:00" , "19:00 ~ 20:00" , "20:00 ~ 21:00" , "21:00 ~ 22:00", "22:00 ~ 23:00" , "23:00 ~ 24:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    func updateUI() {
        if let name = self.name, let bounty = self.bounty {
            let img = UIImage(named: "charger icon.png")
            imgView.image = img
           nameLabel.text = "Reservation"
           bountyLabel.text = name + "\n" + bounty
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
