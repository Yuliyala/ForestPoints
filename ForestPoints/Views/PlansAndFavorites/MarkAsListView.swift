import SwiftUI

struct MarkAsListView: View {
    @Environment(\.dismiss) private var dismiss
    
    let type: MarkAsType
    @State private var points: [ForestPoint] = []
    
    var filteredPoints: [ForestPoint] {
        points.filter { $0.markAsType == type }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerSection
                contentScrollView
            }
            .bgSetup()
        }
        .navigationBarHidden(true)
        .onAppear(perform: loadPoints)
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            Button(action: {
                dismiss()
            }) {
                Image(.back)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 104, height: 101)
            }
            
            ZStack {
                Image(.headerBg)
                    .resizable()
                    .frame(width: 229, height: 128)
                
                Text(type.title.uppercased())
                    .font(.signikaBold(size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            if filteredPoints.isEmpty {
                emptyState
            } else {
                VStack(spacing: 12) {
                    ForEach(filteredPoints) { point in
                        NavigationLink(destination: PointDetailView(point: point)) {
                            UpcomingVisitCardView(point: point)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(type.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("NO PLACES YET")
                .font(.signikaBold(size: 28))
                .foregroundColor(.white.opacity(0.6))
            
            Text("Mark places with \"\(type.title)\" to see them here")
                .font(.signikaBold(size: 20))
                .foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
    
    private func loadPoints() {
        points = ForestPointService.shared.getAll()
    }
}

