import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        mapView.addGestureRecognizer(longPress)
    }
    
    func setupMap() {
        mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.9, longitude: 30.3),
                                        span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
        mapView.setRegion(region, animated: true)
    }

    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
                if let city = placemarks?.first?.locality {
                    
                    self?.weatherService.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude) { temp in
                        
                        // --- ЛОКАЛИЗАЦИЯ ТЕКСТА ---
                        
                        // Форматируем строку погоды (вставит градусы вместо %@)
                        let weatherFormat = NSLocalizedString("alert_title_weather", comment: "")
                        let weatherMessage = String(format: weatherFormat, temp)
                        
                        let alert = UIAlertController(title: city, message: weatherMessage, preferredStyle: .alert)
                        
                        // Кнопка "Показать"
                        let showTitle = NSLocalizedString("alert_button_show", comment: "")
                        alert.addAction(UIAlertAction(title: showTitle, style: .default) { _ in
                            let listVC = MuseumListViewController()
                            listVC.targetCity = city
                            self?.present(listVC, animated: true, completion: nil)
                        })
                        
                        // Кнопка "Отмена"
                        let cancelTitle = NSLocalizedString("alert_button_cancel", comment: "")
                        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
                        
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }
}
