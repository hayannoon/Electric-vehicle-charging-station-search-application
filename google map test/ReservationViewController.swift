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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        if let name = self.name, let bounty = self.bounty {
            let img = UIImage(named: "charger icon.png")
            imgView.image = img
           nameLabel.text = "Reservation"
           bountyLabel.text = bounty
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
