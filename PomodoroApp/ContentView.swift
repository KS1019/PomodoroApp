//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Kotaro Suto on 2020/07/26.
//  Copyright © 2020 Kotaro Suto. All rights reserved.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var progressValue: Double = 0
    @State var progressColor: Color = Color.red
    @State var pomodoroFlag: PomodoroState = .finished
    @State var pomodoroCount: Int = 0
    @State var pomodoroLimit: Int = 4
    @State var showingDetail = false
    
    //時間
    @State var workingTime = 25
    @State var restTime = 5
    
    // Variables for Timer Formatting
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    //時間
    let workingSessionTime:TimeInterval = 60 * 25
    let restSessionTime:TimeInterval = 60 * 5
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var secondsPassed: TimeInterval = 0
    var body: some View {
        ZStack {
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                if pomodoroFlag == .finished {
                    Button(action: {
                        print("Hello \(self.pomodoroFlag)")
                        NotificationHandler.shared.askPermission()
                        self.changeState(to: .working)
                        StateHandler.shared.setEndingDate(on: Date().addingTimeInterval(workingSessionTime * 4 + restSessionTime * 3))
                        StateHandler.shared.setWorkingTimeMinutes(min: workingTime)
                        StateHandler.shared.setRestTimeMinutes(min: restTime)
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
                } else if pomodoroFlag == .inRest || pomodoroFlag == .working {
                    ZStack {
                        ProgressBar(progress: self.$progressValue, color: self.$progressColor)
                            .frame(width: 200, height: 200)
                            .padding(.horizontal, 10.0)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            .onReceive(timer, perform: { (timer) in
                                print("Timer: \(timer)")
                                self.secondsPassed += StateHandler.shared.returnSecondsPassed()
                                self.secondsPassed+=0.1
                                StateHandler.shared.secondsPassed = self.secondsPassed
                                self.minutes = Int(self.secondsPassed / 60)
                                self.seconds = Int(self.secondsPassed) % 60
                                if self.pomodoroFlag == .working {
                                    self.progressValue = self.secondsPassed / self.workingSessionTime
                                } else if self.pomodoroFlag == .inRest {
                                    self.progressValue = self.secondsPassed / self.restSessionTime
                                }
                                if self.progressValue >= 1 {
                                    self.changeState(to: (self.pomodoroFlag == .working ? .inRest : .working))
                                }
                            })
                        
                        Text(String(format:"%02i:%02i", minutes, seconds))
                            .font(.largeTitle)
                            .bold()
                    }
                }
                Spacer()
            }
            VStack {
                HStack {
                    Button(action: {
                        self.showingDetail.toggle()
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }
                    .sheet(isPresented: $showingDetail) {
                        DetailView(showingDetail: self.$showingDetail,
                                   pomodoroLimitNum: self.$pomodoroLimit,
                                   pomodoroWorkingTime: self.$workingTime,
                                   pomodoroRestTime: self.$restTime,
                                   currentState: self.$pomodoroFlag)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    func changeState(to state: PomodoroState) {
        StateHandler.shared.changeState(to: state)
        pomodoroFlag = state
        progressValue = 0
        secondsPassed = 0
        minutes = 0
        seconds = 0
        if state == .working {
            progressColor = Color.red
        } else if state == .inRest {
            pomodoroCount += 1
            StateHandler.shared.addPhaseCount(by: 1)
            if pomodoroCount < pomodoroLimit {
                print("pomodoroCount: \(pomodoroCount)")
                progressColor = Color.black
            } else {
                print("Last cycle")
                changeState(to: .finished)
            }
        }
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct ProgressBar: View {
    @Binding var progress: Double
    @Binding var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.offWhite)
            
            Circle()
                .scale(0.83)
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .scale(0.83)
                .trim(from: 0.0, to:min( CGFloat(self.progress), 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

struct DetailView: View {
    @Binding var showingDetail: Bool
    @Binding var pomodoroLimitNum: Int
    @Binding var pomodoroWorkingTime: Int
    @Binding var pomodoroRestTime: Int
    @Binding var currentState: PomodoroState
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Text("Cancel")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
            Group {
                Stepper(value: $pomodoroLimitNum, in: 4...10) {
                    Text("will_do_\(pomodoroLimitNum)_times_of_pomodoro")
                }
                Stepper(value: $pomodoroWorkingTime, in: 20...30) {
                    Text("will_do_tasks_for_\(pomodoroWorkingTime)_min")
                }
                Stepper(value: $pomodoroRestTime, in: 4...10) {
                    Text("will_do_rest_for_\(pomodoroRestTime)_min")
                }
            }
            .disabled(currentState == .working || currentState == .inRest)
            .padding(.bottom, 20)
            Spacer()
            AdmobView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum PomodoroState {
    case working
    case inRest
    case finished
    case interrupted
}

class StateHandler {
    static let shared = StateHandler()
    
    var becameInactiveAt: Date = Date()
    var becameActiveAt: Date = Date()
    var currentState: PomodoroState = .finished
    var secondsUntilNextPhase: TimeInterval = 0
    
    var endingDate: Date = Date()
    
    //時間
    var workingTimeMinutes = 25
    var restTimeMinutes = 5
    
    var secondsPassed: TimeInterval = 0
    var passedPhasesCount: Int = 0
    
    var secondsToBeAdded: TimeInterval = 0
    
    var paris: KeyValuePairs<String, Bool> = [:]
    
    func changeState(to state: PomodoroState) {
        currentState = state
    }
    
    func addPhaseCount(by count: Int) {
        passedPhasesCount += count
    }
    
    func setEndingDate(on endDate: Date) {
        endingDate = endDate
    }
    
    func becomeInactive(at: Date) {
        becameInactiveAt = at
        var totalSecondsAdded: TimeInterval = 0
        if currentState == .working {
            secondsUntilNextPhase = Double(workingTimeMinutes * 60) - secondsPassed
            
            // secondsUntilNextPhase秒後に休憩中の通知
            totalSecondsAdded += secondsUntilNextPhase
            setRestNotification(after: totalSecondsAdded)
            
            // totalSecondsAdded + restTimeMinutes*60秒後にタスク中の通知
            totalSecondsAdded += Double(restTimeMinutes*60)
            setWorkNotification(after: totalSecondsAdded)
        } else if currentState == .inRest {
            secondsUntilNextPhase = Double(restTimeMinutes * 60) - secondsPassed
            // secondsUntilNextPhase秒後にタスク中の通知
            totalSecondsAdded += secondsUntilNextPhase
            setWorkNotification(after: totalSecondsAdded)
        }
        
        let numOfPhasesLeft = 3 - passedPhasesCount
        for i in 0 ..< numOfPhasesLeft {
            if i == numOfPhasesLeft - 1 {
                //totalSecondsAdded + workingTimeMinutes*60秒後に終了の通知
                totalSecondsAdded += Double(workingTimeMinutes*60)
                setNotification(title: NSLocalizedString("pomodoro_ended", comment: ""),
                                msg: NSLocalizedString("pomodoro_end_msg", comment: ""),
                                after: totalSecondsAdded)
            } else {
                //totalSecondsAdded + workingTimeMinutes*60秒後に休憩中の通知
                totalSecondsAdded += Double(workingTimeMinutes*60)
                setRestNotification(after: totalSecondsAdded)
                //totalSecondsAdded + restTimeMinutes*60秒後にタスク中の通知
                totalSecondsAdded += Double(restTimeMinutes*60)
                setWorkNotification(after: totalSecondsAdded)
            }
        }
        
    }
    
    func becomeActive(at: Date) {
        becameActiveAt = at
        let inactiveTime = becameActiveAt.timeIntervalSince(becameInactiveAt)
        
        NotificationHandler.shared.cancelAllPendingNotifications()
        secondsToBeAdded = inactiveTime
        //        if inactiveTime < secondsUntilNextPhase {
        //            //フェーズが変わる前に復帰
        //            NotificationHandler.shared.cancelAllPendingNotifications()
        //            //すべての残り時間を調整
        //            secondsToBeAdded = inactiveTime
        //        } else if Date() > endingDate {
        //            //フェーズが全て終了後に復帰
        //            //すべての残り時間を調整
        //            secondsToBeAdded = inactiveTime
        //        } else {
        //            //Dictionaryで通知やフェーズが終了してるかを管理
        //            //https://dev.classmethod.jp/articles/about-swiftkeyvaluepairs/
        //            //https://developer.apple.com/documentation/swift/keyvaluepairs
        //        }
    }
    
    func returnSecondsPassed() -> TimeInterval {
        if secondsToBeAdded > 0 {
            let temp = secondsToBeAdded
            secondsToBeAdded = 0
            return temp
        }
        
        return 0
    }
    
    func setNotification(title: String, msg: String, after: TimeInterval) {
        let uuid = UUID().uuidString
        let req = NotificationHandler.shared.requestLocalNotification(requestID: uuid, title: title, message: msg, after: after)
        
        NotificationHandler.shared.add(notificationRequest: req)
    }
    
    func setRestNotification(after: TimeInterval) {
        setNotification(title: NSLocalizedString("time_for_rest", comment: ""),
                        msg: String(format: NSLocalizedString("take_%lld_min_rest", comment: ""), restTimeMinutes), after: after)
    }
    
    func setWorkNotification(after: TimeInterval) {
        setNotification(title: NSLocalizedString("time_for_task", comment: ""),
                        msg: String(format: NSLocalizedString("do_work_for_%lld_min", comment: ""), workingTimeMinutes), after: after)
    }
    
    func setRestTimeMinutes(min: Int) {
        restTimeMinutes = min
    }
    
    func setWorkingTimeMinutes(min: Int) {
        workingTimeMinutes = min
    }
}

struct PomodoroStateStruct {
    var currentState: PomodoroState = .finished
    var pomodoroLimit: Int = 4
    var pomodoroCount: Int = 0
    var secondsPassed: TimeInterval = 0
    var secondsUntilNext: TimeInterval = 0
    var phasesPassed: Int = 0
    var phasesLeft: Int = 0
    var endsAt: Date = Date()
}
