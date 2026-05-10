//
//  ViewController.swift
//  lab8_1_7
//
//  Created by анус on 5/10/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()

      let weather = WeatherGetter()
        weather.getWeather(city: "Tampa")
    }

}

