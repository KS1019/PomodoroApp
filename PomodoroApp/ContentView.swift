//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Kotaro Suto on 2020/07/26.
//  Copyright © 2020 Kotaro Suto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var progressValue: Float = 0.2
    @State var progressColor: Color = Color.red
    @State var pomodoroFlag: PomodoroState = .finished
    var body: some View {
        ZStack {
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                if pomodoroFlag == .finished {
                    Button(action: {
                        print("Hello \(self.pomodoroFlag)")
                        self.pomodoroFlag = .working
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.offWhite)
                                .frame(width: 200, height: 200)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            Text("Hello")
                        }
                    }
                } else if pomodoroFlag == .inRest || pomodoroFlag == .working {
                    ProgressBar(progress: self.$progressValue, color: self.$progressColor)
                        .frame(width: 200, height: 200)
                        .padding(.horizontal, 10.0)
                        .onAppear {
                            print("h \(self.pomodoroFlag)")
                    }
                } else {
                    
                }
                Spacer()
            }
        }
        .onAppear {
            print("Hlo \(self.pomodoroFlag)")
        }
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct ProgressBar: View {
    @Binding var progress: Float
    @Binding var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to:min( CGFloat(self.progress), 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f %min", min(self.progress, 1.0)*25.0))
                .font(.largeTitle)
                .bold()
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
