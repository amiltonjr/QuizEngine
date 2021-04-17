//
//  GameTests.swift
//  QuizEngineTests
//
//  Created by Rafael Freitas on 06/04/21.
//

import XCTest
import QuizEngine

class GameTests: XCTestCase {
    let router = RouterSpy()
    var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        game = startGame(["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
   
    func test_startGame_answersZeroCorrectly_Scores0() {
        //when
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        //should
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func test_startGame_answersOneCorrectly_Scores1() {
        //when
        router.answerCallback("A1")
        router.answerCallback("wrong")
        //should
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    func test_startGame_answersTwoCorrectly_Scores2() {
        //when
        router.answerCallback("A1")
        router.answerCallback("A2")
        //should
        XCTAssertEqual(router.routedResult!.score, 2)
    }
}
