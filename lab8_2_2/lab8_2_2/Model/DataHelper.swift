import CoreData
import UIKit

class DataHelper {
    static func seedData() {
        // Берем контекст (убедись, что в CoreDataStack он настроен верно)
        let context = CoreDataStack.shared.context
        
        let request: NSFetchRequest<Museum> = Museum.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            
            if count == 0 {
                // ПРОВЕРКА СУЩНОСТИ
                guard let entity = NSEntityDescription.entity(forEntityName: "Museum", in: context) else {
                    print("Ошибка: Сущность Museum не найдена в модели!")
                    return
                }

               
                let m1 = Museum(entity: entity, insertInto: context)
                m1.name = "Бобруйский краеведческий музей"
                m1.city = "Бобруйск"
                m1.lat = 53.1384
                m1.lon = 29.2214
                m1.exhibitions = "История крепости, Природа края"
                
             
                let m2 = Museum(entity: entity, insertInto: context)
                m2.name = "Горецкий этнографический музей"
                m2.city = "Горки"
                m2.lat = 54.2814
                m2.lon = 30.9858
                m2.exhibitions = "Зал этнографии, История БСХА"
                
              
                let m3 = Museum(entity: entity, insertInto: context)
                m3.name = "Дворец Потемкина"
                m3.city = "Кричев"
                m3.lat = 53.6887
                m3.lon = 33.7121
                m3.exhibitions = "Эпоха Екатерины II, Судостроение"

               
                try context.save()
                print("База успешно заполнена!")
            }
        } catch {
            print("Ошибка при заполнении: \(error)")
        }
    }
}
