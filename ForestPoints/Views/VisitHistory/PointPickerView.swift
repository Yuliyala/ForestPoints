import SwiftUI

struct PointPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPoint: ForestPoint?
    @State private var points: [ForestPoint] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerSection
                
                pointsList
            }
            .bgSetup()
        }
        .navigationBarHidden(true)
        .onAppear {
            loadPoints()
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            Button(action: {
                dismiss()
            }) {
                Image(.closeButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
            }
            
            Text("SELECT POINT")
                .font(.signikaBold(size: 30))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var pointsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(points) { point in
                    Button(action: {
                        selectedPoint = point
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            if let imageData = point.imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.greenLight)
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(point.name.uppercased())
                                    .font(.signikaBold(size: 18))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text(point.type.title)
                                    .font(.signikaBold(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.greenBg)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.greenBorder, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
    
    private func loadPoints() {
        points = ForestPointService.shared.getAll()
    }
}

