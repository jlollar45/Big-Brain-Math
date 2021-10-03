//
//  GameView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/30/21.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mathProblem: MathProblem
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Score")
                    Button("X") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        Text("\(mathProblem.numberOne)")
                            .font(.system(size: 140, weight: .semibold))
                            .foregroundColor(.flipBrandPrimary)
                            .padding(.trailing, 50)
                    }
                    
                    HStack {
                        Spacer()
                        Text("+")
                            .font(.system(size: 140, weight: .semibold))
                            .foregroundColor(.flipBrandPrimary)
                        Spacer()
                        Text("\(mathProblem.numberTwo)")
                            .font(.system(size: 140, weight: .semibold))
                            .foregroundColor(.flipBrandPrimary)
                            .padding(.trailing, 50)
                    }
                }
                
                VStack {
                    AnswerButton(buttonLabel: "\(mathProblem.answer)")
                    AnswerButton(buttonLabel: "\(mathProblem.wrongAnswers[0])")
                    AnswerButton(buttonLabel: "\(mathProblem.wrongAnswers[1])")
                    AnswerButton(buttonLabel: "\(mathProblem.wrongAnswers[2])")
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct AnswerButton: View {
    
    @EnvironmentObject var mathProblem: MathProblem
    
    var buttonLabel: String
    
    var body: some View {
        Button {
            mathProblem.generateRandomProblem()
        } label: {
            Text("\(buttonLabel)")
                .frame(width: 320, height: 60)
                .background(Color.flipBrandPrimary)
                .foregroundColor(Color.brandPrimary)
                .cornerRadius(20.0)
                .font(.largeTitle)
        }
    }
}

final class MathProblem: ObservableObject {
    
    @Published var numberOne: Int = 0
    @Published var numberTwo: Int = 0
    @Published var answer: Int = 0
    @Published var wrongAnswers: [Int] = [0, 0, 0]
    
    func generateRandomProblem() {
        numberOne = generateNumber()
        numberTwo = generateNumber()
        answer = numberOne + numberTwo
        
        wrongAnswers = generateWrongAnswers()
    }
    
    func generateNumber() -> Int {
        let randomInt = Int.random(in: 1..<20)
        return randomInt
    }
    
    func generateWrongAnswers() -> [Int] {
        
        var randomAnswers: [Int] = []
        
        for _ in 1...3 {
            let randomInt = Int.random(in: 10..<30)
            randomAnswers.append(randomInt)
        }
        
        return randomAnswers
    }
}
