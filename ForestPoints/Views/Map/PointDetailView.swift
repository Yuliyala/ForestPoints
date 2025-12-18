import SwiftUI

struct PointDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let point: ForestPoint
    @State private var isFavourite: Bool
    @State private var showMarkAsPicker = false
    @State private var showEditPoint = false
    @State private var showDeleteAlert = false
    
    init(point: ForestPoint) {
        self.point = point
        self._isFavourite = State(initialValue: point.isFavourite)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                headerSection
                
                contentCard
                
                Spacer()
                
                bottomButtons
            }
            .bgSetup()
            
            markAsPickerOverlay
            deleteAlertOverlay
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showEditPoint) {
            AddPointView(point: point)
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
            
            Spacer()
            
            Button(action: {
                showMarkAsPicker = true
            }) {
                ZStack {
                    Image(.addView)
                        .resizable()
                        .frame(width: 163, height:79)
                    
                    Text("MARK AS")
                        .font(.signikaBold(size: 30))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var contentCard: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topTrailing) {
                if let imageData = point.imageData,
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
                
                Button(action: {
                    toggleFavourite()
                }) {
                    Image(isFavourite ? .likeIconOn : .likeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 79, height: 75)
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(point.name.isEmpty ? "Unknown Point" : point.name.uppercased())
                    .font(.signikaBold(size: 35))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 41)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Date Added")
                            .font(.signikaBold(size: 15))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(formattedDate)
                            .font(.signikaBold(size: 25))
                            .foregroundColor(.white)
                    }
                }
                
                HStack(spacing: 8) {
                    Image(.pin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 46)
                    
                    Text(point.coordinates)
                        .font(.signikaBold(size: 20))
                        .foregroundColor(.white)
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
                showEditPoint = true
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
    
    @ViewBuilder
    private var markAsPickerOverlay: some View {
        if showMarkAsPicker {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showMarkAsPicker = false
                }
            
            VStack {
                Spacer()
                
                MarkAsPickerView(
                    point: point,
                    onDismiss: {
                        showMarkAsPicker = false
                    }
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    private func toggleFavourite() {
        isFavourite.toggle()
        var updatedPoint = point
        updatedPoint.isFavourite = isFavourite
        ForestPointService.shared.save(updatedPoint)
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
                    onDelete: {
                        deletePoint()
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
    
    private func deletePoint() {
        ForestPointService.shared.delete(id: point.id)
        dismiss()
    }
}

