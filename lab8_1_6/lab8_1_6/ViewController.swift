import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var studentNameTextField: UITextField!
    
    var students = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
     
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext // Используем современный способ доступа к контексту
         
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Students")
  
        do {
            students = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Data loading error: \(error)")
        }

        self.tableView.reloadData()
    }

    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
         
        let student = students[indexPath.row]
        cell.textLabel?.text = student.value(forKey: "name") as? String
         
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
             
            context.delete(students[indexPath.row])
            
            do {
                try context.save()
                students.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("Data removing error: \(error)")
            }
        }
    }


    @IBAction func addStudentButton(_ sender: Any) {
        if studentNameTextField.text == "" || studentNameTextField.text == "Введите данные!" {
            studentNameTextField.text = "Введите данные!"
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
 
            let entity = NSEntityDescription.entity(forEntityName: "Students", in: context)!
            let newObject = NSManagedObject(entity: entity, insertInto: context)
             
            newObject.setValue(studentNameTextField.text, forKey: "name")
  
            do {
                try context.save()
                students.append(newObject)
                studentNameTextField.text = ""
                self.tableView.reloadData()
                self.view.endEditing(true)
            } catch let error as NSError {
                print("Data saving error: \(error)")
            }
        }
    }
}
