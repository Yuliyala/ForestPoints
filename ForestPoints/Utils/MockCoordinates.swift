import CoreLocation

struct MockCoordinates {
    static let bayAreaLocations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        CLLocationCoordinate2D(latitude: 37.8715, longitude: -122.2730),
        CLLocationCoordinate2D(latitude: 37.8044, longitude: -122.2711),
        CLLocationCoordinate2D(latitude: 37.9358, longitude: -122.3477),
        CLLocationCoordinate2D(latitude: 37.9735, longitude: -122.5311),
        CLLocationCoordinate2D(latitude: 37.9061, longitude: -122.5450),
        CLLocationCoordinate2D(latitude: 37.8591, longitude: -122.4852),
        CLLocationCoordinate2D(latitude: 37.6879, longitude: -122.4702),
        CLLocationCoordinate2D(latitude: 37.6138, longitude: -122.4869),
        CLLocationCoordinate2D(latitude: 37.5630, longitude: -122.3255),
        CLLocationCoordinate2D(latitude: 37.4852, longitude: -122.2364),
        CLLocationCoordinate2D(latitude: 37.4419, longitude: -122.1430),
        CLLocationCoordinate2D(latitude: 37.6688, longitude: -122.0808),
        CLLocationCoordinate2D(latitude: 37.7249, longitude: -122.1603),
        CLLocationCoordinate2D(latitude: 37.8534, longitude: -122.2011),
        CLLocationCoordinate2D(latitude: 37.9063, longitude: -122.0648),
        CLLocationCoordinate2D(latitude: 37.5485, longitude: -121.9886),
        CLLocationCoordinate2D(latitude: 37.5933, longitude: -122.0184),
        CLLocationCoordinate2D(latitude: 37.3861, longitude: -122.0839),
        CLLocationCoordinate2D(latitude: 37.3688, longitude: -122.0363),
        CLLocationCoordinate2D(latitude: 37.3541, longitude: -121.9552),
        CLLocationCoordinate2D(latitude: 37.3382, longitude: -121.8863),
        CLLocationCoordinate2D(latitude: 37.3230, longitude: -122.0322),
        CLLocationCoordinate2D(latitude: 37.2358, longitude: -121.9950),
        CLLocationCoordinate2D(latitude: 37.4323, longitude: -121.9018),
        CLLocationCoordinate2D(latitude: 37.6624, longitude: -121.8747),
        CLLocationCoordinate2D(latitude: 37.7022, longitude: -121.9358),
        CLLocationCoordinate2D(latitude: 37.6819, longitude: -121.7681),
        CLLocationCoordinate2D(latitude: 37.5585, longitude: -122.2711),
        CLLocationCoordinate2D(latitude: 37.5840, longitude: -122.3661)
    ]
    
    static let cityNames: [String] = [
        "San Francisco",
        "Berkeley",
        "Oakland",
        "Richmond",
        "San Rafael",
        "Mill Valley",
        "Sausalito",
        "Daly City",
        "Pacifica",
        "San Mateo",
        "Redwood City",
        "Palo Alto",
        "Hayward",
        "San Leandro",
        "Danville",
        "Walnut Creek",
        "Fremont",
        "Union City",
        "Mountain View",
        "Sunnyvale",
        "Santa Clara",
        "San Jose",
        "Cupertino",
        "Los Gatos",
        "Milpitas",
        "Pleasanton",
        "Dublin",
        "Livermore",
        "Foster City",
        "Burlingame"
    ]
    
    static func random() -> CLLocationCoordinate2D {
        bayAreaLocations.randomElement() ?? bayAreaLocations[0]
    }
    
    static func randomCityName() -> String {
        cityNames.randomElement() ?? "San Francisco"
    }
}

