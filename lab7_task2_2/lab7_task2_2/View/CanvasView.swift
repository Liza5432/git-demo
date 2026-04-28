import UIKit

class CanvasView: UIView {
    
    var shapeData: ShapeData?
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 1. Рисуем Гексаграмму (Шестиконечная звезда) с тенью
        let hexagramPath = createHexagram(in: CGRect(x: 50, y: 50, width: 100, height: 100))
        drawShape(path: hexagramPath, context: context, useGradient: false)
        
        // 2. Рисуем Ромб с градиентом
        let rhombPath = createRhomb(in: CGRect(x: 200, y: 50, width: 100, height: 100))
        drawShape(path: rhombPath, context: context, useGradient: true)
        
        // 3. ОБЪЕДИНЕНИЕ (Union)
        let combinedPath = UIBezierPath()
        combinedPath.append(createHexagram(in: CGRect(x: 50, y: 200, width: 100, height: 100)))
        combinedPath.append(createRhomb(in: CGRect(x: 70, y: 220, width: 60, height: 60)))
        shapeData?.fillColor.setFill()
        combinedPath.fill()
        
        // 4. ВЫЧИТАНИЕ (Subtracting)
        // В Swift это делается через Fill Rule .evenOdd
        let subtractedPath = createHexagram(in: CGRect(x: 200, y: 200, width: 120, height: 120))
        let hole = createRhomb(in: CGRect(x: 235, y: 235, width: 50, height: 50))
        subtractedPath.append(hole)
        subtractedPath.usesEvenOddFillRule = true // Эффект вычитания
        UIColor.systemOrange.setFill()
        subtractedPath.fill()
    }
    
    // Создание гексаграммы (два треугольника)
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
            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
            path.close()
        }
        addTriangle(isUpsideDown: false)
        addTriangle(isUpsideDown: true)
        return path
    }
    
    // Создание ромба
    func createRhomb(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // Верх
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // Право
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // Низ
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY)) // Лево
        path.close()
        return path
    }
    
    func drawShape(path: UIBezierPath, context: CGContext, useGradient: Bool) {
        context.saveGState()
        
        // Добавляем тень
        context.setShadow(offset: shapeData?.shadowOffset ?? .zero, blur: 5, color: shapeData?.shadowColor.cgColor)
        
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
