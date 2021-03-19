//
//  ConverterResultsJSONTests.swift
//  MacroCHallengeAppTests
//
//  Created by Felipe Semissatto on 30/10/20.
//

import SwiftyJSON
import XCTest

class ConverterResultsJSONTests: XCTestCase {
    // MARK: - Setup and teardown methods
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func testCreateResultPerTopic_whenGivenValidJSON_shouldGiveValidResultPerTopic() throws {

        // Given
        let inputJSON = createValidMockJSON()
        let testSubject = ConverterResultsJSON()

        // When
        let resultGeneralResults = try testSubject.createResultPerTopic(json: inputJSON)

        // Then
        let percentageOfCorrectAnswers = ("20" as NSString).doubleValue
        let numberOfCorrectAnswers = ("45" as NSString).intValue
        let numberOfAnsweredQuestions = ("45" as NSString).intValue
        let numberOfQuestions = ("50" as NSString).intValue
        
        let expectedResultPerTopic = ResultsPerTopic(totalPercentageOfCorrectAnswers: percentageOfCorrectAnswers,
                                             totalNumberOfCorrectAnswers: Int(numberOfCorrectAnswers),
                                             totalNumberOfAnsweredQuestions: Int(numberOfAnsweredQuestions),
                                             totalNumberOfQuestions: Int(numberOfQuestions))

        XCTAssertEqual(resultGeneralResults.totalNumberOfCorrectAnswers, expectedResultPerTopic.totalNumberOfCorrectAnswers)
        XCTAssertEqual(resultGeneralResults.totalNumberOfQuestions, expectedResultPerTopic.totalNumberOfQuestions)
        XCTAssertEqual(resultGeneralResults.totalNumberOfAnsweredQuestions, expectedResultPerTopic.totalNumberOfAnsweredQuestions)
        XCTAssertEqual(resultGeneralResults.totalPercentageOfCorrectAnswers, expectedResultPerTopic.totalPercentageOfCorrectAnswers)
    }
    
    func testCreateDictResultsPerTopic_whenGivenValidJSON_shouldGiveValidDictResultsPerTopic() throws {

        // Given
        let inputJSON = createValidMockJSON()
        let testSubject = ConverterResultsJSON()

        // When
        let dictResultsPerTopic = try testSubject.createDictionaryTopicsResults(json: inputJSON)

        // Then
        var percentageOfCorrectAnswers = ("20.0" as NSString).doubleValue
        var numberOfCorrectAnswers = ("10" as NSString).intValue
        var numberOfAnsweredQuestions = ("30" as NSString).intValue
        var numberOfQuestions = ("30" as NSString).intValue
        let expectedResultPortuguese = ResultsPerTopic(totalPercentageOfCorrectAnswers: percentageOfCorrectAnswers,
                                             totalNumberOfCorrectAnswers: Int(numberOfCorrectAnswers),
                                             totalNumberOfAnsweredQuestions: Int(numberOfAnsweredQuestions),
                                             totalNumberOfQuestions: Int(numberOfQuestions))
        
        percentageOfCorrectAnswers = ("50.0" as NSString).doubleValue
        numberOfCorrectAnswers = ("15" as NSString).intValue
        numberOfAnsweredQuestions = ("30" as NSString).intValue
        numberOfQuestions = ("30" as NSString).intValue
        let expectedResultMath = ResultsPerTopic(totalPercentageOfCorrectAnswers: percentageOfCorrectAnswers,
                                             totalNumberOfCorrectAnswers: Int(numberOfCorrectAnswers),
                                             totalNumberOfAnsweredQuestions: Int(numberOfAnsweredQuestions),
                                             totalNumberOfQuestions: Int(numberOfQuestions))
        
        let expectedDictResultsPerTopic: [String:ResultsPerTopic] = ["Português" : expectedResultPortuguese,
                                                                     "Matemática" : expectedResultMath]
        
        XCTAssertEqual(dictResultsPerTopic, expectedDictResultsPerTopic)
    }
    
    func testCreateResultPerTopic_whenGivenInvalidGeneralResultsMockJSON_shouldGiveError() throws {

        // Given
        let inputJSON = createInvalidGeneralResultsMockJSON()
        let testSubject = ConverterResultsJSON()

        do {
            // When
            _ = try testSubject.createResultPerTopic(json: inputJSON)

            XCTFail("There is invalid wrong key in generals result dictionary, an error was expected")
        }
        catch {
            // Then
            XCTAssert(true)
        }
    }
    
    func testCreateDictResultsPerTopic_whenGivenInvalidResultsPerTopicMockJSON_shouldGiveError() throws {

        // Given
        let inputJSON = createInvalidResultsPerTopicMockJSON()
        let testSubject = ConverterResultsJSON()

        do {
            // When
            _ = try testSubject.createDictionaryTopicsResults(json: inputJSON)

            XCTFail("There is invalid wrong key in a result topic in dictionary, an error was expected")
        }
        catch {
            // Then
            XCTAssert(true)
        }
    }
    
    func testCreateDictResultsPerTopic_whenGivenEmptyResultsPerTopicMockJSON_shouldGiveError() throws {

        // Given
        let inputJSON = createEmptyResultsPerTopicMockJSON()
        let testSubject = ConverterResultsJSON()

        do {
            // When
            _ = try testSubject.createDictionaryTopicsResults(json: inputJSON)

            XCTFail("The array dictionary results per topic is empty, an error was expected")
        }
        catch {
            // Then
            XCTAssert(true)
        }
    }
    
    func createValidMockJSON() -> JSON {
        let arrayDictResultsPerTopic: [[String:String]] = [["topic":"Português",
                                                            "totalPercentageOfCorrectAnswers":"20.0",
                                                            "totalNumberOfCorrectAnswers":"10",
                                                            "totalNumberOfAnsweredQuestions":"30",
                                                            "totalNumberOfQuestions":"30"],
                                                           ["topic":"Matemática",
                                                            "totalPercentageOfCorrectAnswers":"50.0",
                                                            "totalNumberOfCorrectAnswers":"15",
                                                            "totalNumberOfAnsweredQuestions":"30",
                                                            "totalNumberOfQuestions":"30"]
        ]
        let dictValidMock: [String:Any] = ["totalPercentageOfCorrectAnswers":"20.0",
                                           "totalNumberOfQuestions":"50",
                                           "totalNumberOfCorrectAnswers":"45",
                                           "totalNumberOfAnsweredQuestions":"45",
                                           "resultsPerTopic": arrayDictResultsPerTopic]
        
        
        let json: JSON = JSON(dictValidMock)
        
        return json
    }
    
    func createInvalidGeneralResultsMockJSON() -> JSON {
        
        let arrayDictResultsPerTopic: [[String:String]] = [["topic":"Português",
                                                            "totalPercentageOfCorrectAnswers":"20.0",
                                                            "totalNumberOfCorrectAnswers":"10",
                                                            "totalNumberOfAnsweredQuestions":"30",
                                                            "totalNumberOfQuestions":"30"],
                                                           ["topic":"Matemática",
                                                            "totalPercentageOfCorrectAnswers":"50.0",
                                                            "totalNumberOfCorrectAnswers":"15",
                                                            "totalNumberOfAnsweredQuestions":"30",
                                                            "totalNumberOfQuestions":"30"]
        ]
        
        // Retirei a chave totalNumberOfCorrectAnswers
        let dictInvalidGeneralResultsMock: [String:Any] = ["totalPercentageOfCorrectAnswers":"20.0",
                                           "totalNumberOfQuestions":"50",
                                           "totalNumberOfAnsweredQuestions":"45",
                                           "resultsPerTopic": arrayDictResultsPerTopic]
        
        let json: JSON = JSON(dictInvalidGeneralResultsMock)
        
        return json
    }
    
    func createInvalidResultsPerTopicMockJSON() -> JSON {
        
        let arrayInvalidDictResultsPerTopic: [[String:String]] = [["totalPercentageOfCorrectAnswers":"20.0",
                                                            "totalNumberOfCorrectAnswers":"10",
                                                            "totalNumberOfAnsweredQuestions":"30",
                                                            "totalNumberOfQuestions":"30"],
                                                           ["topic":"Matemática",
                                                            "totalPercentageOfCorrectAnswers":"50.0",
                                                            "totalNumberOfCorrectAnswers":"15",
                                                            "totalNumberOfAnsweredQuestions":"30",
                                                            "totalNumberOfQuestions":"30"]
        ]
        
        let dictInvalidMock: [String:Any] = ["totalPercentageOfCorrectAnswers":"20.0",
                                             "totalNumberOfQuestions":"50",
                                             "totalNumberOfCorrectAnswers":"45",
                                             "totalNumberOfAnsweredQuestions":"45",
                                             "resultsPerTopic": arrayInvalidDictResultsPerTopic]
        
        let json: JSON = JSON(dictInvalidMock)
        
        return json
    }
    
    func createEmptyResultsPerTopicMockJSON() -> JSON {
        
        let arrayEmptyDictResultsPerTopic: [[String:String]] = [[:]]
        
        let dictInvalidMock: [String:Any] = ["totalPercentageOfCorrectAnswers":"20.0",
                                             "totalNumberOfQuestions":"50",
                                             "totalNumberOfCorrectAnswers":"45",
                                             "totalNumberOfAnsweredQuestions":"45",
                                             "resultsPerTopic": arrayEmptyDictResultsPerTopic]
        
        let json: JSON = JSON(dictInvalidMock)
        
        return json
    }
}
