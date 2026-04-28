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
class BackgroundView: UIView {
  // 1
  @IBInspectable var lightColor: UIColor = .orange
  @IBInspectable var darkColor: UIColor = .yellow
  @IBInspectable var patternSize: CGFloat = 200

  override func draw(_ rect: CGRect) {
    // 2
    guard let context = UIGraphicsGetCurrentContext() else {
      fatalError("\(#function):\(#line) Failed to get current context.")
    }

    // 3
    context.setFillColor(darkColor.cgColor)

    // 4
    context.fill(rect)


    let drawSize = CGSize(width: patternSize, height: patternSize)

    UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
    guard let drawingContext = UIGraphicsGetCurrentContext() else {
      fatalError("\(#function):\(#line) Failed to get current context.")
    }

    // Set the fill color for the new context
    darkColor.setFill()
    drawingContext.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))

    let trianglePath = UIBezierPath()
    // 1
    trianglePath.move(to: CGPoint(x: drawSize.width / 2, y: 0))
    // 2
    trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height / 2))
    // 3
    trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height / 2))

    // 4
    trianglePath.move(to: CGPoint(x: 0, y: drawSize.height / 2))
    // 5
    trianglePath.addLine(to: CGPoint(x: drawSize.width / 2, y: drawSize.height))
    // 6
    trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))

    // 7
    trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height / 2))
    // 8
    trianglePath.addLine(to: CGPoint(x: drawSize.width / 2, y: drawSize.height))
    // 9
    trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height))

    lightColor.setFill()
    trianglePath.fill()

    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
      fatalError("\(#function):\(#line) Failed to get an image from current context.")
    }
    UIGraphicsEndImageContext()

    UIColor(patternImage: image).setFill()
    context.fill(rect)
  }
}
