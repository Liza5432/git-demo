import Foundation

class WeatherService {
  
    let apiKey = "3b301930-51b4-492b-b8f0-97720178c4d4"
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (String) -> Void) {
       
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        
        request.addValue(apiKey, forHTTPHeaderField: "X-Yandex-Weather-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                DispatchQueue.main.async { completion("!!") }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion("--") }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let fact = json["fact"] as? [String: Any],
                   let temp = fact["temp"] as? Int {
                    
                    DispatchQueue.main.async {
                        completion("\(temp)°C")
                    }
                } else {
                    print("Ошибка парсинга JSON или неверный ключ")
                    DispatchQueue.main.async { completion("--") }
                }
            } catch {
                print("Ошибка JSON: \(error.localizedDescription)")
                DispatchQueue.main.async { completion("--") }
            }
        }.resume()
    }
}
