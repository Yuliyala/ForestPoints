import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var points: [ForestPoint] = []
    
    var favoritePoints: [ForestPoint] {
        points.filter { $0.isFavourite }
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
                
                Text("FAVORITES")
                    .font(.signikaBold(size: 35))
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
                    .padding(.top, 40)
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
        VStack {
            Spacer().frame(height: 60)

            ZStack {
                RoundedRectangle(cornerRadius: 48)
                    .fill(Color.greenCardBackground)
                    .frame(width: 350, height: 223)

                VStack(spacing: 12) {
                    Text("NO FAVORITE\nPLACES YET")
                        .font(.signikaBold(size: 35))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Mark spots you want to revisit\nor places that inspire you")
                        .font(.signikaBold(size: 20))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 32)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 16)

            Spacer()
        }
    }
    
    private func loadPoints() {
        points = ForestPointService.shared.getAll()
    }
}

