import SwiftUI

struct CollectionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let collection: Collection
    @State private var showEditCollection = false
    @State private var showDeleteAlert = false
    
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
        .sheet(isPresented: $showEditCollection) {
            AddCollectionView(collection: collection)
        }
        .alert("Delete Collection", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteCollection()
            }
        } message: {
            Text("Are you sure you want to delete this collection?")
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
            if let imageData = collection.imageData,
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
            
            Text(collection.title.uppercased())
                .font(.signikaBold(size: 35))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
        .frame(width: 350, height: 322)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.greenBorder, lineWidth: 1)
        )
    }
    
    private var bottomButtons: some View {
        HStack(spacing: 0) {
            Button(action: {
                showEditCollection = true
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
    
    private func deleteCollection() {
        CollectionService.shared.delete(collection)
        dismiss()
    }
}

