//
//  ResultViewController.swift
//  task5
//
//  Created by анус on 4/20/26.
//

import UIKit

class ResultViewController: UIViewController {
    
    var salaryAmount: Double = 0.0
        var selectedIdx: Int = 0

        // Твои названия из примера
        @IBOutlet weak var allowanceLable: UILabel!
        @IBOutlet weak var allowanceText: UILabel!

        override func viewDidLoad() {
            super.viewDidLoad()
            displayResults()
        }

        func displayResults() {
            var rate = 0.0
            
            // Логика: 0 сегмент - 2%, 1 сегмент - 5%
            if selectedIdx == 0 {
                rate = 0.02
            } else {
                rate = 0.05
            }

            let bonus = salaryAmount * rate
            let total = salaryAmount + bonus

            // Вывод в твои Label
            allowanceLable.text = String(format: "Надбавка: %.2f", bonus)
            allowanceText.text = String(format: "Итого: %.2f", total)
        }

        // Кнопка возврата (напиши её отдельно от viewDidLoad)
    
}
