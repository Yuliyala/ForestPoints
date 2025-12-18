import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject private var locationManager = LocationManager.shared
    @State private var points: [ForestPoint] = []
    @State private var showAddPoint = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    private static let defaultCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Forest Points\nCatalog")
            
            Map(coordinateRegion: $region, annotationItems: points.filter { 
                let coords = $0.parseCoordinates()
                return coords.latitude != nil && coords.longitude != nil
            }) { point in
                MapAnnotation(coordinate: point.coordinateForMap) {
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
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestPermission()
            }
            locationManager.startUpdating()
            loadPoints()
            centerMapOnCurrentLocation()
        }
        .onDisappear {
            locationManager.stopUpdating()
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
            if let lat = coords.latitude, let lon = coords.longitude {
                region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
        }
    }
    
    private func centerMapOnCurrentLocation() {
        if let location = locationManager.currentLocation {
            region.center = location
        }
    }
}

struct MapPinView: View {
    let point: ForestPoint
    @State private var showDetail = false
    @State private var navigateToDetail = false
    
    private enum Layout {
        static let cardWidth: CGFloat = 180
        static let cardHeight: CGFloat = 155
        static let imageWidth: CGFloat = 138
        static let imageHeight: CGFloat = 103
        static let imageCornerRadius: CGFloat = 16
        static let cardCornerRadius: CGFloat = 20
        static let pinWidth: CGFloat = 34
        static let pinHeight: CGFloat = 41
    }
    
    var body: some View {
        ZStack {
            pinButton
            
            if showDetail {
                detailCard
            }
        }
        .background(
            NavigationLink(
                destination: PointDetailView(point: point),
                isActive: $navigateToDetail
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    private var pinButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showDetail.toggle()
            }
        } label: {
            Image(.pin)
                .resizable()
                .scaledToFit()
                .frame(width: Layout.pinWidth, height: Layout.pinHeight)
        }
        .accessibilityLabel("Pin for \(point.name)")
    }
    
    private var detailCard: some View {
        Button(action: {
            navigateToDetail = true
        }) {
            VStack(spacing: 8) {
                photoView
                    .padding(.top, 12)
                
                Text(point.name.isEmpty ? "No name" : point.name)
                    .font(.signikaBold(size: 18))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
            .frame(width: Layout.cardWidth, height: Layout.cardHeight)
            .background(
                RoundedRectangle(cornerRadius: Layout.cardCornerRadius)
                    .fill(Color.greenOverlay)
            )
            .offset(y: -110)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    @ViewBuilder
    private var photoView: some View {
        if let imageData = point.imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: Layout.imageWidth, height: Layout.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius))
        } else {
            RoundedRectangle(cornerRadius: Layout.imageCornerRadius)
                .fill(Color.greenCard)
                .frame(width: Layout.imageWidth, height: Layout.imageHeight)
                .overlay(
                    Image(.camera)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                )
        }
    }
}

