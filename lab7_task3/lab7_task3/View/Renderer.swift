import MetalKit
import simd


class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int = 0
    
    // Параметры для управления из ViewController
    var rotation = SIMD3<Float>(0, 0, 0)
    var scale: Float = 1.0

    init?(metalView: MTKView) {
        guard let device = metalView.device else { return nil }
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        buildPipelineState(metalView: metalView)
        buildBuffers()
    }

    func buildPipelineState(metalView: MTKView) {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Не удалось найти Metal Library")
        }
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        
        let vertexDescriptor = MTLVertexDescriptor()
        // Позиция
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        // Цвет
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Ошибка создания Pipeline State: \(error)")
        }
    }

    func buildBuffers() {
        var vertices: [Vertex] = []
        let segments = 64
        let tubeSegments = 32
        let radius: Float = 0.5
        let tubeRadius: Float = 0.2

        // Внутренняя функция для создания вершины с исправлением шва
        func getV(i: Int, j: Int) -> Vertex {
            // Используем %, чтобы i+1 превратилось в 0 на стыке
            let effectiveI = i % segments
            let effectiveJ = j % tubeSegments
            
            let u = Float(effectiveI) / Float(segments) * 2.0 * .pi
            let v = Float(effectiveJ) / Float(tubeSegments) * 2.0 * .pi
            
            let x = (radius + tubeRadius * cos(v)) * cos(u)
            let y = (radius + tubeRadius * cos(v)) * sin(u)
            let z = tubeRadius * sin(v)
            
            // Цвета вычисляем по оригинальным индексам для плавности градиента
            let colorU = Float(i) / Float(segments) * 2.0 * .pi
            let colorV = Float(j) / Float(tubeSegments) * 2.0 * .pi
            
            return Vertex(position: [x, y, z],
                          color: [abs(cos(colorU)), abs(sin(colorV)), 1.0, 1.0])
        }

        for i in 0..<segments {
            for j in 0..<tubeSegments {
                let v1 = getV(i: i, j: j)
                let v2 = getV(i: i+1, j: j)
                let v3 = getV(i: i, j: j+1)
                let v4 = getV(i: i+1, j: j+1)
                
                // Добавляем два треугольника (quad)
                vertices.append(contentsOf: [v1, v2, v3, v3, v2, v4])
            }
        }
        
        vertexCount = vertices.count
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.stride,
                                         options: [])
    }
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let pipelineState = pipelineState else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // Создаем финальную матрицу
        var uniforms = Uniforms(modelViewProjectionMatrix: matrix_float4x4(rotation: rotation, scale: scale))
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}

// MARK: - Расширение для работы с матрицами
extension matrix_float4x4 {
    init(rotation: SIMD3<Float>, scale: Float) {
        let x = rotation.x
        let y = rotation.y
        
        // Масштабирование
        let sc = matrix_float4x4(diagonal: [scale, scale, scale, 1])
        
        // Поворот по X
        let rotX = matrix_float4x4(SIMD4(1, 0, 0, 0),
                                   SIMD4(0, cos(x), sin(x), 0),
                                   SIMD4(0, -sin(x), cos(x), 0),
                                   SIMD4(0, 0, 0, 1))
        
        // Поворот по Y
        let rotY = matrix_float4x4(SIMD4(cos(y), 0, -sin(y), 0),
                                   SIMD4(0, 1, 0, 0),
                                   SIMD4(sin(y), 0, cos(y), 0),
                                   SIMD4(0, 0, 0, 1))
        
        self = rotX * rotY * sc
    }
}
