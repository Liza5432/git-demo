import UIKit
import MetalKit

class ViewController: UIViewController {
    var mtkView: MTKView!
    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mtkView = MTKView(frame: view.bounds)
        mtkView.device = MTLCreateSystemDefaultDevice()
        view.addSubview(mtkView)
        
        renderer = Renderer(metalView: mtkView)
        mtkView.delegate = renderer
        
        // Жесты
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        mtkView.addGestureRecognizer(pan)
        mtkView.addGestureRecognizer(pinch)
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: mtkView)
        renderer.rotation.y += Float(translation.x) * 0.01
        renderer.rotation.x += Float(translation.y) * 0.01
        gesture.setTranslation(.zero, in: mtkView)
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        renderer.scale *= Float(gesture.scale)
        gesture.scale = 1.0
    }
}
