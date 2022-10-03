import Foundation
import SwiftUI
import ComposableArchitecture

let pomodoroReducer = Reducer<PomodoroState, PomodoroAction, PomodoroEnvironment> { state, action, environment in
    struct TimerID: Hashable {}
    let incrementSecond = 0.1

    switch action {
        case .pomodoroStarted:
            let workingSessionTime: TimeInterval = TimeInterval(60 * state.workingTime)
            let restSessionTime: TimeInterval = TimeInterval(60 * state.restTime)
            environment.notification.askPermission()
            // state.currentState = .working
            state.progressValue = 0
            state.secondsPassed = 0
            state.minutes = 0
            state.seconds = 0
            if state.pomodoroFlag == .working {
                state.progressColor = Color.red
            } else if state.pomodoroFlag == .inRest {
                state.pomodoroCount += 1
                // state.passedPhasesCount += count
                if state.pomodoroCount < state.pomodoroLimit {
                    state.progressColor = Color.black
                } else {
                    state.pomodoroFlag = .finished
                }
            }
//            state.endingDate = Date().addingTimeInterval(workingSessionTime * 4 + restSessionTime * 3)
//            state.wor
//            StateHandler.shared.setWorkingTimeMinutes(min: workingTime)
//            StateHandler.shared.setRestTimeMinutes(min: restTime)
            return Effect
                .timer(id: TimerID(), every: DispatchQueue.SchedulerTimeType.Stride(floatLiteral: incrementSecond), on: environment.mainQueue)
                .map { _ in .pomodoroIncrementSecond }
        case .pomodoroIncrementSecond:
//            state.secondsPassed += {
//                if secondsToBeAdded > 0 {
//                    let temp = secondsToBeAdded
//                    secondsToBeAdded = 0
//                    return temp
//                }
//
//                return 0
//            }()
            state.secondsPassed += incrementSecond
            state.minutes = Int(state.secondsPassed / 60)
            state.seconds = Int(state.secondsPassed) % 60
            if state.pomodoroFlag == .working {
                state.progressValue = state.secondsPassed / Double(state.workingTime)
            } else if state.pomodoroFlag == .inRest {
                state.progressValue = state.secondsPassed / Double(state.restTime)
            }
            if state.progressValue >= 1 {
                state.pomodoroFlag = state.pomodoroFlag == .working ? .inRest : .working
            }
            print("TEST")
            print(state.secondsPassed)
            return .none
        case .pomodoroFinished:
            return .none
        case .detailViewButtonTapped:
            state.showingDetail = true
            return .none
        case .cancelButtonTapped:
            state.showingDetail = false
            return .none
        case .setShowingDetail(let to):
            state.showingDetail = to
            return .none
        case .setPomodoroLimit(let to):
            state.pomodoroLimit = to
            return .none
        case .setWorkingTime(let to):
            state.workingTime = to
            return .none
        case .setRestTime(let to):
            state.restTime = to
            return .none
        case .appInactivated(let date):
//            //state.becameInactiveAt = date
//            var totalSecondsAdded: TimeInterval = 0
//            if state.pomodoroFlag == .working {
//                state.secondsUntilNextPhase = Double(state.workingTimeMinutes * 60) - state.secondsPassed
//
//                // secondsUntilNextPhase秒後に休憩中の通知
//                totalSecondsAdded += state.secondsUntilNextPhase
//                environment.notification.setNotification(
//                    title: NSLocalizedString("time_for_rest", comment: ""),
//                    msg: String(format: NSLocalizedString("take_%lld_min_rest", comment: ""), state.restTimeMinutes),
//                    after: totalSecondsAdded)
//
//                // totalSecondsAdded + restTimeMinutes*60秒後にタスク中の通知
//                totalSecondsAdded += Double(state.restTimeMinutes*60)
//                environment.notification.setNotification(
//                    title: NSLocalizedString("time_for_task", comment: ""),
//                    msg: String(format: NSLocalizedString("do_work_for_%lld_min", comment: ""), state.workingTimeMinutes),
//                    after: totalSecondsAdded)
//            } else if state.currentState == .inRest {
//                state.secondsUntilNextPhase = Double(state.restTimeMinutes * 60) - state.secondsPassed
//                // secondsUntilNextPhase秒後にタスク中の通知
//                totalSecondsAdded += state.secondsUntilNextPhase
//                environment.notification.setNotification(
//                    title: NSLocalizedString("time_for_task", comment: ""),
//                    msg: String(format: NSLocalizedString("do_work_for_%lld_min", comment: ""), state.workingTimeMinutes),
//                    after: totalSecondsAdded)
//            }
//
//            let numOfPhasesLeft = 3 - state.passedPhasesCount
//            for i in 0 ..< numOfPhasesLeft {
//                if i == numOfPhasesLeft - 1 {
//                    //totalSecondsAdded + workingTimeMinutes*60秒後に終了の通知
//                    totalSecondsAdded += Double(state.workingTimeMinutes*60)
//                    environment.notification.setNotification(title: NSLocalizedString("pomodoro_ended", comment: ""),
//                                    msg: NSLocalizedString("pomodoro_end_msg", comment: ""),
//                                    after: totalSecondsAdded)
//                } else {
//                    //totalSecondsAdded + workingTimeMinutes*60秒後に休憩中の通知
//                    totalSecondsAdded += Double(state.workingTimeMinutes*60)
//                    environment.notification.setNotification(
//                        title: NSLocalizedString("time_for_rest", comment: ""),
//                        msg: String(format: NSLocalizedString("take_%lld_min_rest", comment: ""), state.restTimeMinutes),
//                        after: totalSecondsAdded)
//                    //totalSecondsAdded + restTimeMinutes*60秒後にタスク中の通知
//                    totalSecondsAdded += Double(state.restTimeMinutes*60)
//                    environment.notification.setNotification(
//                        title: NSLocalizedString("time_for_task", comment: ""),
//                        msg: String(format: NSLocalizedString("do_work_for_%lld_min", comment: ""), state.workingTimeMinutes),
//                        after: totalSecondsAdded)
//                }
//            }

            return .none
        case .appActivated(let date):
//            state.becameActiveAt = date
//            let inactiveTime = state.becameActiveAt.timeIntervalSince(state.becameInactiveAt)
//
//            environment.notification.cancelAllPendingNotifications()
//            state.secondsToBeAdded = inactiveTime
            return .none
    }
}
