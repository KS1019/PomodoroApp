//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Kotaro Suto on 2020/07/26.
//  Copyright © 2020 Kotaro Suto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var progressValue: Double = 0
    @State var progressColor: Color = Color.red
    @State var pomodoroFlag: PomodoroState = .finished
    @State var pomodoroCount: Int = 0
    @State var pomodoroLimit: Int = 4
    var workingSessionTime:TimeInterval = 60 * 25
    var restSessionTime:TimeInterval = 60 * 5
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
                                self.progressValue = self.secondsPassed / self.workingSessionTime
                                if self.progressValue >= 1 {
                                    self.changeState(to: (self.pomodoroFlag == .working ? .inRest : .working))
                                }
                            })
                        if pomodoroFlag == .working {
                            Text(String(format: "%.0f %min", floor(min(self.progressValue, 1.0)*workingSessionTime / 60)))
                            .font(.largeTitle)
                            .bold()
                        } else if pomodoroFlag == .inRest {
                            Text(String(format: "%.0f %min", floor(min(self.progressValue, 1.0)*restSessionTime / 60)))
                                .font(.largeTitle)
                                .bold()
                        }
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
