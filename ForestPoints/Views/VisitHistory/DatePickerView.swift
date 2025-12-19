import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @State private var tempSelectedDate: Date
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._tempSelectedDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            datePickerSection
            
            Spacer()
            
            confirmButton
        }
    }
    
    private var datePickerSection: some View {
        DatePicker("", selection: $tempSelectedDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.greenBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.greenBorder, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .colorScheme(.dark)
    }
    
    private var confirmButton: some View {
        Button(action: {
            selectedDate = tempSelectedDate
        }) {
            Image(.doneButton)
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 108)
        }
        .padding(.bottom, 20)
    }
}
