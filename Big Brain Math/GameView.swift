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
    @State var selectedId = -1
    @State var isCorrect = false
    @State var score = 0.0
    @State var timeRemaining = 30.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            GeometryReader { metrics in
                VStack (spacing: 5) {
                    HStack {
                        Spacer()
                        Button("Quit") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(Color.primary)
                        .padding(.trailing, 50)
                    }
                    .frame(height: metrics.size.height * 0.06)
                    
                    ProgressView(value: timeRemaining, total: 30)
                        .progressViewStyle(.linear)
                        .frame(width: 320, height: metrics.size.height * 0.09)
                        .scaleEffect(x: 1, y: 4, anchor: .center)
                        .tint(Color.red)
                        .onReceive((timer)) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            }
                        }
                    
                    VStack {
                        HStack {
                            Spacer()
                            QuestionNumbers(number: mathProblem.numberOne)
                        }
                        
                        HStack {
                            Spacer()
                            QuestionOperator(operation: mathProblem.operation)
                            Spacer()
                            QuestionNumbers(number: mathProblem.numberTwo)
                        }
                    }
                    .frame(height: metrics.size.height * 0.36)
                    
                    ProgressView(value: score, total: 20)
                        .progressViewStyle(.linear)
                        .frame(width: 320, height: metrics.size.height * 0.09)
                        .scaleEffect(x: 1, y: 4, anchor: .center)
                        .tint(Color.brandSecondary)
                    
                    VStack (spacing: 10) {
                        ForEach(0 ..< 4) { number in
                            AnswerButton(selectedId: $selectedId, buttonLabel: "\(mathProblem.answersArray[number])", id: number, isCorrect: $isCorrect, score: $score)
                        }
                    }
                    .frame(height: metrics.size.height * 0.36)
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

struct QuestionNumbers: View {
    
    @EnvironmentObject var mathProblem: MathProblem
    var number: Int
    
    var body: some View {
        Text("\(number)")
            .font(.system(size: 140, weight: .semibold))
            .foregroundColor(.flipBrandPrimary)
            .padding(.trailing, 50)
            .minimumScaleFactor(0.01)
    }
}

struct QuestionOperator: View {
    
    @EnvironmentObject var mathProblem: MathProblem
    var operation: String
    
    var body: some View {
        Text("\(operation)")
            .font(.system(size: 140, weight: .semibold))
            .foregroundColor(.flipBrandPrimary)
            .minimumScaleFactor(0.01)
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
            let haptic = UINotificationFeedbackGenerator()
            
            selectedId = self.id
            isCorrect = mathProblem.checkAnswer(answerButton: self)
            
            if isCorrect {
                haptic.notificationOccurred(.success)
                if score < 20 {
                    score += 1
                }
            } else {
                haptic.notificationOccurred(.error)
                if score > 0 {
                    score -= 1
                }
            }
        } label: {
            Text("\(buttonLabel)")
                .frame(maxWidth: 320, maxHeight: .infinity)
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
    @Published var operation = ""
    
    func generateRandomProblem() {
        numberOne = generateNumber()
        numberTwo = generateNumber()
        
        switch operation {
        case "+":
            answer = numberOne + numberTwo
        case "-":
            answer = numberOne - numberTwo
        case "x":
            answer = numberOne * numberTwo
        case "÷":
            answer = numberOne / numberTwo
        default:
            print("Something went wrong with the operation.")
        }
        
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
        
        var answers: [Int] = []
        answers.append(answer);
        
        for _ in 0...2 {
            var randomInt = -1
            repeat {
                randomInt = Int.random(in: (answer - 10)..<(answer + 10))
            } while answers.contains(randomInt)
            
            answers.append(randomInt)
        }
        
        answers.shuffle()
        answerLocation = answers.firstIndex(of: answer)!
        return answers
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
