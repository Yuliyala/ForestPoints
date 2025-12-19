import SwiftUI
import PhotosUI

struct AddPointView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @Namespace private var namespace
    
    let point: ForestPoint?
    
    @State private var selectedImageData: Data?
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedType: PointType = .clearing
    @State private var isTypeChosen: Bool = false
    @State private var name = ""
    @State private var coordinates = ""
    @State private var showTypePicker = false
    
    enum Field: Hashable {
        case name
        case coordinates
    }
    
    init(point: ForestPoint? = nil) {
        self.point = point
    }
    
    var isFormValid: Bool {
        !name.isEmpty
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
            
            typePickerOverlay
        }
        .onChange(of: selectedImageItem) { newValue in
            Task {
                if let newValue = newValue {
                    do {
                        if let data = try await newValue.loadTransferable(type: Data.self) {
                            await MainActor.run {
                                selectedImageData = data
                                print("Image loaded successfully, size: \(data.count) bytes")
                            }
                        } else {
                            print("Failed to load image: data is nil")
                        }
                    } catch {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                } else {
                    await MainActor.run {
                        selectedImageData = nil
                    }
                }
            }
        }
        .onAppear {
            if let point = point {
                selectedImageData = point.imageData
                selectedType = point.type
                isTypeChosen = true
                name = point.name
                coordinates = point.coordinates
            } else {
                let randomCoord = MockCoordinates.random()
                coordinates = String(format: "%.4f, %.4f", randomCoord.latitude, randomCoord.longitude)
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
                        from: "Add Entry",
                        fontSize: 35,
                        lineHeight: 40,
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
                    
                    typePickerView
                    
                    nameInputField
                        .id(Field.name)
                    
                    coordinatesInputField
                        .id(Field.coordinates)
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
            .onChange(of: focusedField) { field in
                if let field = field {
                    withAnimation {
                        proxy.scrollTo(field, anchor: .center)
                    }
                }
            }
        }
    }
    
    private var nameInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
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
    
    private var coordinatesInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Coordinates")
                .font(.signikaBold(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .padding(.leading, 20)
            
            TextField("", text: $coordinates, prompt: Text("Text..").foregroundColor(.white.opacity(0.4)))
                .font(.signikaBold(size: 20))
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.greenLight)
                .cornerRadius(20)
                .focused($focusedField, equals: .coordinates)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            savePoint()
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
    
    @ViewBuilder
    private var typePickerOverlay: some View {
        if showTypePicker {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showTypePicker = false
                }
            
            VStack {
                Spacer()
                
                TypePickerView(
                    selectedType: $selectedType,
                    onDismiss: {
                        showTypePicker = false
                    },
                    onConfirm: {
                        isTypeChosen = true
                    }
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var photoPicker: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.greenLight)
                .frame(width: 120, height: 120)
            
            if let imageData = selectedImageData {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Text("Invalid image")
                        .foregroundColor(.red)
                        .font(.caption)
                }
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
        .onAppear {
            print("photoPicker appeared, selectedImageData: \(selectedImageData != nil ? "exists (\(selectedImageData!.count) bytes)" : "nil")")
        }
    }
    
    private var typePickerView: some View {
        HStack(spacing: 10) {
            Text("Type")
                .font(.signikaBold(size: 25))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                showTypePicker = true
            } label: {
                ZStack(alignment: .center) {
                    Color.yellowButton
                    
                    AttributedTextLabel(
                        attributedString: createAttributedString(
                            from: isTypeChosen ? "Choosen" : "Choose",
                            fontSize: 22,
                            lineHeight: 22,
                            lineSpacing: 0,
                            letterSpacing: -0.41
                        )
                    )
                    .fixedSize()
                    .frame(height: 63)
                }
                .frame(width: 96, height: 63)
                .cornerRadius(20)
            }
        }
        .frame(height: 83)
        .padding(.horizontal, 13)
        .background(Color.greenLight)
        .cornerRadius(25)
    }
    
    private func savePoint() {
        let collections = CollectionService.shared.getAll()
        let randomCollection = collections.randomElement()
        
        var finalCoordinates = coordinates
        if coordinates.isEmpty || !isValidCoordinates(coordinates) {
            let randomCoord = MockCoordinates.random()
            finalCoordinates = String(format: "%.4f, %.4f", randomCoord.latitude, randomCoord.longitude)
        }
        
        let newPoint = ForestPoint(
            id: point?.id ?? UUID(),
            imageData: selectedImageData,
            type: selectedType,
            name: name,
            coordinates: finalCoordinates,
            notes: "",
            isFavourite: point?.isFavourite ?? false,
            markAsType: point?.markAsType,
            collectionId: randomCollection?.id
        )
        
        ForestPointService.shared.save(newPoint)
        dismiss()
    }
    
    private func isValidCoordinates(_ coords: String) -> Bool {
        let tempPoint = ForestPoint(coordinates: coords)
        let parsed = tempPoint.parseCoordinates()
        return parsed.latitude != nil && parsed.longitude != nil
    }
}
