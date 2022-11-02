import ComposableArchitecture
import SwiftUI
import UserNotifications

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
                        HistoryViewButton(store: store)
                    }
                    Spacer()
                }
            }
        }
    }
}
