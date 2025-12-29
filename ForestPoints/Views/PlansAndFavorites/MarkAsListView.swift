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
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(.back)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 104, height: 101)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                markAsHeader

                if filteredPoints.isEmpty {
                    Spacer().frame(height: 60) 
                } else {
                    VStack(spacing: 12) {
                        ForEach(filteredPoints) { point in
                            NavigationLink(destination: PointDetailView(point: point)) {
                                UpcomingVisitCardView(point: point)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 20)
        }
    }
    
    private var markAsHeader: some View {
        ZStack {
            Image(.plansView)
                .resizable()
                .scaledToFill()
                .frame(width: 172, height: 125)
                .clipShape(RoundedRectangle(cornerRadius: 25))

            VStack(spacing: 8) {
                Spacer()
                
                Image(type.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 73, height: 72)

                Text(type.title.uppercased())
                    .font(.signikaBold(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .frame(width: 172, height: 125)
        }
        .padding(.horizontal, 16)
    }

    private func loadPoints() {
        points = ForestPointService.shared.getAll()
    }
}

