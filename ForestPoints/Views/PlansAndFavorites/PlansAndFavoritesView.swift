import SwiftUI

struct PlansAndFavoritesView: View {
    @State private var points: [ForestPoint] = []
    
    var upcomingVisits: [ForestPoint] {
        points.filter { $0.markAsType != nil || $0.isFavourite }
            .sorted { point1, point2 in
                let date1 = point1.desiredDate ?? Date.distantFuture
                let date2 = point2.desiredDate ?? Date.distantFuture
                return date1 < date2
            }
    }
    
    var markedPoints: [ForestPoint] {
        points.filter { $0.markAsType != nil }
    }
    
    var hasAnyPlans: Bool {
        !upcomingVisits.isEmpty || !markedPoints.isEmpty
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
            ZStack {
                Image(.headerBg)
                    .resizable()
                    .frame(width: 246, height: 145)
                
                AttributedTextLabel(
                    attributedString: createAttributedString(
                        from: "PLANS &\nFAVORITES",
                        fontSize: 32,
                        lineHeight: 34,
                        lineSpacing: 0,
                        letterSpacing: -0.41
                    )
                )
            }
   
            NavigationLink(destination: FavoritesView()
                .onAppear {
                    loadPoints()
                }
            ) {
                Image(.heartIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            if hasAnyPlans {
                VStack(spacing: 20) {
                    markAsCardsSection
                    upcomingVisitsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 20)
            } else {
                emptyPlansState
                    .padding(.bottom, 20)
            }
        }
    }
    
    private var markAsCardsSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                MarkAsCardView(type: .wantToComeBack)
                MarkAsCardView(type: .placesForAutumn)
            }
            
            HStack {
                Spacer()
                MarkAsCardView(type: .placesForSunrise)
                Spacer()
            }
        }
    }
    
    private var upcomingVisitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("UPCOMING VISITS")
                .font(.signikaBold(size: 22))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            if upcomingVisits.isEmpty {
                emptyUpcomingVisits
            } else {
                ForEach(upcomingVisits) { point in
                    NavigationLink(destination: PointDetailView(point: point)) {
                        UpcomingVisitCardView(point: point)
                    }
                }
            }
        }
    }
    
    private var emptyUpcomingVisits: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 48)
                .fill(Color.greenCardBackground)
                .frame(width: 350, height: 234)
            
            VStack(spacing: 12) {
                Text("NO UPCOMING VISITS")
                    .font(.signikaBold(size: 28))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                
                Text("Mark spots with desired dates to see\nthem here")
                    .font(.signikaBold(size: 20))
                    .foregroundColor(.white.opacity(0.4))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 350, height: 234)
        }
    }
    
    private var emptyPlansState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(.likeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("NO PLANS YET")
                    .font(.signikaBold(size: 28))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Mark spots with 'Mark As' or set desired dates to see them here")
                    .font(.signikaBold(size: 20))
                    .foregroundColor(.white.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 80)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.greenBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.greenBorder, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
    
    private func loadPoints() {
        points = ForestPointService.shared.getAll()
    }
}

