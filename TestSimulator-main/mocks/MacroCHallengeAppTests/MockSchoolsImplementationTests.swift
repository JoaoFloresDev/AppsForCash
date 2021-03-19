////
////  MockSchoolsImplementationTests.swift
////  MacroCHallengeAppTests
////
////  Created by João Pedro de Amorim on 06/10/20.
////
//
//import XCTest
//
//class MockSchoolsImplementationTests: XCTestCase {
//    // MARK: - Test subject
//    let testSubject = MockSchoolsImplementation()
//    
//    // MARK: - Setup and teardown methods
//    override func setUpWithError() throws {}
//    override func tearDownWithError() throws {}
//    
//    // MARK: - Test cases
//    func testGetSchools_WhenReturns_FirstSchoolFirstTestShouldHaveThreeQuestions() throws {
//        // Given
//        let returnResult = testSubject.getSchools()
//        
//        // When
//        guard let firstSchool = returnResult.first else {
//            XCTFail("First school not found")
//            return
//        }
//        
//        guard let firstTest = firstSchool.tests.first else {
//            XCTFail("First test from first school not found")
//            return
//        }
//        
//        let finalResult = firstTest.questions.count
//        
//        // Then
//        XCTAssert(3 == finalResult)
//    }
//    
//    func testGetSchools_WhenReturns_FirstSchoolFirstTestFirstQuestionShouldHaveAnImage() throws {
//        // Given
//        let returnResult = testSubject.getSchools()
//        
//        // When
//        guard let firstSchool = returnResult.first else {
//            XCTFail("First school not found")
//            return
//        }
//        
//        guard let firstTest = firstSchool.tests.first else {
//            XCTFail("First test from first school not found")
//            return
//        }
//        
//        guard let firstQuestion = firstTest.questions.first else {
//            XCTFail("First question from first test not found")
//            return
//        }
//        
//        let finalResult = firstQuestion.image
//        
//        // Then
//        XCTAssertNotNil(finalResult)
//    }
//    
//    func testGetSchools_WhenReturns_SecondSchoolFirstTestFirstQuestionShouldHaveAnImage() throws {
//        // Given
//        let returnResult = testSubject.getSchools()
//        
//        // When
//        guard let secondSchool = returnResult.last else {
//            XCTFail("First school not found")
//            return
//        }
//        
//        guard let firstTest = secondSchool.tests.first else {
//            XCTFail("First test from first school not found")
//            return
//        }
//        
//        guard let firstQuestion = firstTest.questions.first else {
//            XCTFail("First question from first test not found")
//            return
//        }
//        
//        let finalResult = firstQuestion.image
//        
//        // Then
//        XCTAssertNotNil(finalResult)
//    }
//    
//    func testGetSchools_WhenReturns_SecondSchoolFirstTestSecondQuestionShouldHaveAnImage() throws {
//        // Given
//        let returnResult = testSubject.getSchools()
//        
//        // When
//        guard let secondSchool = returnResult.last else {
//            XCTFail("First school not found")
//            return
//        }
//        
//        guard let secondTest = secondSchool.tests.first else {
//            XCTFail("First test from first school not found")
//            return
//        }
//        
//        let secondQuestion = secondTest.questions[1]
//        
//        let finalResult = secondQuestion.image
//        
//        // Then
//        XCTAssertNotNil(finalResult)
//    }
//    
//    func testGetSchools_WhenReturns_FirstSchoolShouldHaveALogoImage() {
//        // Given
//        let returnResult = testSubject.getSchools()
//        
//        // When
//        guard let firstSchool = returnResult.first else {
//            XCTFail("First school not found")
//            return
//        }
//        
//        let finalResult = firstSchool.logo
//        
//        // Then
//        XCTAssertNotNil(finalResult)
//    }
//    
//    func testGetSchools_WhenReturns_SecondSchoolShouldHaveALogoImage() {
//        // Given
//        let returnResult = testSubject.getSchools()
//        
//        // When
//        guard let secondSchool = returnResult.last else {
//            XCTFail("Second school not found")
//            return
//        }
//        
//        let finalResult = secondSchool.logo
//        
//        // Then
//        XCTAssertNotNil(finalResult)
//    }
//
//}
