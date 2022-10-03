import Foundation
import ComposableArchitecture

public enum PomodoroAction: Equatable {
    case pomodoroStarted
    case pomodoroIncrementSecond
    case pomodoroFinished
    case detailViewButtonTapped
    case cancelButtonTapped
    case setShowingDetail(to: Bool)
    case setPomodoroLimit(to: Int)
    case setWorkingTime(to: Int)
    case setRestTime(to: Int)
    case appInactivated(Date)
    case appActivated(Date)
}
