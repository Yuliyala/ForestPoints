import SwiftUI

struct CollectionsView: View {
    @State private var collections: [Collection] = []
    @State private var points: [ForestPoint] = []
    @State private var showAddCollection = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Forest Points\nCatalog")
            
            if points.isEmpty {
                emptyStateView
            } else {
                collectionsGrid
            }
        }
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $showAddCollection) {
            AddCollectionView()
                .onDisappear {
                    loadData()
                }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    AttributedTextLabel(
                        attributedString: createAttributedString(
                            from: "NO POINTS IN\nCOLLECTIONS YET",
                            fontSize: 35,
                            lineHeight: 40,
                            lineSpacing: 0,
                            letterSpacing: -0.41
                        )
                    )
                    
                    AttributedTextLabel(
                        attributedString: createAttributedString(
                            from: "COLLECTIONS HELP YOU EXPLORE\nAND REVISIT YOUR FAVORITE SPOTS",
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
                
                Button {
                    showAddCollection = true
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
    
    private var collectionsGrid: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 8) {
                    ForEach(collections) { collection in
                        NavigationLink(destination: CollectionDetailView(collection: collection)) {
                            CollectionCardView(collection: collection)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                
                Button {
                    showAddCollection = true
                } label: {
                    ZStack {
                        Image(.addView)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 73)
                            .clipped()
                        
                        Text("ADD\nCOLLECTION")
                            .font(.signikaBold(size: 22))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 150, height: 73)
                }
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
    }
    
    private func loadData() {
        collections = CollectionService.shared.getAll()
        points = ForestPointService.shared.getAll()
    }
}

struct CollectionCardView: View {
    let collection: Collection
    
    var body: some View {
        ZStack {
            Image(.collectionIcon)
                .resizable()
                .scaledToFill()
                .frame(width: 172, height: 155)
                .clipped()
            
            VStack(spacing: 12) {
                Spacer()
                
                if let imageData = collection.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 84)
                } else if let defaultImage = defaultIcon(for: collection.title) {
                    Image(defaultImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 84)
                }
                
                Text(collection.title.uppercased())
                    .font(.signikaBold(size: 20))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .frame(width: 172, height: 155)
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
}

