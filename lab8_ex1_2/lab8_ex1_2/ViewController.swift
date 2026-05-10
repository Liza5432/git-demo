import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var loginL: UITextField!
    
    
    @IBOutlet weak var passL: UITextField!
    
    
    @IBOutlet weak var registrationView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // Дополнительные поля для регистрации
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var repeatPassField: UITextField!
   
    @IBOutlet weak var rulesSwitch: UISwitch!
   
    
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Изначально скрываем блок регистрации
        registrationView.isHidden = true
        
        // 2. Проверка авторизации при запуске
        let user = UserDefaults.standard
        if user.object(forKey: "login") != nil || user.object(forKey: "pass") != nil {
            print("Пользователь уже в системе")
            self.performSegue(withIdentifier: "closeZone", sender: self)
        }
    }

    // MARK: - Actions
    
    // Переключение между Логином и Регистрацией
    @IBAction func segment(_ sender: UISegmentedControl) {
        let select = sender.selectedSegmentIndex
        
        if select == 0 {
            registrationView.isHidden = true
            actionButton.setTitle("Вход", for: .normal)
        } else {
            registrationView.isHidden = false
            actionButton.setTitle("Регистрация", for: .normal)
        }
    }

    @IBAction func buttonL(_ sender: UIButton) {
        let user = UserDefaults.standard
        let login = loginL.text ?? ""
        let password = passL.text ?? ""
        
        // Проверка на пустые поля
        if !login.isEmpty && !password.isEmpty {
            
            if segmentedControl.selectedSegmentIndex == 1 {
                let email = emailField.text ?? ""
                let repeatPass = repeatPassField.text ?? ""
                
                // Вставка условия из вашего фото
                if rulesSwitch.isOn && !email.isEmpty && password == repeatPass {
                    
                    user.set(login, forKey: "login")
                    user.set(password, forKey: "pass")
                    user.set(email, forKey: "email")
                    user.synchronize()
                    
                    self.performSegue(withIdentifier: "closeZone", sender: self)
                } else {
                    label.text = "Ошибка регистрации"
                }
            }
            
            else {
                let savedLogin = user.string(forKey: "login")
                let savedPass = user.string(forKey: "pass")
                
                if login == savedLogin && password == savedPass {
                    self.performSegue(withIdentifier: "closeZone", sender: self)
                } else {
                    label.text = "Неверный логин или пароль"
                }
            }
        }
    }
}
