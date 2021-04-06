//
//  Result.swift
//  QuizEngine
//
//  Created by Rafael Freitas on 06/04/21.
//

import Foundation

struct Result<Question: Hashable, Answer> {
    let answers: [Question: Answer]
    let score: Int
}
