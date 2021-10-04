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
                    AnswerButton(buttonLabel: "\(mathProblem.answersArray[0])")
                    AnswerButton(buttonLabel: "\(mathProblem.answersArray[1])")
                    AnswerButton(buttonLabel: "\(mathProblem.answersArray[2])")
                    AnswerButton(buttonLabel: "\(mathProblem.answersArray[3])")
                }
            }
        }
        .onAppear() {
            mathProblem.generateRandomProblem()
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
            mathProblem.checkAnswer(buttonLabel: buttonLabel)
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
    @Published var answersArray = [0, 0, 0, 0]
    @Published var answer = 0
    
    func generateRandomProblem() {
        numberOne = generateNumber()
        numberTwo = generateNumber()
        
        answer = numberOne + numberTwo
        answersArray = generateAnswersArray(answer: answer)
    }
    
    func generateNumber() -> Int {
        let randomInt = Int.random(in: 1..<20)
        return randomInt
    }
    
    func generateRandomLocation() -> Int {
        let randomLocation = Int.random(in: 0...3)
        return randomLocation
    }
    
    func generateAnswersArray(answer: Int) -> [Int] {
        
        let answerLocation = generateRandomLocation()
        var randomAnswers: [Int] = []
        
        for index in 0...3 {
            if answerLocation == index {
                randomAnswers.append(answer)
            } else {
                let randomInt = Int.random(in: (answer - 10)..<(answer + 10))
                randomAnswers.append(randomInt)
            }
        }
        
        return randomAnswers
    }
    
    func checkAnswer(buttonLabel: String) {
        
        let selectedAnswer = Int(buttonLabel)
        
        if selectedAnswer == answer {
            print("Correct!")
        } else {
            print("WRONG :-(")
        }
        
        generateRandomProblem()
    }
}
