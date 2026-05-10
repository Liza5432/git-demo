import UIKit

class TextbookCell: UICollectionViewCell {
    
    let bookImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Настройка картинки
        bookImageView.contentMode = .scaleAspectFill
        bookImageView.clipsToBounds = true
        bookImageView.layer.cornerRadius = 10
        bookImageView.backgroundColor = .systemGray6
        
        // Настройка текста
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        
        // Установка размеров элементов внутри ячейки
        bookImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 40)
        titleLabel.frame = CGRect(x: 0, y: frame.height - 35, width: frame.width, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
