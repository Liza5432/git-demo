import UIKit
import CoreData

class MuseumListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    var targetCity: String = ""
    var museums: [Museum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        loadMuseums()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        // Для Subtitle стиля в коде лучше не регистрировать класс,
        // а создавать ячейку вручную в cellForRowAt
        view.addSubview(tableView)
    }
    
    func loadMuseums() {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Museum> = Museum.fetchRequest()
        request.predicate = NSPredicate(format: "city == %@", targetCity)
        
        museums = (try? context.fetch(request)) ?? []
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return museums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        // Создаем ячейку со стилем subtitle
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        let museum = museums[indexPath.row]
        cell?.textLabel?.text = museum.name
        cell?.detailTextLabel?.text = museum.exhibitions
        
        return cell!
    }
}
