//
//  Result.swift
//  QuizEngine
//
//  Created by Rafael Freitas on 06/04/21.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
