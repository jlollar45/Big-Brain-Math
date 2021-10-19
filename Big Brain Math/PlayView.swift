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
                        buttonStack(imageName: "plus", level: 1, isShowingGameView: $isShowingGameView)
                        buttonStack(imageName: "minus", level: 1, isShowingGameView: $isShowingGameView)
                    }
                    
                    HStack {
                        buttonStack(imageName: "multiply", level: 1, isShowingGameView: $isShowingGameView)
                        buttonStack(imageName: "divide", level: 1, isShowingGameView: $isShowingGameView)
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

struct buttonStack: View {
    
    var imageName: String
    var level: Int
    @Binding var isShowingGameView: Bool
    
    var body: some View {
        VStack {
            playButton(imageName: imageName, isShowingGameView: $isShowingGameView)
            VStack (spacing: 0) {
                Text("Next Level:")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(Color.flipBrandPrimary)
                Text("Level \(level)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.flipBrandPrimary)
            }
            .padding()
//            .background(Color.flipBrandPrimary)
//            .cornerRadius(25)
//            .shadow(color: .black, radius: 2, x: -2, y: -2)
//            .shadow(color: .black, radius: 2, x: 2, y: 2)
            .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.flipBrandPrimary, lineWidth: 2))
            .shadow(color: Color.invert, radius: 2, x: 2, y: 2)
        }
    }
}

struct PlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 160, height: 160)
            .background(Color.flipBrandPrimary)
            .clipShape(Circle())
            .shadow(color: Color.invert, radius: 3, x: 3, y: 3)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeIn(duration: 0.2), value: configuration.isPressed)
    }
}

struct playButton: View {
    
    var imageName: String
    @Binding var isShowingGameView: Bool
    @State var isTapped: Bool = false
    @EnvironmentObject var mathProblem: MathProblem
    
    var body: some View {
        
        Button(action: {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            setOperation()
            self.isShowingGameView = true
        }) {
            Image(systemName: "\(imageName)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(Color.brandPrimary)
        }
        .buttonStyle(PlayButtonStyle())
        .padding()
        .fullScreenCover(isPresented: $isShowingGameView, content: GameView.init)
        
        
//        ZStack {
//            Image(systemName: "\(imageName)")
//                .font(.system(size: 80, weight: .bold))
//                .foregroundColor(Color.brandPrimary)
//        }
//        .frame(width: 160, height: 160)
//        .background(
//            ZStack {
//                Circle()
//                    .fill(Color("flipBrandPrimary"))
//                    .frame(width: 160, height: 160)
//                    .shadow(color: Color.invert, radius: 3, x: 3, y: 3)
//                    .scaleEffect(self.isTapped ? 0.8 : 1)
//            }
//        )
//        .onTapGesture {
//            setOperation()
//            self.isTapped.toggle()
//            self.isShowingGameView = true
//        }.fullScreenCover(isPresented: $isShowingGameView,
//                          content: GameView.init)
//
//        .padding()
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
