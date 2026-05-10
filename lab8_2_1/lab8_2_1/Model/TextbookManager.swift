import Foundation

class TextbookManager {
    static let shared = TextbookManager()
    
    func loadTextbooks() -> [Textbook] {
        // Если твой файл называется иначе, замени "Textbooks" на свое название
        guard let url = Bundle.main.url(forResource: "Textbooks", withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            print("Ошибка: Файл .plist не найден")
            return []
        }
        
        do {
            let decoder = PropertyListDecoder()
            return try decoder.decode([Textbook].self, from: data)
        } catch {
            print("Ошибка декодирования: \(error)")
            return []
        }
    }
}
