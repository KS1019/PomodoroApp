import SwiftUI
import UserNotifications
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

struct DetailViewButton: View {
    let store: Store<PomodoroState, PomodoroAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.detailViewButtonTapped)
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .padding()
            }
            .sheet(isPresented: viewStore.binding(
                get: \.showingDetail,
                send: PomodoroAction.setShowingDetail(to:)
            )) {
                DetailView(store: store)
            }
        }
    }
}

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
