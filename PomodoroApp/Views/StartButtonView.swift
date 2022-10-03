import SwiftUI
import ComposableArchitecture

struct StartButton: View {
    let store: Store<PomodoroState, PomodoroAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.pomodoroStarted)
            }) {
                ZStack {
                    Circle()
                        .fill(Color.offWhite)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    Text("Start")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}
