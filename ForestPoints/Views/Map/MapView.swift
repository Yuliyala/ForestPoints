import SwiftUI
import MapKit

class MapState: ObservableObject {
    @Published var selectedPointId: UUID?
}

struct MapView: View {
    @StateObject private var mapState = MapState()
    @State private var points: [ForestPoint] = []
    @State private var showAddPoint = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    private static let defaultCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HeaderView(title: "Forest Points\nCatalog")
                
                ZStack {
                    Map(coordinateRegion: $region, annotationItems: points.filter { 
                        let coords = $0.parseCoordinates()
                        return coords.latitude != nil && coords.longitude != nil
                    }) { point in
                        MapAnnotation(coordinate: point.coordinateForMap) {
                            MapPinView(point: point, mapState: mapState)
                        }
                    }
                    .frame(height: geometry.size.height < 650 ? 280 : 362)
                    
                    if mapState.selectedPointId != nil {
                        Color.clear
                            .frame(height: geometry.size.height < 650 ? 280 : 362)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Task { @MainActor in
                                    mapState.selectedPointId = nil
                                }
                            }
                            .zIndex(1)
                    }
                }
                .cornerRadius(20)
                .padding(.top, 8)
                
                Button {
                    showAddPoint = true
                } label: {
                    Image(.addButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.height < 650 ? 70 : 93, height: geometry.size.height < 650 ? 70 : 93)
                }
                .padding(.top, 12)
                
                Spacer()
            }
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
            if let lat = coords.latitude, let lon = coords.longitude {
                region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
        }
    }
}

struct MapPinView: View {
    let point: ForestPoint
    @ObservedObject var mapState: MapState
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
    
    private var isSelected: Bool {
        mapState.selectedPointId == point.id
    }
    
    var body: some View {
        ZStack {
            pinView
            
            if isSelected {
                detailCard
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
        }
    }
    
    private var pinView: some View {
        Image(.pin)
            .resizable()
            .scaledToFit()
            .frame(width: Layout.pinWidth, height: Layout.pinHeight)
            .contentShape(Rectangle())
            .onTapGesture {
                Task { @MainActor in
                    if isSelected {
                        mapState.selectedPointId = nil
                    } else {
                        mapState.selectedPointId = point.id
                    }
                }
            }
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
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .allowsHitTesting(true)
        .offset(y: -110)
        .zIndex(1000)
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
                .allowsHitTesting(false)
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
                .allowsHitTesting(false)
        }
    }
}
