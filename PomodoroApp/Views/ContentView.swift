import SwiftUI
import UserNotifications
import ComposableArchitecture

struct ContentView: View {
    let store: Store<PomodoroState, PomodoroAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.offWhite
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    if viewStore.pomodoroFlag == .finished {
                        StartButton(store: store)
                    } else if viewStore.pomodoroFlag == .inRest || viewStore.pomodoroFlag == .working {
                        PomodoroTimerView(store: store)
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        DetailViewButton(store: store)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}
