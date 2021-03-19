////
////  OverviewControllerImplementationTests.swift
////  MacroCHallengeAppTests
////
////  Created by João Pedro de Amorim on 08/10/20.
////
//
//import XCTest
//
//class ResultsControllerImplementationTests: XCTestCase {
//    // MARK: - Setup and teardown methods
//    override func setUpWithError() throws {}
//    override func tearDownWithError() throws {}
//    
//    func testHasEnded_whenAllCorrect_ShouldGiveRightPercentage() throws {
//        // Given
//        let mockTest = prepareMock()
//        let mockAnsweredQuestions = defineAnswers(questions: mockTest.questions, amountCorrect: 1.00)
//        let testSubject = ResultsViewController(test: mockTest, answeredQuestions: mockAnsweredQuestions)
//        
//        // When
//        guard let percentageResult = testSubject.resultsData?.totalPercentageOfCorrectAnswers else {
//            XCTFail("resultsData not found within results view controller")
//            return
//        }
//        
//        // Then
//        XCTAssertEqual(100.00, percentageResult)
//    }
//    
//    func testHasEnded_whenHalfCorrect_ShouldGiveRightPercentage() throws {
//        // Given
//        let mockTest = prepareMock()
//        let mockAnsweredQuestions = defineAnswers(questions: mockTest.questions, amountCorrect: 0.5)
//        let testSubject = ResultsViewController(test: mockTest, answeredQuestions: mockAnsweredQuestions)
//        
//        // When
//        guard let percentageResult = testSubject.resultsData?.totalPercentageOfCorrectAnswers else {
//            XCTFail("resultsData not found within results view controller")
//            return
//        }
//        
//        // Then
//        XCTAssertEqual(50.00, percentageResult)
//    }
//    
//    func testHasEnded_whenOneThirdCorrect_ShouldGiveRightPercentage() throws {
//        // Given
//        let mockTest = prepareMock()
//        let mockAnsweredQuestions = defineAnswers(questions: mockTest.questions, amountCorrect: 0.3)
//        let testSubject = ResultsViewController(test: mockTest, answeredQuestions: mockAnsweredQuestions)
//        
//        // When
//        guard let percentageResult = testSubject.resultsData?.totalPercentageOfCorrectAnswers else {
//            XCTFail("resultsData not found within results view controller")
//            return
//        }
//        
//        // Then
//        XCTAssertEqual(30.00, percentageResult)
//    }
//}
//
//// MARK: - Helper methods
//func prepareMock() -> Test {
//    let possibleAnswers = ["a", "b", "c", "d"]
//    var mockQuestions: [Question] = []
//    
//    for i in 1...30 {
//        let question = Question(number: String(i), text: "", initialText: "",
//                                images: nil, subtitle: nil, options: [:],
//                                answer: possibleAnswers[i % 4])
//        mockQuestions.append(question)
//    }
//    
//    let mockTest = Test(name: "", year: "", questions: mockQuestions)
//    
//    return mockTest
//}
//
//func defineAnswers(questions: [Question], amountCorrect: Double) -> [String:String] {
//    let possibleAnswers = ["a", "b", "c", "d"]
//    let ceiling = Int(amountCorrect * 30)
//    var result: [String : String] = [:]
//    
//    for i in 1...ceiling {
//        if let question = questions.filter({$0.number == String(i)}).first {
//            result[question.number] = possibleAnswers[i % 4]
//        }
//    }
//    
//    return result
//}
//
//
//
//
