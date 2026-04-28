/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@IBDesignable
class GraphView: UIView {
  private enum Constants {
    static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 60
    static let bottomBorder: CGFloat = 50
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 5.0
  }

  @IBInspectable var startColor: UIColor = .red
  @IBInspectable var endColor: UIColor = .green

  var graphPoints: [Int] = [4, 2, 6, 4, 5, 8, 3]

  // swiftlint:disable:next function_body_length
  override func draw(_ rect: CGRect) {
    let width = rect.width
    let height = rect.height

    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: UIRectCorner.allCorners,
      cornerRadii: Constants.cornerRadiusSize
    )
    path.addClip()

    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    let colors = [startColor.cgColor, endColor.cgColor]

    let colorSpace = CGColorSpaceCreateDeviceRGB()

    let colorLocations: [CGFloat] = [0.0, 1.0]

    guard let gradient = CGGradient(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: colorLocations
    ) else {
      return
    }

    var startPoint = CGPoint.zero
    var endPoint = CGPoint(x: 0, y: self.bounds.height)
    context.drawLinearGradient(
      gradient,
      start: startPoint,
      end: endPoint,
      options: []
    )

    let margin = Constants.margin
    let columnXPoint = { (column: Int) -> CGFloat in
      let spacing = (width - margin * 2 - 4) / CGFloat((self.graphPoints.count - 1))
      return CGFloat(column) * spacing + margin + 2
    }

    let topBorder: CGFloat = Constants.topBorder
    let bottomBorder: CGFloat = Constants.bottomBorder
    let graphHeight = height - topBorder - bottomBorder
    guard let maxValue = graphPoints.max() else {
      return
    }
    let columnYPoint = { (graphPoint: Int) -> CGFloat in
      let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
      return graphHeight + topBorder - yPoint
    }

    UIColor.white.setFill()
    UIColor.white.setStroke()

    let graphPath = UIBezierPath()
    graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))

    for i in 1..<graphPoints.count {
      let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
      graphPath.addLine(to: nextPoint)
    }

    context.saveGState()

    guard let clippingPath = graphPath.copy() as? UIBezierPath else {
      return
    }

    clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
    clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
    clippingPath.close()

    clippingPath.addClip()

    let highestYPoint = columnYPoint(maxValue)
    startPoint = CGPoint(x: margin, y: highestYPoint)
    endPoint = CGPoint(x: margin, y: self.bounds.height)

    context.drawLinearGradient(
      gradient,
      start: startPoint,
      end: endPoint,
      options: CGGradientDrawingOptions(rawValue: 0)
    )
    context.restoreGState()

    graphPath.lineWidth = 2.0
    graphPath.stroke()

    for i in 0..<graphPoints.count {
      var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
      point.x -= Constants.circleDiameter / 2
      point.y -= Constants.circleDiameter / 2

      let circle = UIBezierPath(
        ovalIn: CGRect(
          origin: point,
          size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)
        )
      )
      circle.fill()
    }

    let linePath = UIBezierPath()

    linePath.move(to: CGPoint(x: margin, y: topBorder))
    linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))

    linePath.move(to: CGPoint(x: margin, y: graphHeight / 2 + topBorder))
    linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2 + topBorder))

    linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
    linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
    let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
    color.setStroke()

    linePath.lineWidth = 1.0
    linePath.stroke()
  }
}
