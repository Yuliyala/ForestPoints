import SwiftUI
import MapKit

struct MapView: View {
    @State private var points: [ForestPoint] = []
    @State private var showAddPoint = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Forest Points\nCatalog")
            
            Map(coordinateRegion: $region, annotationItems: points) { point in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: point.parseCoordinates().latitude,
                    longitude: point.parseCoordinates().longitude
                )) {
                    MapPinView(point: point)
                }
            }
            .frame(height: 362)
            .cornerRadius(20)
            .padding(.top, 8)
            
            Button {
                showAddPoint = true
            } label: {
                Image(.addButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 93, height: 93)
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .onAppear {
            loadPoints()
        }
        .navigationDestination(isPresented: $showAddPoint) {
            AddPointView()
                .onDisappear {
                    loadPoints()
                }
        }
    }
    
    private func loadPoints() {
        points = ForestPointService.shared.getAll()
        if let firstPoint = points.first {
            let coords = firstPoint.parseCoordinates()
            if coords.latitude != 0.0 || coords.longitude != 0.0 {
                region.center = CLLocationCoordinate2D(
                    latitude: coords.latitude,
                    longitude: coords.longitude
                )
            }
        }
    }
}

struct MapPinView: View {
    let point: ForestPoint
    @State private var showDetail = false
    
    var body: some View {
        Button {
            showDetail = true
        } label: {
            ZStack {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                
                if showDetail, let imageData = point.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(y: -50)
                }
            }
        }
    }
}

