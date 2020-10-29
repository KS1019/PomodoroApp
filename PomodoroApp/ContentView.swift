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
    @State var workingTime = 25
    @State var restTime = 5
    
    // Variables for Timer Formatting
    @State var minutes: Int = 0
    @State var seconds: Int = 0

    let workingSessionTime:TimeInterval = 60 * 25
    let restSessionTime:TimeInterval = 60 * 5
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var secondsPassed: TimeInterval = 0
    var body: some View {
        ZStack {
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
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
                                   pomodoroRestTime: self.$restTime)
                    }
                    Spacer()
                }
                Spacer()
                if pomodoroFlag == .finished {
                    Button(action: {
                        print("Hello \(self.pomodoroFlag)")
                        self.changeState(to: .working)
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
                                self.secondsPassed+=0.1
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
            
        }
    }
    
    func changeState(to state: PomodoroState) {
        pomodoroFlag = state
        progressValue = 0
        secondsPassed = 0
        minutes = 0
        seconds = 0
        if state == .working {
            progressColor = Color.red
        } else if state == .inRest {
            pomodoroCount += 1
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
            
            Stepper(value: $pomodoroLimitNum, in: 4...10) {
                Text("\(pomodoroLimitNum)回 ポモドロをします")
            }
            Stepper(value: $pomodoroWorkingTime, in: 20...30) {
                Text("\(pomodoroWorkingTime)分 タスクをします")
            }
            Stepper(value: $pomodoroRestTime, in: 4...10) {
                Text("\(pomodoroRestTime)分 休憩します")
            }
            Spacer()
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
