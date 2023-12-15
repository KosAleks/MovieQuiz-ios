//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Александра Коснырева on 10.12.2023.
//

import XCTest
// есть и другие фреймворки, одни из самых известных являются Quick и Nimble. 

// Синхронные тесты
struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}


final class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        let arithmeticOperations = ArithmeticOperations()
        let result = arithmeticOperations.addition(num1: 1, num2: 2)
        XCTAssertEqual(result, 3) // assert - заявленный , equal - равный , expression - выражение
    }
    
    func testSubtraction() throws {
        let arithmeticOperations = ArithmeticOperations()
        let result = arithmeticOperations.subtraction(num1: 3, num2: 1)
        XCTAssertEqual(result, 2)
    }
    
    func testMultiplication() throws {
        let arithmeticOperations = ArithmeticOperations()
        let result = arithmeticOperations.multiplication(num1: 2, num2: 3)
        XCTAssertEqual(result, 6)
    }
    //
    
    func testAddition1() throws {
        // given
        //дана структура для совершения арифметических операций и два числа, 1 и 2;
        
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 3
        let num2 = 2
        
        // when
        //когда мы получили результат сложения этих двух чисел,
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        //then
        //тогда сравниваем их с нашим ожиданием
        XCTAssertEqual(result, 5)
    }
    
    
    //  Асинхронные тесты
    
    struct ArithmeticOperations2 {
        func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                handler(num1 + num2)
            }
        }
        
        func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                handler(num1 - num2)
            }
        }
        
        func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                handler(num1 * num2)
            }
        }
    }
    
    
    
    func testAddition2() throws {
        // Given
        let arithmeticOperations = ArithmeticOperations2()
        let num1 = 1
        let num2 = 2
        
        // When
        let expectation = expectation(description: "Addition function expectation")
        
        arithmeticOperations.addition(num1: num1, num2: num2) { result in
            // Then
            XCTAssertEqual(result, 3)
            expectation.fulfill() // просим подождать пока функция вернет результат
        }
        
        waitForExpectations(timeout: 2) // задали 2 секунды ожидания
    }
    
    //    override func setUpWithError() throws {
    //        // Put setup code here. This method is called before the invocation of each test method in the class.
    //    }
    //
    //    override func tearDownWithError() throws {
    //        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    }
    //
    //    func testExample() throws {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        // Any test you write for XCTest can be annotated as throws and async.
    //        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    //        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    //    }
    //
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
