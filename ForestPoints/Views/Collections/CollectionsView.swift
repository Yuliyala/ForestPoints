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
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 8) {
                    ForEach(collections) { collection in
                        NavigationLink(destination: CollectionDetailView(collection: collection)) {
                            CollectionCardView(collection: collection)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            
            Spacer()
            
            Button {
                showAddCollection = true
            } label: {
                Text("ADD\nCOLLECTION")
                    .font(.signikaSCBold(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 178, height: 64)
                    .background(Color.yellowButton)
                    .cornerRadius(20)
            }
            .padding(.bottom, 20)
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
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.greenCard)
                    .frame(height: 140)
                
                if let imageData = collection.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                } else if let defaultImage = defaultIcon(for: collection.title) {
                    Image(defaultImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
            
            Text(collection.title.uppercased())
                .font(.signikaSCBold(size: 16))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
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

