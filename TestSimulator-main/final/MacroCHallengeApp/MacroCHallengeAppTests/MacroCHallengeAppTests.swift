//
//  MacroCHallengeAppTests.swift
//  MacroCHallengeAppTests
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import XCTest
@testable import MacroCHallengeApp

class MacroCHallengeAppTests: XCTestCase {
    
    let testSubject = RequestSenderImplementation()

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    // Nota: esse teste só funciona se o backend estiver rodando
    func testGetQuestionsForTestRequest_whenBackendIsRunning_shouldProduceQuestions() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Nota: Fazer esse teste com o backend desligado
    func testGetQuestionsForTestRequest_whenBackendIsOff_shouldProduceFailure() throws {
        // Given
        
    }

}
