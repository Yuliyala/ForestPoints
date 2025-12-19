import SwiftUI

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let collection: Collection
    @State private var showDeleteAlert = false
    @State private var points: [ForestPoint] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                backButton

                collectionIconView

                collectionDetailCard

                Spacer()
            }
            .bgSetup()
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

    private var collectionDetailCard: some View {
        Group {
            if let point = featuredPoint {
                NavigationLink(destination: PointDetailView(point: point)) {
                    cardContent
                }
                .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
        .contextMenu {
            Button("Delete Collection", role: .destructive) {
                showDeleteAlert = true
            }
        }
    }
    
    private var cardContent: some View {
        VStack(spacing: 8) {
            collectionImage
                .padding(.top, 12)

            Text(displayedPointName)
                .font(.signikaBold(size: 28))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .frame(width: 310, height: 220)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenBg)
        )
    }

    private var collectionImage: some View {
        Group {
            if let point = featuredPoint,
               let imageData = point.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let imageData = collection.imageData,
                      let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.greenLight)
                    .overlay(
                        Image(.camera)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    )
            }
        }
        .frame(width: 278, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }

    private var featuredPoint: ForestPoint? {
        points.first { $0.collectionId == collection.id }
    }

    private var displayedPointName: String {
        featuredPoint?.name.uppercased() ?? "NO POINTS YET"
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

