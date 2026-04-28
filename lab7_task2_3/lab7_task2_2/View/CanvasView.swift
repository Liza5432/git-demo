import UIKit

enum ShapeType {
    case hexagram, rhomb, union, subtraction
}

class CanvasView: UIView {
    var shapeData: ShapeData?
    var type: ShapeType = .hexagram
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let drawRect = self.bounds.insetBy(dx: 15, dy: 15)
        
        switch type {
        case .hexagram:
            let path = createHexagram(in: drawRect)
            drawShape(path: path, context: context, useGradient: false)
            
        case .rhomb:
            let path = createRhomb(in: drawRect)
            drawShape(path: path, context: context, useGradient: true)
            
        case .union:
            // РИСУЕМ КАК В ТВОЕМ ПРИМЕРЕ
            let combinedPath = UIBezierPath()
            let starRect = CGRect(x: 10, y: 10, width: 80, height: 80)
                combinedPath.append(createHexagram(in: starRect))
                
                // 2. Рисуем Ромб — он должен быть МЕНЬШЕ (например, 50x50)
                // Чтобы отцентрировать 50x50 внутри 100x100: (100 - 50) / 2 = 25
                let rhombRect = CGRect(x: 25, y: 25, width: 48, height: 48)
                combinedPath.append(createRhomb(in: rhombRect))
            shapeData?.fillColor.setFill()
            combinedPath.fill()
            
            // Добавим обводку, чтобы фигура была видна четко
            
            
        case .subtraction:
            let path = createHexagram(in: drawRect)
            let hole = createRhomb(in: drawRect.insetBy(dx: 25, dy: 25))
            path.append(hole)
            path.usesEvenOddFillRule = true
            UIColor.systemOrange.setFill()
            path.fill()
        }
    }
    
    // Функции createHexagram и createRhomb (оставляем как были)
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
