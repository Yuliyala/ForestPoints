import SwiftUI

struct VisitDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let visit: Visit
    @State private var showEditVisit = false
    @State private var showDeleteAlert = false
    @State private var pointName: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                backButton
                
                contentCard
                
                Spacer()
                
                bottomButtons
            }
            .bgSetup()
        }
        .navigationBarHidden(true)
        .onAppear {
            loadPointName()
        }
        .sheet(isPresented: $showEditVisit) {
            AddVisitView(visit: visit)
        }
        .alert("Delete Visit", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteVisit()
            }
        } message: {
            Text("Are you sure you want to delete this visit?")
        }
    }
    
    private var backButton: some View {
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
    
    private var contentCard: some View {
        VStack(spacing: 16) {
            if let imageData = visit.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 308, height: 224)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.greenLight)
                    .frame(width: 308, height: 224)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(pointName.isEmpty ? "Unknown Point" : pointName.uppercased())
                    .font(.signikaBold(size: 35))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(formattedDate)
                        .font(.signikaBold(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 8) {
                    Text("Mood")
                        .font(.signikaBold(size: 25))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    
                    Text(visit.mood.title.uppercased())
                        .font(.signikaBold(size: 22))
                        .foregroundColor(.white)
                    
                    Image(visit.mood.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 54)
                }
                
                if !visit.observations.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Observations")
                            .font(.signikaBold(size: 22))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(visit.observations)
                            .font(.signikaBold(size: 25))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.greenBorder, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
    
    private var bottomButtons: some View {
        HStack(spacing: 0) {
            Button(action: {
                showEditVisit = true
            }) {
                Image(.editButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 115, height: 117)
            }
            
            Button(action: {
                showDeleteAlert = true
            }) {
                Image(.deleteButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 115, height: 117)
            }
        }
        .padding(.bottom, 20)
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
    
    private func deleteVisit() {
        VisitService.shared.delete(id: visit.id)
        dismiss()
    }
}

