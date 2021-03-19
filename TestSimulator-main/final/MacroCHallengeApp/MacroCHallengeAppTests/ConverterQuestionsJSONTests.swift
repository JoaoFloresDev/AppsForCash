//
//  ConverterJSONTests.swift
//  MacroCHallengeAppTests
//
//  Created by Joao Flores on 23/10/20.
//

import SwiftyJSON
import XCTest

class ConverterQuestionsJSONTests: XCTestCase {
	// MARK: - Setup and teardown methods
	override func setUpWithError() throws {}
	override func tearDownWithError() throws {}

	func testCreateQuestion_whenGivenValidJSON_shouldGiveValidQuestion() throws {

		// Given
		let inputJSON = createValidMockJSON()
		let testSubject = ConverterQuestionsJSON()

		// When
		let resultQuestion = try testSubject.createQuestion(json: inputJSON)

		// Then
		let expectedOptionsDict  = ["A" : "ExampleOptionA", "B" : "ExampleOptionB", "C": "ExampleOptionC", "D" : "ExampleOptionD"]
		let expectedResult = Question(number: "1", text: "This is a example of text", initialText: "initialText example", images: nil, subtitle: "subtitleExample", options: expectedOptionsDict, answer: "answerTest", topic: "topic")

		XCTAssertEqual(resultQuestion.number, expectedResult.number)
        print(String(describing: resultQuestion.options))
		XCTAssertEqual(resultQuestion.options, expectedResult.options)
		XCTAssertEqual(resultQuestion.images?.count, 3)
	}

	func testCreateQuestion_whenGivenInvalidJSON_shouldGiveError() throws {

		// Given
		let inputJSON = createInvalidMockJSON()
		let testSubject = ConverterQuestionsJSON()

		do {
			// When
			_ = try testSubject.createQuestion(json: inputJSON)

			XCTFail("There is no question number in the dictionary, an error was expected")
		}
		catch {
			// Then
			XCTAssert(true)
		}
	}

	func testCreateQuestion_whenGivenInvalidJSONOptions_shouldGiveError() throws {

		// Given
		let inputJSON = createInvalidOptionsMockJSON()
		let testSubject = ConverterQuestionsJSON()

		do {
			// When
			_ = try testSubject.createQuestion(json: inputJSON)

			XCTFail("There is invalid options in question, an error was expected")
		}
		catch {
			// Then
			XCTAssert(true)
		}
	}

	func createValidMockJSON() -> JSON {

		let json: JSON = JSON([
			"number" : "1",
			"text" : "This is a example of text",
			"initialText" : "initialText example",
			"images" : "https://firebasestorage.googleapis.com/v0/b/roggerapp-64174.appspot.com/o/promotions%2FBacon%20Cheddar.jpg?alt=media&token=66ec189e-06e2-4707-a583-80f4f8fd3bdd@https://firebasestorage.googleapis.com/v0/b/roggerapp-64174.appspot.com/o/promotions%2FBacon%20Cheddar.jpg?alt=media&token=66ec189e-06e2-4707-a583-80f4f8fd3bdd@https://firebasestorage.googleapis.com/v0/b/roggerapp-64174.appspot.com/o/promotions%2FBacon%20Cheddar.jpg?alt=media&token=66ec189e-06e2-4707-a583-80f4f8fd3bdd",
			"subtitle" : "subtitleExample",
			"options" : "||A:ExampleOptionA#@||B:ExampleOptionB#@||C:ExampleOptionC#@||D:ExampleOptionD",
			"answer" : "answerTest",
			"topic" : "topic",
		])

		return json
	}

	func createInvalidMockJSON() -> JSON {

		let json: JSON = JSON([
			"text" : "This is a example of text",
			"initialText" : "initialText example",
			"images" : "URL1@URL2@URL3",
			"subtitle" : "subtitleExample",
			"options" : "A:ExampleOptionA#@B:ExampleOptionB#@C:ExampleOptionC#@D:ExampleOptionD",
			"answer" : "answerTest",
			"topic" : "topic",
		])

		return json
	}

	func createInvalidOptionsMockJSON() -> JSON {

		let json: JSON = JSON([
			"number" : "1",
			"text" : "This is a example of text",
			"initialText" : "initialText example",
			"images" : "URL1@URL2@URL3",
			"subtitle" : "subtitleExample",
			"options" : "||A:ExampleOptionA||#@||B:ExampleOption||B#@#@||C:ExampleOptionC#@||D:ExampleOptionD",
			"answer" : "answerTest",
			"topic" : "topic",
		])

		return json
	}
}
