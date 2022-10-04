import Foundation
import ComposableArchitecture

struct PomodoroEnvironment {
    let notification: NotificationHandler
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
