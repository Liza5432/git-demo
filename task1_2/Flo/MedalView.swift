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

class MedalView: UIImageView {
  lazy var medalImage = self.createMedalImage()

  // swiftlint:disable function_body_length
  func createMedalImage() -> UIImage {
    debugPrint("creating Medal Image")
    let size = CGSize(width: 120, height: 200)

    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
      fatalError("\(#function):\(#line) Failed to get current context.")
    }

    // Gold colors
    let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
    let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
    let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)

    // Add shadow
    let shadow = UIColor.black.withAlphaComponent(0.80)
    let shadowOffset = CGSize(width: 2.0, height: 2.0)
    let shadowBlurRadius: CGFloat = 5

    context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)

    context.beginTransparencyLayer(auxiliaryInfo: nil)

    // Lower ribbon
    let lowerRibbonPath = UIBezierPath()
    lowerRibbonPath.move(to: CGPoint(x: 0, y: 0))
    lowerRibbonPath.addLine(to: CGPoint(x: 40, y: 0))
    lowerRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
    lowerRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
    lowerRibbonPath.close()
    UIColor.red.setFill()
    lowerRibbonPath.fill()

    // Clasp
    let claspPath = UIBezierPath(roundedRect: CGRect(x: 36, y: 62, width: 43, height: 20), cornerRadius: 5)
    claspPath.lineWidth = 5
    darkGoldColor.setStroke()
    claspPath.stroke()

    // Medallion
    let medallionPath = UIBezierPath(ovalIn: CGRect(x: 8, y: 72, width: 100, height: 100))
    context.saveGState()
    medallionPath.addClip()

    let colors = [darkGoldColor.cgColor, midGoldColor.cgColor, lightGoldColor.cgColor] as CFArray
    guard let gradient = CGGradient(
      colorsSpace: CGColorSpaceCreateDeviceRGB(),
      colors: colors,
      locations: [0, 0.51, 1]
    ) else {
      fatalError("Failed to instantiate an instance of \(String(describing: CGGradient.self))")
    }
    context.drawLinearGradient(gradient, start: CGPoint(x: 40, y: 40), end: CGPoint(x: 100, y: 160), options: [])
    context.restoreGState()

    // Create a transform
    // Scale it, and translate it right and down
    var transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    transform = transform.translatedBy(x: 15, y: 30)
    medallionPath.lineWidth = 2.0

    // apply the transform to the path
    medallionPath.apply(transform)
    medallionPath.stroke()

    // Upper ribbon
    let upperRibbonPath = UIBezierPath()
    upperRibbonPath.move(to: CGPoint(x: 68, y: 0))
    upperRibbonPath.addLine(to: CGPoint(x: 108, y: 0))
    upperRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
    upperRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
    upperRibbonPath.close()

    UIColor.blue.setFill()
    upperRibbonPath.fill()

    // Number One

    // Must be NSString to be able to use draw(in:)
    let numberOne = "1" as NSString
    let numberOneRect = CGRect(x: 47, y: 100, width: 50, height: 50)
    guard let font = UIFont(name: "Academy Engraved LET", size: 60) else {
      fatalError("\(#function):\(#line) Failed to instantiate font with name \"Academy Engraved LET\"")
    }
    let numberOneAttributes = [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.foregroundColor: darkGoldColor
    ]
    numberOne.draw(in: numberOneRect, withAttributes: numberOneAttributes)

    context.endTransparencyLayer()

    // This code must always be at the end of the playground
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
      fatalError("\(#function):\(#line) Failed to get an image from current context.")
    }
    UIGraphicsEndImageContext()

    return image
  }

  func showMedal(show: Bool) {
    image = show == true ? medalImage : nil
  }
}
