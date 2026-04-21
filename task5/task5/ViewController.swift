import UIKit

class ViewController: UIViewController {

    // Ссылки на элементы (подключи их в Storyboard как Outlet)
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var experienceSegment: UISegmentedControl!

    // Пустые Action, если они тебе нужны для отслеживания ввода
    @IBAction func salaryText(_ sender: Any) {
        // Вызывается при изменении текста
    }
    
    @IBAction func SegmentControl(_ sender: Any) {
        // Вызывается при переключении сегмента
    }

    // Кнопка расчета
    @IBAction func calculate(_ sender: Any) {
       performSegue(withIdentifier: "showResult", sender: nil)
    }

    // Передача данных на второй экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultViewController {
            // Берем число из поля ввода
            
            let salary = Double(salaryTextField.text ?? "") ?? 0.0
            
            // Передаем во второй контроллер
            resultVC.salaryAmount = salary
            resultVC.selectedIdx = experienceSegment.selectedSegmentIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
