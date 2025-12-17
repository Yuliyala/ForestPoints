import SwiftUI

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let collection: Collection
    @State private var points: [ForestPoint] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: collection.title,
                backTapped: {
                    dismiss()
                }
            )
            
            if points.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text("No points in\nthis collection")
                        .font(.signikaSCBold(size: 28))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Add forest points to see them here")
                        .font(.signikaSC(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        ForEach(points) { point in
                            PointCardView(point: point)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            loadPoints()
        }
    }
    
    private func loadPoints() {
        let allPoints = ForestPointService.shared.getAll()
        points = allPoints.filter { $0.collectionId == collection.id }
    }
}

struct PointCardView: View {
    let point: ForestPoint
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageData = point.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.greenLight)
                    .frame(height: 120)
            }
            
            VStack(spacing: 8) {
                Text(point.name)
                    .font(.signikaSCBold(size: 16))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(point.type.title)
                    .font(.signikaSC(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.greenBg)
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.greenBorder, lineWidth: 1)
        )
    }
}

