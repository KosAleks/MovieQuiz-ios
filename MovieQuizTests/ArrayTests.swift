//
//  Array Test.swift
//  MovieQuizTests
//
//  Created by Александра Коснырева on 10.12.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz // здесь мы импортировали приложение для тестирования
//extension Array {
//    subscript(safe index: Index) -> Element? {
//        indices ~= index ? self[index] : nil
//    }
//
//Сабскрипт - что это?
//Классы, структуры и перечисления могут определять сабскрипты, которые являются сокращенным вариантом доступа к члену коллекции, списка или последовательности.

//Если наш сабскрипт может вернуть опциональное значение, надо проверить два варианта:
//если мы берём элемент по правильному индексу, то получаем правильное значение,
//если берём по неправильному индексу — получаем пустое значение, то есть nil.

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // получить значение в диапазоне
        //Given
        let array = [1, 2, 4, 5, 8]
        
        //When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 4)
        
    }
    
    func testGetValueOutOfRange() throws { // тест получить значение вне диапазона
        //Given
        let array = [1, 2, 3, 4, 5, 6]
        
        //When
        let value = array[safe: 33]
        
        //Then
        XCTAssertNil(value)
    }
}
