import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var points: [ForestPoint] = []
    
    var favoritePoints: [ForestPoint] {
        points.filter { $0.isFavourite }
    }
    
    var body: some View {
        NavigationStack {
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
                
                Text("FAVORITES")
                    .font(.signikaBold(size: 30))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            if favoritePoints.isEmpty {
                emptyState
            } else {
                VStack(spacing: 12) {
                    ForEach(favoritePoints) { point in
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
            Image(.likeIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("NO FAVORITE\nPLACES YET")
                .font(.signikaBold(size: 28))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
            
            Text("Mark spots you want to revisit\nor places that inspire you")
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

