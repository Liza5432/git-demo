import UIKit

class ViewController: UIViewController {
    
    let blueData = ShapeData(
        fillColor: .systemBlue,
        gradientColors: [UIColor.red.cgColor, UIColor.yellow.cgColor],
        shadowColor: UIColor.black.withAlphaComponent(0.5),
        shadowOffset: CGSize(width: 4, height: 4)
    )
    let config = AnimationConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupAnimations()
    }

    func setupAnimations() {
        // 1. ПЕРЕМЕЩЕНИЕ
        let v1 = addShape(type: .hexagram, x: 20, y: 80)
        UIView.animate(withDuration: config.duration, delay: 0, options: [.autoreverse, .repeat], animations: {
            v1.frame.origin.x = 220
        })

        // 2. ВРАЩЕНИЕ
        let v2 = addShape(type: .rhomb, x: 20, y: 210)
        UIView.animate(withDuration: config.duration, delay: 0, options: [.repeat, .curveLinear], animations: {
            v2.transform = CGAffineTransform(rotationAngle: .pi)
        })

        // 3. МАСШТАБИРОВАНИЕ
        let v3 = addShape(type: .subtraction, x: 20, y: 340)
        UIView.animate(withDuration: config.duration, delay: 0, options: [.autoreverse, .repeat], animations: {
            v3.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })

        // 4. ПРОЗРАЧНОСТЬ (Исчезает фигура Union как в твоем коде)
        let v4 = addShape(type: .union, x: 20, y: 470)
        UIView.animate(withDuration: config.duration, delay: 0, options: [.autoreverse, .repeat], animations: {
            v4.alpha = 0.0
        })

        // 5. НАЛОЖЕНИЕ (ПЕРЕНЕСЕНО ВПРАВО)
        // Ставим начальную позицию X: 250, чтобы она была справа
        let v5 = addShape(type: .hexagram, x: 250, y: 600)
        UIView.animate(withDuration: config.duration, delay: 0, options: [.autoreverse, .repeat], animations: {
            // Двигаем влево на 150 и вращаем
            let move = CGAffineTransform(translationX: 150, y: 0)
            let rotate = CGAffineTransform(rotationAngle: .pi)
            v5.transform = move.concatenating(rotate)
        })
    }

    func addShape(type: ShapeType, x: CGFloat, y: CGFloat) -> CanvasView {
        // Размер 100x100
        let shape = CanvasView(frame: CGRect(x: x, y: y, width: 100, height: 100))
        shape.backgroundColor = .clear
        shape.type = type
        shape.shapeData = blueData
        self.view.addSubview(shape)
        return shape
    }
}
