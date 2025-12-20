import SwiftUI
import PhotosUI

struct AddCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    let collection: Collection?
    
    @State private var name = ""
    @State private var selectedImageData: Data?
    @State private var selectedImageItem: PhotosPickerItem?
    
    enum Field: Hashable {
        case name
    }
    
    init(collection: Collection? = nil) {
        self.collection = collection
    }
    
    var isFormValid: Bool {
        !name.isEmpty && selectedImageData != nil
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerSection
                contentScrollView
            }
            .bgSetup()
            
            VStack {
                Spacer()
                saveButton
                    .padding(.bottom, 20)
            }
            .allowsHitTesting(true)
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            if let collection = collection {
                name = collection.title
                selectedImageData = collection.imageData
            }
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
                        from: collection == nil ? "ADD\nCOLLECTION" : "EDIT\nCOLLECTION",
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
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    PhotosPicker(selection: $selectedImageItem, matching: .images) {
                        photoPicker
                    }
                    
                    titleInputField
                        .id(Field.name)
                }
                .padding(20)
                .background(Color.greenBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.greenBorder, lineWidth: 1)
                )
                .cornerRadius(40)
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
            .onChange(of: focusedField) { field in
                if let field = field {
                    withAnimation {
                        proxy.scrollTo(field, anchor: .center)
                    }
                }
            }
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
                .focused($focusedField, equals: .name)
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
                
                Image(.camera)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 121, height: 117)
            }
        }
    }
    
    private func saveCollection() {
        if let existingCollection = collection {
            let updatedCollection = Collection(
                id: existingCollection.id,
                imageData: selectedImageData,
                title: name
            )
            CollectionService.shared.update(updatedCollection)
        } else {
            let newCollection = Collection(
                imageData: selectedImageData,
                title: name
            )
            CollectionService.shared.save(newCollection)
        }
        dismiss()
    }
}

