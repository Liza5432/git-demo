import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let canvas = CanvasView(frame: self.view.bounds)
        canvas.backgroundColor = .systemGray6 // Однотонный фон
        
        // Инициализация модели данных
        canvas.shapeData = ShapeData(
            fillColor: .systemBlue,
            gradientColors: [UIColor.red.cgColor, UIColor.yellow.cgColor],
            shadowColor: UIColor.black.withAlphaComponent(0.5),
            shadowOffset: CGSize(width: 4, height: 4)
        )
        
        self.view.addSubview(canvas)
    }
}
