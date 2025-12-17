import SwiftUI
import PhotosUI

struct AddCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedImageData: Data?
    @State private var selectedImageItem: PhotosPickerItem?
    
    var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerSection
                contentScrollView
                saveButton
            }
            .bgSetup()
        }
        .onChange(of: selectedImageItem) { newValue in
            Task {
                if let newValue = newValue {
                    if let data = try? await newValue.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
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
            
            ZStack {
                Image(.headerBg)
                    .resizable()
                    .frame(width: 229, height: 128)
                
                AttributedTextLabel(
                    attributedString: createAttributedString(
                        from: "ADD\nCOLLECTION",
                        fontSize: 30,
                        lineHeight: 34,
                        lineSpacing: 0,
                        letterSpacing: -0.41
                    )
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                PhotosPicker(selection: $selectedImageItem, matching: .images) {
                    photoPicker
                }
                
                titleInputField
            }
            .padding(20)
            .background(Color.greenBg)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.greenBorder, lineWidth: 1)
            )
            .cornerRadius(40)
            .padding(.horizontal, 20)
        }
    }
    
    private var titleInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TITLE")
                .font(.signikaBold(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .padding(.leading, 20)
            
            TextField("", text: $name, prompt: Text("Text..").foregroundColor(.white.opacity(0.4)))
                .font(.signikaBold(size: 20))
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.greenLight)
                .cornerRadius(20)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            saveCollection()
        }) {
            Image(isFormValid ? .doneButton : .doneButtonOff)
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 108)
        }
        .disabled(!isFormValid)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }
    
    private var photoPicker: some View {
        ZStack {
            if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.greenLight)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(.camera)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 121, height: 117)
                    )
            }
        }
    }
    
    private func saveCollection() {
        let collection = Collection(
            imageData: selectedImageData,
            title: name
        )
        
        CollectionService.shared.save(collection)
        dismiss()
    }
}

