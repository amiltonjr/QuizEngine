//
//  QuizEngineTests.swift
//  QuizEngineTests
//
//  Created by Rafael Freitas on 14/02/21.
//

import Foundation
import XCTest
@testable import QuizEngine

class QuizEngineTests: XCTestCase {

    var router: RouterSpy!
    
    override func setUp() {
        super.setUp()
        router = RouterSpy()
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    func testStart_withoutQuestion_doesNotRouteToQuestion(){
        //when
        makeSut(questions: []).start()
        //should
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func testStart_withOneQuestion_routesToCorrectQuestion(){
        //when
        makeSut(questions: ["Q1"]).start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStart_withOneQuestion_doesNotRouteToResult(){
        //when
        makeSut(questions: ["Q1"]).start()
        //should
        XCTAssertNil(router.routedResult)
    }
    
    func testStart_withTwoQuestions_doesNotRouteToResult(){
        //given
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        //when
        router.answerCallback("A1")
        //should
        XCTAssertNil(router.routedResult)
    }
    
    func testStart_withOneQuestion_routesToCorrectQuestion_2(){
        //when
        makeSut(questions: ["Q2"]).start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func testStart_withTwoQuestion_routesToFirstQuestion(){
        //when
        makeSut(questions: ["Q1", "Q2"]).start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
        
    func testStartTwice_withTwoQuestion_routesToFirstQuestionTwice(){
        //given
        let sut = makeSut(questions: ["Q1", "Q2"])
        //when
        sut.start()
        //and
        sut.start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func testStartAndAnswerFirstAndSecondQuestion_withThreeQuestion_routesToSecondAndThirdQuestion(){
        //given
        let sut = makeSut(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        //when
        router.answerCallback("A1")
        //and
        router.answerCallback("A2")
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func testStartAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion(){
        //given
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        //when
        router.answerCallback("A1")
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    //MARK: - Result
    
    func testStart_withoutQuestion_routeToResult(){
        //when
        makeSut(questions: []).start()
        //should
        XCTAssertEqual(router.routedResult?.answers, [:])
    }
    
    func testStart_withTwoQuestion_routesToResult(){
        //given
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        //when
        router.answerCallback("A1")
        router.answerCallback("A2")
        //should
        XCTAssertEqual(router.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func testStart_withTwoQuestion_scores(){
        //given
        let sut = makeSut(questions: ["Q1", "Q2"], scoring: {_ in 10})
        sut.start()
        //when
        router.answerCallback("A1")
        router.answerCallback("A2")
        //should
        XCTAssertEqual(router.routedResult!.score, 10)
    }
    
    func testStart_withTwoQuestion_scoresWithRightAnswer(){
        //given
        var receivedAnswers = [String: String]()
        let sut = makeSut(questions: ["Q1", "Q2"], scoring: {answers in
            receivedAnswers = answers
            return 10
        })
        sut.start()
        //when
        router.answerCallback("A1")
        router.answerCallback("A2")
        //should
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    //MARK: - Helpers
    
    private func makeSut(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = {_ in 0}
    ) -> Flow<String, String, RouterSpy> {
        Flow(questions: questions, router: router, scoring: scoring)
    }
}


