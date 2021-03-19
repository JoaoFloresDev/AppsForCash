//
//  RequestSenderImplementationTests.swift
//  MacroCHallengeAppTests
//
//  Created by João Pedro de Amorim on 27/10/20.
//

import XCTest

class RequestSenderImplementationTests: XCTestCase {
    // MARK: - Test subject
    let testSubject = RequestSenderImplementation()

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    // MARK: - Test cases
    // Nota: Para esse teste funcionar, o backend precisa estar ativo
    func testGetQuestionsForTestRequest_WhenBackendIsUp_shouldReturnQuestions() throws {
       // Given
        let responseExpectation = XCTestExpectation(description: "Questions were retrieved from backend and properly parsed")
        
        let completionHandler: ([Question]?, String?) -> Void = { (questions, error) in
            guard let questionsFromParser = questions else {
                XCTFail("Error ocurred with message \(error!)")
                return
            }
            
            XCTAssert(questionsFromParser.count > 0)
            
            responseExpectation.fulfill()
        }
        
        // When
        testSubject.getQuestionsForTestRequest(testName: "cotuca2019", testYear: "2019", completion: completionHandler)

        // Then
        wait(for: [responseExpectation], timeout: 10.0)
    }
    
    // Nota: Para esse teste funcionar, o backend precisa estar ativo
    func testPostResultsForTest_WhenBackendIsUp_shouldReturnNil() throws {
       // Given
        let responseExpectation = XCTestExpectation(description: "Results were properly posted")
        
        let completionHandler: (String?) -> Void = { error in
            if let errorMessage = error {
                XCTFail("Error ocurred with message \(errorMessage)")
            }
            
            responseExpectation.fulfill()
        }
        
        let mockResultsPerTopic: [String : ResultsPerTopic] = ["Matemática" : ResultsPerTopic(totalPercentageOfCorrectAnswers: 20.0,
                                                                                               totalNumberOfCorrectAnswers: 10,
                                                                                               totalNumberOfAnsweredQuestions: 30,
                                                                                               totalNumberOfQuestions: 40),
                                                               "Português" : ResultsPerTopic(totalPercentageOfCorrectAnswers: 30.0,
                                                                                              totalNumberOfCorrectAnswers: 15,
                                                                                              totalNumberOfAnsweredQuestions: 30,
                                                                                              totalNumberOfQuestions: 20)]
        
        let mockResults = ResultsData(totalPercentageOfCorrectAnswers: 20.0,
                                      totalNumberOfCorrectAnswers: 10,
                                      totalNumberOfAnsweredQuestions: 20,
                                      totalNumberOfQuestions: 50,
                                      resultsPerTopic: mockResultsPerTopic,
                                      test: Test(name: "", year: "", questions: []),
                                      answeredQuestions: ["10":"A", "20":"B"],
                                      totalTimeElapsed: "",
                                      correctAnswers: [1, 2, 3],
                                      wrongAnswers: [4, 5, 6])
        
        // When
        testSubject.postResultsForTest(testName: "cotuca2019", testYear: "2019", results: mockResults, completion: completionHandler)

        // Then
        wait(for: [responseExpectation], timeout: 5.0)
    }
}
