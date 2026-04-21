//
//  ViewController.swift
//  lab6_task1
//
//  Created by анус on 4/14/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
       
        super.viewDidLoad()
     infoLabel.textColor = UIColor.black
     infoLabel.text = "Background image:bg2.jpg"
     view.backgroundColor = UIColor(patternImage:UIImage(named: "bg2")!)
    }

    @IBAction func backgroundSwitchTapped(_ sender: Any) {
        if backgroundSwitch.isOn
        {
        infoLabel.text = "Background image: bg1.jpg"
            view.backgroundColor = UIColor(patternImage:UIImage(named:"bg1")!)
        }
        else
        {
        infoLabel.text="Background image: bg2.jpg"
            view.backgroundColor=UIColor(patternImage:UIImage (named:"bg2")!)
        }
    
    }
}

