import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var activitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBAction func calculateTapped(_ sender: Any) {
        guard let ageText = ageTextField.text, let age = Double(ageText),
              let heightText = heightTextField.text, let height = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText) else {
                resultsLabel.text = "Пожалуйста, введите корректные данные"
                return
            }

        // 1. ИМТ (Формула из Википедии: m / h^2)
        let heightInMeters = height / 100
        let bmi = weight / (heightInMeters * heightInMeters)

        // 2. BMR (Оригинальная формула 1919 года из твоего файла)
        var bmr: Double
        if sexSegmentedControl.selectedSegmentIndex == 0 { // Мужчина
            bmr = 66.4730 + (13.7516 * weight) + (5.0033 * height) - (6.7550 * age)
        } else { // Женщина
            bmr = 655.0955 + (9.5634 * weight) + (1.8496 * height) - (4.6756 * age)
        }

        // 3. AMR (Активный метаболизм) — коэффициенты из твоего файла
        // 1.2; 1.375; 1.55; 1.725; 1.9
        let activityFactors = [1.2, 1.375, 1.55, 1.725, 1.9]
        
        // Безопасно берем индекс, чтобы не выйти за пределы массива
        let selectedIndex = activitySegmentedControl.selectedSegmentIndex
        let factor = activityFactors[activitySegmentedControl.selectedSegmentIndex]
        
        let totalCalories = bmr * factor

        // 4. Вывод результата
        // Используем Int() для калорий и ИМТ, чтобы убрать дробную часть как на скриншоте
        resultsLabel.text = """
        Вы должны потреблять \(Int(totalCalories))
        килокалорий для
        поддержания веса.
        Индекс массы тела \(Int(bmi)).
        """
        
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
