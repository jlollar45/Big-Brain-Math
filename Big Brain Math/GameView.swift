//
//  GameView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/30/21.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var mathProblem = MathProblem()
    @State var selectedId = -1
    @State var isCorrect = false
    @State var score = 0.0
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Quit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.primary)
                    .padding(.trailing, 50)
                }
                
                ProgressView(value: score, total: 20)
                    .progressViewStyle(.linear)
                    .frame(width: 320, height: 80)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .tint(Color.brandSecondary)
                
                
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
                    AnswerButton(selectedId: $selectedId, buttonLabel: "\(mathProblem.answersArray[0])", id: 0, isCorrect: $isCorrect, score: $score)
                    AnswerButton(selectedId: $selectedId, buttonLabel: "\(mathProblem.answersArray[1])", id: 1, isCorrect: $isCorrect, score: $score)
                    AnswerButton(selectedId: $selectedId, buttonLabel: "\(mathProblem.answersArray[2])", id: 2, isCorrect: $isCorrect, score: $score)
                    AnswerButton(selectedId: $selectedId, buttonLabel: "\(mathProblem.answersArray[3])", id: 3, isCorrect: $isCorrect, score: $score)
                }
            }
        }
        .onAppear() {
            mathProblem.generateRandomProblem()
        }
        .environmentObject(mathProblem)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct AnswerButton: View {
    
    @EnvironmentObject var mathProblem: MathProblem
    @Binding var selectedId: Int
    var buttonLabel: String
    var id: Int
    @Binding var isCorrect: Bool
    @Binding var score: Double
    
    var body: some View {
        Button {
            selectedId = self.id
            isCorrect = mathProblem.checkAnswer(answerButton: self)
            if isCorrect {
                if score < 20 {
                    score += 1
                }
            } else {
                if score > 0 {
                    score -= 1
                }
            }
        } label: {
            Text("\(buttonLabel)")
                .frame(width: 320, height: 60)
                .background(
                    selectedId == id ? (isCorrect == true ? .green : .red ) : Color.flipBrandPrimary
                )
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
    @Published var answerLocation = -1
    @Published var selectedId = -1
    
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
        
        answerLocation = generateRandomLocation()
        var randomAnswers: [Int] = []
        
        for index in 0...3 {
            if answerLocation == index {
                randomAnswers.append(answer)
            } else {
                var randomInt = -1
                
                repeat {
                    randomInt = Int.random(in: (answer - 10)..<(answer + 10))
                } while randomInt == answer

                //let randomInt = Int.random(in: (answer - 10)..<(answer + 10))
                randomAnswers.append(randomInt)
            }
        }
        
        return randomAnswers
    }
    
    func checkAnswer(answerButton: AnswerButton) -> Bool {

        let selectedAnswer = Int(answerButton.buttonLabel)
        selectedId = answerButton.id
        var isCorrect = false

        if selectedAnswer == answer {
            isCorrect = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            answerButton.selectedId = -1
            self.generateRandomProblem()
        }
        
        return isCorrect
    }
}
