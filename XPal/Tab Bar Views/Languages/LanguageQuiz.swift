import SwiftUI


struct LanguageQuiz: View {
    let language: Language
    
    @Environment(\.modelContext) private var modelContext

    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var showFinalScore = false
    
    var allPhrases: [String: String] {
        guard let categories = language.categories else { return [:] }

        return categories.flatMap { $0.phrases ?? [] }
            .reduce(into: [String: String]()) { result, phrase in
                result[phrase.english] = phrase.translation
            }
    }


    @State private var questions: [Question] = []

    
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
            } else if !questions.isEmpty {
                QuestionView(
                    question: questions[currentQuestionIndex],
                    answerSelected: { selected in
                        handleAnswer(selected: selected, correct: questions[currentQuestionIndex].answer)
                    }
                )
            }
        }
        .padding()
        .onAppear {
            if questions.isEmpty {
                generateQuestions()
            }
        }
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
            
            let finalScore = Double(correctAnswers) / Double(questions.count) * 100.0
            saveQuizAttempt(score: finalScore)
        }
    }

    
    func createQuestion(for englishWord: String) -> Question {
        let correctAnswer = allPhrases[englishWord] ?? "N/A"
        let wrongChoices = Array(allPhrases.values.filter { $0 != correctAnswer }).shuffled()

        let incorrectChoices = Array(wrongChoices.prefix(3))  // Select 3 wrong answers

        // Combine and shuffle choices
        var allChoices = incorrectChoices + [correctAnswer]
        allChoices.shuffle()

        return Question(
            question: "What does '\(englishWord)' mean in \(language.name)?",
            answer: correctAnswer,
            choice1: allChoices[0],
            choice2: allChoices[1],
            choice3: allChoices[2],
            choice4: allChoices[3]
        )
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
    
    private func generateQuestions() {
        let allKeys = Array(allPhrases.keys).shuffled()
        let selectedEnglishPhrases = Array(allKeys.prefix(4))
        questions = selectedEnglishPhrases.map { createQuestion(for: $0) }
    }
    
    func saveQuizAttempt(score: Double) {
        
        let newAttempt = QuizAttempt(
            date: Date(),
            score: score,
            language: language
        )
        modelContext.insert(newAttempt)
        language.quizAttempts?.append(newAttempt)

        let allAttempts = (language.quizAttempts ?? [])
            .sorted(by: { $0.date > $1.date })

        if allAttempts.count > 7 {
            let extraAttempts = allAttempts.dropFirst(7)
            for oldAttempt in extraAttempts {
                modelContext.delete(oldAttempt)
            }
        }
    }


}

