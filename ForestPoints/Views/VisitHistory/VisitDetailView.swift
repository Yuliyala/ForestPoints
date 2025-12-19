import SwiftUI

struct VisitDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let visit: Visit
    @State private var showDeleteAlert = false
    @State private var pointName: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: geometry.size.height < 650 ? 12 : 20) {
                    backButton
                    
                    ScrollView(showsIndicators: false) {
                        contentCard(geometry: geometry)
                    }
                    
                    bottomButtons(geometry: geometry)
                }
                .bgSetup()
                
                deleteAlertOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadPointName()
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
    
    private func contentCard(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height < 650 ? 12 : 16) {
            if let imageData = visit.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 308, height: geometry.size.height < 650 ? 150 : 224)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.greenLight)
                    .frame(width: 308, height: geometry.size.height < 650 ? 150 : 224)
            }
            
            VStack(alignment: .leading, spacing: geometry.size.height < 650 ? 8 : 12) {
                Text(pointName.isEmpty ? "Unknown Point" : pointName.uppercased())
                    .font(.signikaBold(size: geometry.size.height < 650 ? 24 : 35))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(formattedDate)
                        .font(.signikaBold(size: geometry.size.height < 650 ? 16 : 18))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 8) {
                    Text("Mood")
                        .font(.signikaBold(size: geometry.size.height < 650 ? 18 : 25))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    
                    Text(visit.mood.title.uppercased())
                        .font(.signikaBold(size: geometry.size.height < 650 ? 18 : 22))
                        .foregroundColor(.white)
                    
                    Image(visit.mood.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.height < 650 ? 32 : 40, height: geometry.size.height < 650 ? 43 : 54)
                }
                
                if !visit.observations.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Observations")
                            .font(.signikaBold(size: geometry.size.height < 650 ? 18 : 22))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(visit.observations)
                            .font(.signikaBold(size: geometry.size.height < 650 ? 18 : 25))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, geometry.size.height < 650 ? 12 : 20)
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
    
    private func bottomButtons(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            NavigationLink(destination: AddVisitView(visit: visit)) {
                Image(.editButton)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.height < 650 ? 90 : 115,
                        height: geometry.size.height < 650 ? 92 : 117
                    )
            }
            
            Button(action: {
                showDeleteAlert = true
            }) {
                Image(.deleteButton)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.height < 650 ? 90 : 115,
                        height: geometry.size.height < 650 ? 92 : 117
                    )
            }
        }
        .padding(.bottom, geometry.size.height < 650 ? 12 : 20)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: visit.date)
    }
    
    @ViewBuilder
    private var deleteAlertOverlay: some View {
        if showDeleteAlert {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showDeleteAlert = false
                }
            
            VStack {
                Spacer()
                
                DeleteAlertView(
                    title: "DELETE VISIT",
                    message: "ARE YOU SURE YOU WANT TO\nDELETE THIS VISIT?\nTHIS ACTION CANNOT BE UNDONE",
                    onDelete: {
                        deleteVisit()
                    },
                    onDismiss: {
                        showDeleteAlert = false
                    }
                )
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

