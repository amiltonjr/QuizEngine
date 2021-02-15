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
    
    func testStartAndAnswerFirstQuestoin_withTwoQuestion_routesToSecondQuestion(){
        //given
        let sut = makeSut(questions: ["Q1", "Q2"])
        sut.start()
        //when
        router.answerCallback("A1")
        //should
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
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
    
    //MARK: - Router Spy

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = {_ in }
        func routeToQuestion(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
            routedQuestions.append(question)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSut(questions: [String]) -> Flow {
        Flow(questions: questions, router: router)
    }
}


