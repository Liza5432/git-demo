//
//  ViewController.swift
//  lab7_task1_4
//
//  Created by анус on 4/26/26.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var gestureIndicator: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        gestureIndicator.isUserInteractionEnabled = true
    
        gestureIndicator.textAlignment = NSTextAlignment.center; gestureIndicator.numberOfLines = 2
        gestureIndicator.text = "Используйте жесты в этой области"; gestureIndicator.backgroundColor = UIColor.yellow
    }

    @IBAction func longPress(_ sender: Any) {
        gestureIndicator.text = "Жест: долгое нажатие\n Цвет фона: оранжевый"; gestureIndicator.backgroundColor = UIColor.orange
    }
    
    @IBAction func tap(_ sender: Any) {
        gestureIndicator.text = "Жест: касание\n Цвет фона: зеленый";
        gestureIndicator.backgroundColor = UIColor.green
    }
    @IBAction func pinch(_ sender: Any) {
        gestureIndicator.text = "Жест: масштабирование\n Цвет фона: красный"; gestureIndicator.backgroundColor = UIColor.red
    }
    @IBAction func rotation(_ sender: Any) {
        gestureIndicator.text = "Жест: вращение\n Цвет фона: синий"; gestureIndicator.backgroundColor = UIColor.blue
    }
    @IBAction func swipe(_ sender: Any) {
        gestureIndicator.text = "Жест: смахивание\n Цвет фона: серый"
        gestureIndicator.backgroundColor = UIColor.lightGray
    }
}

