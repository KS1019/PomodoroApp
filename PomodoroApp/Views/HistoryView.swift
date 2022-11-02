import ComposableArchitecture
import DefaultsWrapper
import SwiftUI

struct HistoryView: View {
    @Defaults(.history)
    var histories: [Date] = []

    var body: some View {
        ZStack {
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
            if !histories.isEmpty {
                List(histories, id: \.self) { history in
                    HistoryItemView(date: history.formatted())
                }
                .background(.clear)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

struct HistoryItemView: View {
    var date: String
    var body: some View {
        HStack {
            Text(date)
            ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!,
                      subject: Text("Join me in becoming more productive!"),
                      message: Text("I did a pomodoro session on \(date)!"))
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

extension UserDefaultsKeyName {
    static var history: UserDefaultsKeyName { "history" }
}

struct HistoryViewButton: View {
    let store: Store<PomodoroState, PomodoroAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.setIsHistoryViewShown(to: true))
            }) {
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .padding()
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isHistoryViewShown,
                send: PomodoroAction.setIsHistoryViewShown(to:)
            )) {
                HistoryView()
            }
        }
    }
}
