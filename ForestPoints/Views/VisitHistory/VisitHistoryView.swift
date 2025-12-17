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
                            from: "TRACK YOUR VISITS AND\nOBSERVATIONS FOR EACH PLACE",
                            fontSize: 20,
                            lineHeight: 26,
                            lineSpacing: 0,
                            letterSpacing: -0.41,
                            fontName: "SignikaSC-Regular",
                            alpha: 0.7
                        )
                    )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 223)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 30/255, green: 49/255, blue: 0/255).opacity(0.86))
                )
                .padding(.horizontal, 16)
                
                Button {
                    // TODO: Add visit action
                } label: {
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
            VStack(spacing: 12) {
                ForEach(visits) { visit in
                    // TODO: Visit card view
                    Text("Visit \(visit.id)")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
    
    private func loadVisits() {
        visits = VisitService.shared.getAll()
    }
}

