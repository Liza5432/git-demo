import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.placeholder = NSLocalizedString("login_placeholder", comment: "")
        loginButton.setTitle(NSLocalizedString("login_button", comment: ""), for: .normal)
        passwordTextField.placeholder = NSLocalizedString("password_placeholder", comment: "")
        // Проверяем: если уже входили, перекидываем сразу
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            DispatchQueue.main.async {
                self.showList(animated: false)
            }
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        guard let name = loginTextField.text, !name.isEmpty else { return }
            
            // Сохраняем данные
            UserDefaults.standard.set(name, forKey: "UserName")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            showList(animated: true)
    }
    func showList(animated: Bool) {
        let listVC = TextbookListViewController()
        listVC.modalPresentationStyle = .fullScreen
        self.present(listVC, animated: animated)
    }
    
}
