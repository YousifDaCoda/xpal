import SwiftUI

struct LanguageQuiz: View {
    let language: Language
    
    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var showFinalScore = false
    
    var questions: [Question] {
        let phrases = language.commonPhrases
        _ = Array(phrases.values)
        
        return [
            createQuestion(for: "Hello"),
            createQuestion(for: "Bye"),
            createQuestion(for: "Yes"),
            createQuestion(for: "No")
        ]
    }
    
    var body: some View {
        VStack {
            if showFinalScore {
                VStack {
                    Text("Quiz Finished!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Correct Answers: \(correctAnswers) / \(questions.count)")
                        .font(.title2)
                        .padding()
                }
            } else {
                QuestionView(
                    question: questions[currentQuestionIndex],
                    answerSelected: { selected in
                        handleAnswer(selected: selected, correct: questions[currentQuestionIndex].answer)
                    }
                )

            }
        }
        .padding()
    }
    
    private func handleAnswer(selected: String, correct: String) {
        if selected == correct {
            correctAnswers += 1
        }
        
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            showFinalScore = true
            updateHighScore()
        }
    }

    
    func createQuestion(for englishWord: String) -> Question {
        let correctAnswer = language.commonPhrases[englishWord] ?? "N/A"
        
        let wrongChoices = Array(language.commonPhrases.values).filter { $0 != correctAnswer }
        
        let incorrectAnswer = wrongChoices.randomElement() ?? "Unknown"
        
        let shuffled = Bool.random()
        
        if shuffled {
            return Question(
                question: "What does '\(englishWord)' mean in \(language.name)?",
                answer: correctAnswer,
                choice1: correctAnswer,
                choice2: incorrectAnswer
            )
        } else {
            return Question(
                question: "What does '\(englishWord)' mean in \(language.name)?",
                answer: correctAnswer,
                choice1: incorrectAnswer,
                choice2: correctAnswer
            )
        }
    }
    
    func updateHighScore() {
        let scoreString = String(Double(correctAnswers) / Double(questions.count) * 100.0)  

        switch language.name.lowercased() {
        case "english":
            englishHighScore["english"] = scoreString
        case "arabic":
            arabicHighScore["arabic"] = scoreString
        case "french":
            frenchHighScore["french"] = scoreString
        case "russian":
            russianHighScore["russian"] = scoreString
        case "chinese (mandarin)", "chinese":
            chineseHighScore["chinese"] = scoreString
        case "spanish":
            spanishHighScore["spanish"] = scoreString
        default:
            break
        }
    }

}

