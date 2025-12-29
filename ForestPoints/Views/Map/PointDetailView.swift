import SwiftUI

struct PointDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let point: ForestPoint
    @State private var isFavourite: Bool
    @State private var showMarkAsPicker = false
    @State private var showDeleteAlert = false
    
    init(point: ForestPoint) {
        self.point = point
        self._isFavourite = State(initialValue: point.isFavourite)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: geometry.size.height < 650 ? 12 : 20) {
                    headerSection(geometry: geometry)
                    
                    ScrollView(showsIndicators: false) {
                        contentCard(geometry: geometry)
                    }
                    
                    bottomButtons(geometry: geometry)
                }
                .bgSetup()
                
                markAsPickerOverlay
                deleteAlertOverlay
            }
        }
        .navigationBarHidden(true)
    }
    
    private func headerSection(geometry: GeometryProxy) -> some View {
        HStack(spacing: 16) {
            Button(action: {
                dismiss()
            }) {
                Image(.back)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.height < 650 ? 85 : 104,
                        height: geometry.size.height < 650 ? 82 : 101
                    )
            }
            
            Spacer()
            
            Button(action: {
                showMarkAsPicker = true
            }) {
                ZStack {
                    Image(.addView)
                        .resizable()
                        .frame(
                            width: geometry.size.height < 650 ? 140 : 163,
                            height: geometry.size.height < 650 ? 68 : 79
                        )
                    
                    Text("MARK AS")
                        .font(.signikaBold(size: geometry.size.height < 650 ? 24 : 30))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, geometry.size.height < 650 ? 12 : 20)
    }
    
    private func contentCard(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height < 650 ? 12 : 16) {
            ZStack(alignment: .topTrailing) {
                if let imageData = point.imageData,
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
                
                Button(action: {
                    toggleFavourite()
                }) {
                    Image(isFavourite ? .likeIconOn : .likeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.height < 650 ? 65 : 79,
                            height: geometry.size.height < 650 ? 62 : 75
                        )
                }
                .padding(geometry.size.height < 650 ? 8 : 12)
            }
            
            VStack(alignment: .leading, spacing: geometry.size.height < 650 ? 8 : 12) {
                Text(point.name.isEmpty ? "Unknown Point" : point.name.uppercased())
                    .font(.signikaBold(size: geometry.size.height < 650 ? 24 : 35))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.height < 650 ? 32 : 40,
                            height: geometry.size.height < 650 ? 33 : 41
                        )
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Date Added")
                            .font(.signikaBold(size: geometry.size.height < 650 ? 13 : 15))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(formattedDate)
                            .font(.signikaBold(size: geometry.size.height < 650 ? 20 : 25))
                            .foregroundColor(.white)
                    }
                }
                
                HStack(spacing: 8) {
                    Image(.pin)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.height < 650 ? 30 : 38,
                            height: geometry.size.height < 650 ? 37 : 46
                        )
                    
                    Text(point.coordinates)
                        .font(.signikaBold(size: geometry.size.height < 650 ? 16 : 20))
                        .foregroundColor(.white)
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
            NavigationLink(destination: AddPointView(point: point)) {
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

