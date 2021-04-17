//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Rafael Freitas on 06/04/21.
//

import Foundation
@testable import QuizEngine

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var routedResult: Result<String, String>? = nil

    var answerCallback: (Answer) -> Void = {_ in }
    func route(to question: String, answerCallback: @escaping (String) -> Void) {
        self.answerCallback = answerCallback
        routedQuestions.append(question)
    }
    
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}
