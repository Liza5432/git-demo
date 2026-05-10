//
//  ViewController.swift
//  lab8_ex1
//
//  Created by анус on 5/9/26.
//

import UIKit
class ViewController: UIViewController {
    let myItemKey = "myItem"
    var myItemValue: String? = nil

    @IBOutlet weak var txtValue: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    func loadData(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths[0] as! String
        let path = documentDirectory.appending("myData.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)){
            if let bundlePath = Bundle.main.path(forResource: "myData", ofType: "plist"){
                let result = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle file myData.plist is -> \(String(describing: result?.description))")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }catch{
                    print("copy failure.")
                }
            }else{
                print("file myData.plist not found.")
            }
        }else{
            print("file myData.plist already exits at path.")
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("load myData.plist is ->\(String(describing: resultDictionary?.description))")
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict{
            myItemValue = dict.object(forKey: myItemKey) as! String?
            txtValue.text = myItemValue
        }else{
            print("load failure.")
        }
    }
}

