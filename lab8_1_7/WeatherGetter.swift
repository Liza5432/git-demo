import Foundation

class WeatherGetter {
  
  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
  private let openWeatherMapAPIKey = "YOUR API KEY HERE"
  
  func getWeather(city: String) {
    
    // This is a pretty simple networking task, so the shared session will do.
    let session = URLSession.shared
    
    let weatherRequestURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Minsk&appid=57ba696dc161243fe90d93200795dc04")!
    
    // The data task retrieves the data.
    let dataTask = session.dataTask(with: weatherRequestURL as URL) { (data, response, error) in
      if let error = error {
        // Case 1: Error
        // We got some kind of error while trying to get data from the server.
        print("Error:\n\(error)")
      }
      else {
        // Case 2: Success
        // We got a response from the server!
        print("Raw data:\n\(data!)\n")
        let dataString = String(data: data!, encoding: String.Encoding.utf8)
        print("Human-readable data:\n\(dataString!)")
      }
    }
    
    // The data task is set up...launch it!
    dataTask.resume()
  }
  
}
