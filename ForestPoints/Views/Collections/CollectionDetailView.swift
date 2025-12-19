import SwiftUI

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let collection: Collection
    @State private var showDeleteAlert = false
    @State private var points: [ForestPoint] = []
    
    var body: some View {
        ZStack {
            if collectionPoints.isEmpty {
                VStack(spacing: 20) {
                    backButton

                    collectionIconView

                    emptyCollectionCard

                    Spacer()
                }
                .bgSetup()
            } else {
                VStack(spacing: 0) {
                    backButton

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            collectionIconView

                            pointsList
                        }
                        .padding(.bottom, 20)
                    }
                }
                .bgSetup()
            }
        }
        .onAppear(perform: loadPoints)
        .overlay(deleteAlertOverlay)
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
    
    private var collectionIconView: some View {
        ZStack {
            Image(.collectionIcon)
                .resizable()
                .scaledToFill()
                .frame(width: 172, height: 125)
                .clipShape(RoundedRectangle(cornerRadius: 25))

            VStack(spacing: 8) {
                Spacer()

                Image(defaultIcon(for: collection.title) ?? .collectionIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)

                Text(collection.title.uppercased())
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Spacer()
            }
            .frame(width: 172, height: 125)
        }
    }

    private var emptyCollectionCard: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.greenLight)
                .frame(width: 278, height: 160)
                .overlay(
                    Image(.camera)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                )

            Text("NO POINTS YET")
                .font(.signikaBold(size: 28))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .padding(.top, 12)
        .frame(width: 310, height: 220)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenBg)
        )
        .contextMenu {
            Button("Delete Collection", role: .destructive) {
                showDeleteAlert = true
            }
        }
    }
    
    private var pointsList: some View {
        VStack(spacing: 12) {
            ForEach(collectionPoints) { point in
                NavigationLink(destination: PointDetailView(point: point)) {
                    pointCard(for: point)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func pointCard(for point: ForestPoint) -> some View {
        VStack(spacing: 8) {
            if let imageData = point.imageData,
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
                    .overlay(
                        Image(.camera)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    )
            }
            
            HStack {
                Text(point.name.uppercased())
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 350, height: 234)
        .background(
            RoundedRectangle(cornerRadius: 48)
                .fill(Color.greenCardBackground)
        )
    }

    private var collectionPoints: [ForestPoint] {
        points.filter { $0.collectionId == collection.id }
    }
    
    private func deleteCollection() {
        CollectionService.shared.delete(collection)
        dismiss()
    }

    private func loadPoints() {
        points = ForestPointService.shared.getAll()
    }

    private func defaultIcon(for name: String) -> ImageResource? {
        switch name.lowercased() {
        case "views": return .view
        case "observations": return .observations
        case "pleasant places": return .pleasantPlaces
        case "landmarks": return .landmarks
        case "useful points": return .usefulPoints
        default: return nil
        }
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
                        deleteCollection()
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
}

