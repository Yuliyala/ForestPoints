import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private var isUpdating = false
    private var lastLocationUpdate: Date?
    private let updateThreshold: TimeInterval = 5.0
    
    override private init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
    }
    
    deinit {
        stopUpdating()
    }
    
    func requestPermission() {
        guard authorizationStatus == .notDetermined else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        guard !isUpdating else { return }
        isUpdating = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        guard isUpdating else { return }
        isUpdating = false
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentCoordinatesString() -> String {
        guard let location = currentLocation else {
            return "37.7749, -122.4194"
        }
        return String(format: "%.4f, %.4f", location.latitude, location.longitude)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let now = Date()
        if let lastUpdate = lastLocationUpdate,
           now.timeIntervalSince(lastUpdate) < updateThreshold {
            return
        }
        
        lastLocationUpdate = now
        currentLocation = location.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied, .restricted:
            stopUpdating()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("❌ Location access denied")
            case .locationUnknown:
                print("⚠️ Location temporarily unknown, will retry")
            default:
                print("❌ Location error: \(error.localizedDescription)")
            }
        }
    }
}

