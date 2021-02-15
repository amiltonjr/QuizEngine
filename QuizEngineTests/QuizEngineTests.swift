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
    var sut: Flow!
    var router: RouterSpy!
    
    override func setUp() {
        super.setUp()
        router = RouterSpy()
        sut = Flow(questions: [], router: router)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStart_withoutQuestion_doesNotRouteToQuestion(){
        //when
        sut.start()
        //should
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func testStart_withOneQuestion_routesToCorrectQuestion(){
        //given
        sut.questions = ["Q1"]
        //when
        sut.start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStart_withOneQuestion_routesToCorrectQuestion_2(){
        //given
        sut.questions = ["Q2"]
        //when
        sut.start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func testStart_withTwoQuestion_routesToFirstQuestion(){
        //given
        sut.questions = ["Q1", "Q2"]
        //when
        sut.start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartAndAnswerFirstQuestoin_withTwoQuestion_routesToSecondQuestion(){
        //given
        sut.questions = ["Q1", "Q2"]
        sut.start()
        //when
        router.answerCallback("Q1")
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    func testStartTwice_withTwoQuestion_routesToFirstQuestionTwice(){
        //given
        sut.questions = ["Q1", "Q2"]
        //when
        sut.start()
        //and
        sut.start()
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = {_ in }
        func routeToQuestion(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
            routedQuestions.append(question)
        }
    }
}


