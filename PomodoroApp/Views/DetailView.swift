import ComposableArchitecture
import SwiftUI

struct DetailView: View {
    let store: Store<PomodoroState, PomodoroAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color.offWhite
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            viewStore.send(.setShowingDetail(to: false))
                        }) {
                            Text("Cancel")
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                    }
                    Form {
                        Stepper(value: viewStore.binding(get: \.pomodoroLimit,
                                                         send: PomodoroAction.setPomodoroLimit(to:)), in: 4 ... 10) {
                            Text("will_do_\(viewStore.pomodoroLimit)_times_of_pomodoro")
                        }
                        Stepper(value: viewStore.binding(get: \.workingTimeMinutes,
                                                         send: PomodoroAction.setWorkingTime(to:)), in: 20 ... 30) {
                            Text("will_do_tasks_for_\(viewStore.workingTimeMinutes)_min")
                        }
                        Stepper(value: viewStore.binding(get: \.restTimeMinutes,
                                                         send: PomodoroAction.setRestTime(to:)), in: 4 ... 10) {
                            Text("will_do_rest_for_\(viewStore.restTimeMinutes)_min")
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .disabled(viewStore.pomodoroFlag == .working || viewStore.pomodoroFlag == .inRest)
                    .padding(.bottom, 20)
                    Spacer()
                    AdmobView()
                }
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
