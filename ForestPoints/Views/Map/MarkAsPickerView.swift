import SwiftUI

struct MarkAsPickerView: View {
    let point: ForestPoint
    @State private var tempSelectedMarkAs: MarkAsType?
    @State private var desiredDate: Date?
    @State private var showDatePicker = false
    var onDismiss: (() -> Void)?
    
    init(point: ForestPoint, onDismiss: (() -> Void)? = nil) {
        self.point = point
        self._tempSelectedMarkAs = State(initialValue: nil)
        self._desiredDate = State(initialValue: point.desiredDate)
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            markAsGrid
            desiredDateSection
            confirmButton
        }
        .frame(height: 650)
        .background(backgroundView)
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                DatePickerView(selectedDate: Binding(
                    get: { desiredDate ?? Date() },
                    set: { desiredDate = $0 }
                ))
                .onDisappear {
                    if desiredDate == nil {
                        desiredDate = Date()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("MARK AS")
                .font(.signikaBold(size: 35))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                onDismiss?()
            } label: {
                Image(.closeButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var markAsGrid: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ForEach(Array(MarkAsType.allCases.prefix(2)), id: \.self) { type in
                    markAsButton(for: type)
                }
            }
            
            if MarkAsType.allCases.count > 2 {
                HStack {
                    Spacer()
                    markAsButton(for: MarkAsType.allCases[2])
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    
    private func markAsButton(for type: MarkAsType) -> some View {
        Button {
            tempSelectedMarkAs = type
        } label: {
            VStack(spacing: 4) {
                Spacer()
                Text(type.title.uppercased())
                    .font(.signikaBold(size: 20))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
    
                Image(type.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 74, height: 73)
                
                Spacer()
            }
            .frame(width: 146, height: 141)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(tempSelectedMarkAs == type ? Color.yellowButton : Color.greenLight)
            )
        }
    }
    
    private var desiredDateSection: some View {
        Button(action: {
            showDatePicker = true
        }) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("DESIRED DATE")
                        .font(.signikaBold(size: 25))
                        .foregroundColor(.white)
                    
                    Text(formattedDate)
                        .font(.signikaBold(size: 25))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(.calendar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 74, height: 63)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(height: 83)
            .background(Color.greenLight)
            .cornerRadius(25)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var confirmButton: some View {
        Button {
            saveMarkAs()
        } label: {
            Image(tempSelectedMarkAs == nil ? .doneButtonOff : .doneButton)
                .resizable()
                .scaledToFit()
                .frame(width: 86, height: 83)
        }
        .disabled(tempSelectedMarkAs == nil)
        .padding(.top, 24)
        .padding(.bottom, 24)
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color.greenOverlay)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: desiredDate ?? Date())
    }
    
    private func saveMarkAs() {
        var updatedPoint = point
        updatedPoint.markAsType = tempSelectedMarkAs
        updatedPoint.desiredDate = desiredDate
        ForestPointService.shared.save(updatedPoint)
        onDismiss?()
    }
}

extension MarkAsType: CaseIterable {
    static var allCases: [MarkAsType] {
        [.wantToComeBack, .placesForAutumn, .placesForSunrise]
    }
}

