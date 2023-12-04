//
//  ActivityIndicatorView.swift
//  ActivityIndicator
//  Copyright (c) Muhammad Usman Saeed
//
//  Using xCode 12.3, Swift 5.0
//  Running on macOS 12.6
//  Created on 12/04/23
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

struct ActivityIndicatorView: View {
    
    let trackRotation : Double = 2
    let animationDuration : Double = 0.75
    
    @State var circleStart : CGFloat = 0.17
    @State var circleEnd : CGFloat = 0.325
    @State var rotationDegree : Angle = Angle.degrees(0)
    
    let circleGradient = LinearGradient(colors: [Color.circleStart, Color.circleEnd], startPoint: .topLeading, endPoint: .trailing)
    let hudsize : CGFloat = 200
    
    var body: some View {
        
        ZStack {
            
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .frame(width: hudsize, height: hudsize, alignment: Alignment(horizontal: .center, vertical: .center))
                .cornerRadius(20)
            
            ZStack {
                Circle()
                    .trim(from: circleStart, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .fill(circleGradient)
                    .rotationEffect(self.rotationDegree)
                
            }.frame(width: hudsize/1.3, height: hudsize/1.3)
                .onAppear {
                    self.animateLoader()
                    
                    Timer.scheduledTimer(withTimeInterval: self.trackRotation * self.animationDuration + (self.animationDuration), repeats: true) { _ in
                        self.animateLoader()
                    }
                    
                }
            
        }
        
    }
    
    
    func getRotationAngle() -> Angle {
        return .degrees(360 * self.trackRotation) + .degrees(120)
    }
    
    func animateLoader() {
        
        withAnimation(Animation.spring(response: animationDuration * 2)) {
            self.rotationDegree = .degrees(-57.5)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.trackRotation * self.animationDuration)) {
                self.rotationDegree += self.getRotationAngle()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: (self.trackRotation * self.animationDuration) / 2.25)) {
                self.circleEnd = 0.925
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: trackRotation * animationDuration, repeats: false) { _ in
            self.rotationDegree = .degrees(47.5)
            withAnimation(Animation.easeOut(duration: self.animationDuration)) {
                self.circleEnd = 0.325
            }
        }
        
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
