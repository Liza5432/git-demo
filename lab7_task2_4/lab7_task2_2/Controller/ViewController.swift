import UIKit

class ViewController: UIViewController {
    
    var canvas: CanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Инициализируем Canvas программно на весь экран
        canvas = CanvasView(frame: self.view.bounds)
        canvas.backgroundColor = .systemGray6
        
        // Загружаем начальные данные в модель
        canvas.shapeData = ShapeData(
            fillColor: .systemBlue,
            gradientColors: [UIColor.red.cgColor, UIColor.yellow.cgColor],
            shadowColor: UIColor.black.withAlphaComponent(0.5),
            shadowOffset: CGSize(width: 4, height: 4),
            backgroundImage: nil
        )
        
        self.view.addSubview(canvas)
    }

    // MARK: - IBActions (Сюда подключаются жесты из Storyboard)

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        // Касание - фон 3
        canvas.shapeData?.backgroundImage = UIImage(named: "bg3")
    }
    
    @IBAction func long(_ sender: UILongPressGestureRecognizer) {
        // Долгое нажатие - фон 4
        if sender.state == .began {
            canvas.shapeData?.backgroundImage = UIImage(named: "bg4")
        }
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        // Масштабирование - фон 2
        if sender.state == .began || sender.state == .changed {
            canvas.shapeData?.backgroundImage = UIImage(named: "bg2")
        }
    }
    
    @IBAction func rotation(_ sender: UIRotationGestureRecognizer) {
        // Вращение - фон 1
        if sender.state == .began || sender.state == .changed {
            canvas.shapeData?.backgroundImage = UIImage(named: "bg1")
        }
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        // Смахивание - фон 5
        canvas.shapeData?.backgroundImage = UIImage(named: "bg5")
    }
}
