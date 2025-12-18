import SwiftUI

struct SettingsView: View {
    @State private var remindersEnabled = true

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HeaderView(title: "Settings")

                settingsCard

                Spacer()
            }
            .bgSetup()
        }
    }

    private var settingsCard: some View {
        VStack(spacing: 12) {
            settingsRow(
                title: "Reminders",
                accessory: {
                    Image(remindersEnabled ? .reminderOn : .reminderOff)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 83, height: 49)
                }
            )
            .onTapGesture {
                remindersEnabled.toggle()
            }

            settingsRow(
                title: "About the App",
                accessory: {
                    Image(.navigate)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 57, height: 55)
                }
            )
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.greenBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.greenBorder, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }

    private func settingsRow<Accessory: View>(title: String, @ViewBuilder accessory: () -> Accessory) -> some View {
        HStack {
            Text(title)
                .font(.signikaBold(size: 25))
                .foregroundColor(.white)

            Spacer()

            accessory()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.greenLight)
        )
    }
}

