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
    func routeTo(result: [String: String])
}

class Flow {
    var router: Router
    var questions: [String]
    var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if let question = questions.first {
            router.route(to: question, answerCallback: routeToNextQuestion(question: question))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func routeToNextQuestion(question: String) -> Router.AnswerCallBack {
        return { [weak self] answer in
            if let self = self {
                self.routeNext(question: question, answer: answer)
            }
        }
    }
    
    private func routeNext(question: String, answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            if currentQuestionIndex + 1 < questions.count {
                let nextQuestion = questions[currentQuestionIndex + 1]
                router.route(to: nextQuestion, answerCallback: routeToNextQuestion(question: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
}
