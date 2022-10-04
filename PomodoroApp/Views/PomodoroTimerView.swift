import SwiftUI
import ComposableArchitecture

struct PomodoroTimerView: View {
    let store: Store<PomodoroState, PomodoroAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ProgressBar(store: store)
                    .frame(width: 200, height: 200)
                    .padding(.horizontal, 10.0)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)

                Text(String(format:"%02i:%02i", viewStore.minutes, viewStore.seconds))
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}
