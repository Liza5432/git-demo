import UIKit

class TextbookListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    var textbooks: [Textbook] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
      
        self.title = NSLocalizedString("my_textbooks", comment: "")
        // Загружаем данные
        textbooks = TextbookManager.shared.loadTextbooks()
        
        setupCollectionView()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // Делаем 2 колонки
        let width = (view.frame.width - 60) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        
        // Регистрация класса ячейки
        collectionView.register(TextbookCell.self, forCellWithReuseIdentifier: "BookCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textbooks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! TextbookCell
        let book = textbooks[indexPath.item]
        
        cell.titleLabel.text = book.title
        cell.bookImageView.image = UIImage(named: book.image)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = textbooks[indexPath.item]
        
        // Создаем всплывающее окно
        let title = NSLocalizedString(book.title, comment: "")
                let authors = NSLocalizedString(book.authors, comment: "")
                let description = NSLocalizedString(book.description, comment: "")
                
                let authorsHeader = NSLocalizedString("authors_header", comment: "")
                let descHeader = NSLocalizedString("desc_header", comment: "")
                let closeBtn = NSLocalizedString("alert_close", comment: "")
                
                let alert = UIAlertController(
                    title: title,
                    message: "\n\(authorsHeader):\n\(authors)\n\n\(descHeader):\n\(description)",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: closeBtn, style: .default, handler: nil))
                self.present(alert, animated: true)
            }
}
