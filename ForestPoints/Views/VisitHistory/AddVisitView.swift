import SwiftUI
import PhotosUI

struct AddVisitView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    let visit: Visit?
    
    @State private var selectedPoint: ForestPoint?
    @State private var selectedImageData: Data?
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var date = Date()
    @State private var mood: MoodType = .relaxed
    @State private var observations = ""
    @State private var name = ""
    @State private var showMoodPicker = false
    @State private var showDatePicker = false
    @State private var isMoodSelected = false
    @State private var isDateSelected = false
    
    enum Field: Hashable {
        case name
        case observations
    }
    
    init(visit: Visit? = nil) {
        self.visit = visit
    }
    
    var isFormValid: Bool {
        !name.isEmpty && isMoodSelected && !observations.isEmpty
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerSection
                contentScrollView
            }
            .bgSetup()
            .onTapGesture {
                focusedField = nil
            }
            
            VStack {
                Spacer()
                saveButton
                    .padding(.bottom, 20)
            }
            .allowsHitTesting(true)
            .ignoresSafeArea(.keyboard)
            
            moodPickerOverlay
        }
        .navigationBarHidden(true)
        .onAppear {
            if let visit = visit {
                loadVisitData(visit)
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
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                DatePickerView(selectedDate: $date)
                    .onDisappear {
                        isDateSelected = true
                    }
            }
        }
    }
    
    @ViewBuilder
    private var moodPickerOverlay: some View {
        if showMoodPicker {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showMoodPicker = false
                }
            
            VStack {
                Spacer()
                
                MoodPickerView(
                    selectedMood: $mood,
                    onDismiss: {
                        showMoodPicker = false
                    },
                    onConfirm: {
                        isMoodSelected = true
                    }
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        from: visit == nil ? "ADD ENTRY" : "EDIT ENTRY",
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
                    
                    nameField
                    dateField
                    moodField
                    observationsField
                        .id(Field.observations)
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
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NAME")
                .font(.signikaRegular(size: 22))
                .foregroundColor(.white.opacity(0.6))
                .padding(.leading, 8)

            TextField("", text: $name, prompt: Text("Text..").foregroundColor(.white.opacity(0.4)), axis: .vertical)
                .font(.signikaBold(size: 25))
                .foregroundColor(.white)
                .frame(height: 83)
                .padding(.horizontal, 20)
                .background(Color.greenLight)
                .cornerRadius(20)
                .focused($focusedField, equals: .name)
        }
    }
    
    private var dateField: some View {
        Button(action: {
            showDatePicker = true
        }) {
            HStack {
                Text(isDateSelected ? formattedDate : "DATE")
                    .font(.signikaBold(size: 25))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(.calendar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 74, height: 63)
            }
            .frame(height: 83)
            .padding(.horizontal, 20)
            .background(Color.greenLight)
            .cornerRadius(20)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    private var moodField: some View {
        HStack {
            Text("MOOD")
                .font(.signikaBold(size: 25))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                showMoodPicker = true
            }) {
                Text(isMoodSelected ? "Choosen" : "Choose")
                    .font(.signikaBold(size: 22))
                    .foregroundColor(.white)
                    .frame(width: 96, height: 63)
                    .background(Color.yellowButton)
                    .cornerRadius(12)
            }
        }
        .frame(height: 83)
        .padding(.horizontal, 20)
        .background(Color.greenLight)
        .cornerRadius(20)
    }
    
    private var observationsField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("OBSERVATIONS")
                .font(.signikaRegular(size: 22))
                .foregroundColor(.white.opacity(0.6))
                .padding(.leading, 8)
            
            TextField("", text: $observations, prompt: Text("Text..").foregroundColor(.white.opacity(0.4)), axis: .vertical)
                .font(.signikaBold(size: 25))
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.greenLight)
                .cornerRadius(20)
                .focused($focusedField, equals: .observations)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            saveVisit()
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
    
    private func loadVisitData(_ visit: Visit) {
        selectedImageData = visit.imageData
        date = visit.date
        mood = visit.mood
        observations = visit.observations
        isMoodSelected = true
        isDateSelected = true
        
        if let point = ForestPointService.shared.getAll().first(where: { $0.id == visit.pointId }) {
            selectedPoint = point
            name = point.name
        }
    }
    
    private func saveVisit() {
        let point: ForestPoint
        
        if let existingPoint = selectedPoint {
            point = existingPoint
        } else {
            point = ForestPoint(
                imageData: selectedImageData,
                type: .clearing,
                name: name,
                coordinates: "",
                collectionId: nil
            )
            ForestPointService.shared.save(point)
        }
        
        if let existingVisit = visit {
            let updatedVisit = Visit(
                id: existingVisit.id,
                imageData: selectedImageData,
                date: date,
                mood: mood,
                observations: observations,
                pointId: point.id
            )
            VisitService.shared.save(updatedVisit)
        } else {
            let newVisit = Visit(
                imageData: selectedImageData,
                date: date,
                mood: mood,
                observations: observations,
                pointId: point.id
            )
            VisitService.shared.save(newVisit)
        }
        dismiss()
    }
}

