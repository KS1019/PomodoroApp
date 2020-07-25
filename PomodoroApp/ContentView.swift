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
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                ProgressBar(progress: self.$progressValue)
                    .frame(width: 200, height: 200)
                    .padding(.horizontal, 10.0)
                
                Spacer()
            }
        }
    }
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.black)
            
            Circle()
                .trim(from: 0.0, to:min( CGFloat(self.progress), 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.black)
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
