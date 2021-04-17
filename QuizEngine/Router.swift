//
//  Router.swift
//  QuizEngine
//
//  Created by Rafael Freitas on 06/04/21.
//

import Foundation

public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    typealias AnswerCallBack = (Answer) -> Void
    func route(to question: Question, answerCallback: @escaping AnswerCallBack)
    func routeTo(result: Result<Question, Answer>)
}
