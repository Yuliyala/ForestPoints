import SwiftUI

struct VisitHistoryView: View {
    @State private var visits: [Visit] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Visit History")
            
            if visits.isEmpty {
                emptyStateView
            } else {
                visitsList
            }
        }
        .onAppear {
            loadVisits()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    AttributedTextLabel(
                        attributedString: createAttributedString(
                            from: "NO POINTS IN\nVISIT HISTORY YET",
                            fontSize: 35,
                            lineHeight: 40,
                            lineSpacing: 0,
                            letterSpacing: -0.41
                        )
                    )
                    
                    AttributedTextLabel(
                        attributedString: createAttributedString(
                            from: "Collections help you explore and\n revisit your favorite spots",
                            fontSize: 20,
                            lineHeight: 26,
                            lineSpacing: 0,
                            letterSpacing: -0.41,
                            fontName: "Signika-Bold",
                            alpha: 0.7
                        )
                    )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 223)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.greenCardBackground)
                )
                .padding(.horizontal, 16)
                
                NavigationLink(destination: AddVisitView()) {
                    Image(.addButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 93)
                }
            }
            
            Spacer()
        }
    }
    
    private var visitsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(visits) { visit in
                    NavigationLink(destination: VisitDetailView(visit: visit)) {
                        VisitCardView(visit: visit)
                    }
                }
                
                NavigationLink(destination: AddVisitView()) {
                    Image(.addButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 93, height: 93)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private func loadVisits() {
        visits = VisitService.shared.getAll()
    }
}

struct VisitCardView: View {
    let visit: Visit
    @State private var pointName: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 16)
            
            if let imageData = visit.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 310, height: 135)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.greenLight)
                    .frame(width: 310, height: 135)
            }
            
            Spacer()
                .frame(height: 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(pointName.isEmpty ? "Unknown Point" : pointName.uppercased())
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 27, height: 28)
                    
                    Text(formattedDate)
                        .font(.signikaBold(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 13)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(width: 350, height: 234)
        .background(
            RoundedRectangle(cornerRadius: 48)
                .fill(Color(red: 30/255, green: 49/255, blue: 0/255).opacity(0.86))
        )
        .onAppear {
            loadPointName()
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: visit.date)
    }
    
    private func loadPointName() {
        if let point = ForestPointService.shared.getAll().first(where: { $0.id == visit.pointId }) {
            pointName = point.name
        }
    }
}

