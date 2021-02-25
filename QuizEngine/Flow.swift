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
            router.route(to: question, answerCallback: nextCallback(question: question))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func nextCallback(question: String) -> Router.AnswerCallBack {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            
            let nextQuestionIndex = currentQuestionIndex + 1
            if  nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.route(to: nextQuestion, answerCallback: nextCallback(question: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
}
