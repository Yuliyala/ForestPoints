import SwiftUI

struct MoodPickerView: View {
    @Binding var selectedMood: MoodType
    @State private var tempSelectedMood: MoodType?
    var onDismiss: (() -> Void)?
    var onConfirm: (() -> Void)?
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    init(selectedMood: Binding<MoodType>, onDismiss: (() -> Void)? = nil, onConfirm: (() -> Void)? = nil) {
        self._selectedMood = selectedMood
        self._tempSelectedMood = State(initialValue: nil)
        self.onDismiss = onDismiss
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            moodsGrid
            confirmButton
        }
        .frame(height: 517)
        .background(backgroundView)
    }
    
    private var headerSection: some View {
        HStack {
            Text("MOOD")
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
    
    private var moodsGrid: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ForEach(Array(MoodType.allCases.prefix(2)), id: \.self) { mood in
                    moodButton(for: mood)
                }
            }
            
            if MoodType.allCases.count > 2 {
                HStack {
                    Spacer()
                    moodButton(for: MoodType.allCases[2])
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    
    private func moodButton(for mood: MoodType) -> some View {
        Button {
            tempSelectedMood = mood
        } label: {
            VStack(spacing: 10) {
                Spacer()
                
                Image(mood.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                Text(mood.title.uppercased())
                    .font(.signikaBold(size: 18))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(13)
            .frame(width: 146, height: 141)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(tempSelectedMood == mood ? Color.yellowButton : Color.greenLight)
            )
        }
    }
    
    private var confirmButton: some View {
        Button {
            if let tempSelectedMood = tempSelectedMood {
                selectedMood = tempSelectedMood
                onConfirm?()
                onDismiss?()
            }
        } label: {
            Image(tempSelectedMood == nil ? .doneButtonOff : .doneButton)
                .resizable()
                .scaledToFit()
                .frame(width: 86, height: 83)
        }
        .disabled(tempSelectedMood == nil)
        .padding(.top, 32)
        .padding(.bottom, 24)
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 40)
            .fill(Color.greenOverlay)
    }
}

