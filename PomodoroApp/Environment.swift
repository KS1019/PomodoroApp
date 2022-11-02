import ComposableArchitecture
import DefaultsWrapper
import Foundation

struct PomodoroEnvironment {
    let notification: NotificationHandler
    var mainQueue: AnySchedulerOf<DispatchQueue>
    @Defaults(.history)
    var history: [Date] = []
}
