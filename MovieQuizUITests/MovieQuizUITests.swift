//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Александра Коснырева on 22.12.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        
        let indexlabel = app.staticTexts["Index"]
        XCTAssertEqual(indexlabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        
        let indexlabel = app.staticTexts["Index"]
        XCTAssertEqual(indexlabel.label, "2/10")
    }
    
//    func testAllert() throws {
//        sleep(3)
//        var counter = 0
//        for _ in 1...10 {
//            while counter < 10 {
//                app.buttons["Yes"].tap()
//                counter += 1
//                sleep(3)
//            }
//
//            let alert = app.alerts["Этот раунд окончен!"]
//            XCTAssertTrue(alert.exists)
//            XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
//            XCTAssertTrue(alert.label == "Этот раунд окончен!")
       }

        

