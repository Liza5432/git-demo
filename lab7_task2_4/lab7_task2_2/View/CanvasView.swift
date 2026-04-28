import UIKit

class CanvasView: UIView {
    var shapeData: ShapeData? {
        didSet {
            setNeedsDisplay() // Перерисовываем каждый раз, когда меняется модель
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // --- ПАРАМЕТРЫ ЭКРАНА ---
        let screenWidth = bounds.width
        
        // 1. Рисуем Гексаграмму (Звезду) - смещаем выше и делаем чуть меньше
        let hexSize: CGFloat = 100
        let hexRect = CGRect(x: (screenWidth - hexSize) / 2, y: 80, width: hexSize, height: hexSize)
        let hexPath = createHexagram(in: hexRect)
        drawShape(path: hexPath, context: context, useGradient: false)
        
        // 2. Рисуем РОМБ (Интерактивная фигура) - ЦЕНТРИРУЕМ И УВЕЛИЧИВАЕМ
        let rhombSize: CGFloat = 280 // Сделали побольше
        let rhombRect = CGRect(
            x: (screenWidth - rhombSize) / 2, // Центровка по горизонтали
            y: 250,                           // Сместили пониже
            width: rhombSize,
            height: rhombSize
        )
        let rhombPath = createRhomb(in: rhombRect)
        
        context.saveGState()
        if let bgImage = shapeData?.backgroundImage {
            // Если жест сработал и картинка есть в модели
            rhombPath.addClip() // Обрезаем картинку по форме ромба
            
            // Отрисовка с сохранением пропорций (Aspect Fill)
            let imageSize = bgImage.size
            let scale = max(rhombRect.width / imageSize.width, rhombRect.height / imageSize.height)
            let width = imageSize.width * scale
            let height = imageSize.height * scale
            let drawRect = CGRect(
                x: rhombRect.midX - width/2,
                y: rhombRect.midY - height/2,
                width: width,
                height: height
            )
            
            bgImage.draw(in: drawRect)
        } else {
            // Если жеста еще не было - рисуем обычный градиент
            drawShape(path: rhombPath, context: context, useGradient: true)
        }
        context.restoreGState()
    }
    
    // Вспомогательные функции отрисовки (остаются без изменений)
    func createHexagram(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let side = rect.width
        let center = CGPoint(x: rect.midX, y: rect.midY)
        func addTriangle(isUpsideDown: Bool) {
            let altitude = side * sqrt(3) / 2
            let yOffset = altitude / 3
            let p1 = CGPoint(x: center.x, y: isUpsideDown ? center.y + 2*yOffset : center.y - 2*yOffset)
            let p2 = CGPoint(x: center.x - side/2, y: isUpsideDown ? center.y - yOffset : center.y + yOffset)
            let p3 = CGPoint(x: center.x + side/2, y: isUpsideDown ? center.y - yOffset : center.y + yOffset)
            path.move(to: p1); path.addLine(to: p2); path.addLine(to: p3); path.close()
        }
        addTriangle(isUpsideDown: false); addTriangle(isUpsideDown: true)
        return path
    }
    
    func createRhomb(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.close()
        return path
    }
    func drawShape(path: UIBezierPath, context: CGContext, useGradient: Bool) {
            context.saveGState()
            context.setShadow(offset: shapeData?.shadowOffset ?? .zero, blur: 10, color: shapeData?.shadowColor.cgColor)
            if useGradient {
                path.addClip()
                let colors = (shapeData?.gradientColors ?? []) as CFArray
                let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1])!
                context.drawLinearGradient(gradient, start: CGPoint(x: path.bounds.minX, y: path.bounds.minY), end: CGPoint(x: path.bounds.maxX, y: path.bounds.maxY), options: [])
            } else {
                shapeData?.fillColor.setFill()
                path.fill()
            }
            context.restoreGState()
        }
    }
