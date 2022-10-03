import SwiftUI
import ComposableArchitecture

struct ProgressBar: View {
    let store: Store<PomodoroState, PomodoroAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Circle()
                    .fill(Color.offWhite)

                Circle()
                    .scale(0.83)
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(viewStore.progressColor)

                Circle()
                    .scale(0.83)
                    .trim(from: 0.0, to: min(CGFloat(viewStore.progressValue), 1.0))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(viewStore.progressColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: 0)
            }
        }
    }
}
