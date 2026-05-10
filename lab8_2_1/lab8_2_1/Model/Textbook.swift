import Foundation

struct Textbook: Codable {
    let title: String
    let authors: String
    let image: String        // Исправили с imageName на image
    let description: String
    // Пока убрали topics, так как их нет на скриншоте плиста
}
