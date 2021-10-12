//
//  PlayView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/28/21.
//

import SwiftUI

struct PlayView: View {
    
    @State private var isShowingGameView = false
    @EnvironmentObject var mathProblem: MathProblem
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        playButton(imageName: "plus", isShowingGameView: $isShowingGameView)
                        playButton(imageName: "minus", isShowingGameView: $isShowingGameView)
                    }
                    
                    HStack {
                        playButton(imageName: "multiply", isShowingGameView: $isShowingGameView)
                        playButton(imageName: "divide", isShowingGameView: $isShowingGameView)
                    }
                }
                .navigationTitle("Play Games")
            }
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}

struct playButton: View {
    
    var imageName: String
    @Binding var isShowingGameView: Bool
    @EnvironmentObject var mathProblem: MathProblem
    
    var body: some View {
        ZStack {
            Image(systemName: "\(imageName)")
                .font(.system(size: 80, weight: .bold))
        }
        .frame(width: 160, height: 160)
        .background(
            ZStack {
                Circle()
                    .fill(Color("brandPrimary"))
                    .frame(width: 160, height: 160)
                    .shadow(color: .white, radius: 2, x: -2, y: -2)
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
            }
        )
        .onTapGesture {
            setOperation()
            self.isShowingGameView = true
        }.fullScreenCover(isPresented: $isShowingGameView,
                          content: GameView.init)
        .padding()
    }
    
    func setOperation() {
        switch imageName {
        case "plus":
            mathProblem.operation = "+"
        case "minus":
            mathProblem.operation = "-"
        case "multiply":
            mathProblem.operation = "x"
        case "divide":
            mathProblem.operation = "÷"
        default:
            print("No image selected")
        }
    }
}
