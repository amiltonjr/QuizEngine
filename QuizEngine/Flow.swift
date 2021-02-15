//
//  Flow.swift
//  QuizEngine
//
//  Created by Rafael Freitas on 14/02/21.
//

import Foundation

protocol Router {
    typealias AnswerCallBack = (String) -> Void
    func route(to question: String, answerCallback: @escaping AnswerCallBack)
}

class Flow {
    var router: Router
    var questions: [String]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if let question = questions.first {
            router.route(to: question, answerCallback: routeToNextQuestion(question: question))
        }
    }
    
    private func routeToNextQuestion(question: String) -> Router.AnswerCallBack {
        return { [weak self] _ in
            guard let self = self else {return}
            if let currentQuestionIndex = self.questions.firstIndex(of: question) {
                if currentQuestionIndex + 1 < self.questions.count {
                    let nextQuestion = self.questions[currentQuestionIndex + 1]
                    self.router.route(to: nextQuestion, answerCallback: self.routeToNextQuestion(question: nextQuestion))
                }
            }
        }
    }
}
