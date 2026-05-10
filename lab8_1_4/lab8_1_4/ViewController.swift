import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
   
    
    // 1. создаем locationManager
    let locationManager = CLLocationManager()
    
    // Словарь для отслеживания времени входа
    var monitoredRegions: [String: Date] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 2. настройка locationManager
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 3. настройка mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        // 4. настройка тестовых данных
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 1. статус не определен
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        // 2. в авторизации отказано
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        // 3. авторизация получена
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func setupData() {
        // 1. проверка возможности мониторинга регионов
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {

            // 2. данные региона
            let title = "Lorrenzillo's"
            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
            let regionRadius = 300.0

            // 3. настройка региона
            let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)

            // 4. настройка аннотации
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate
            restaurantAnnotation.title = "\(title)"
            mapView.addAnnotation(restaurantAnnotation)

            // 5. настройка круга
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            mapView.addOverlay(circle)
        }
        else {
            print("System can't track regions")
        }
    }

    // 6. отрисовка круга
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.strokeColor = .red
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    // MARK: - CLLocationManagerDelegate

    // 1. пользователь вошел в регион
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert("enter \(region.identifier)")
        
        // 2.1. Добавляем время входа
        monitoredRegions[region.identifier] = Date()
    }

    // 2. пользователь вышел из региона
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("exit \(region.identifier)")
        
        // 2.2 Удаляем время входа
        monitoredRegions.removeValue(forKey: region.identifier)
    }

    // 3. Логика обновления регионов
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegions()
    }

    
    func updateRegions() {
        // 1.
        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []
        
        // 2.
        for regionIdentifier in monitoredRegions.keys {
            // 3.
            if Date().timeIntervalSince(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                showAlert("Thanks for visiting our restaurant")
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        // 4.
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValue(forKey: regionIdentifier)
        }
    }
    
    // Вспомогательный метод для алертов
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Protocols
protocol RegionProtocol {
    var coordinate: CLLocation {get}
    var radius: CLLocationDistance {get}
    var identifier: String {get}

    func updateRegion()
}

protocol RegionDelegateProtocol {
    func didEnterRegion()
    func didExitRegion()
}
