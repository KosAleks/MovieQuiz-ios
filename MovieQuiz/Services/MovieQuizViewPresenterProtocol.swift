//
//  MovieQuizViewPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 31.12.2023.
//

import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject {
    func show (quiz step: QuizStepViewModel)
    func show (quiz result: QuizResultsViewModel)
    
    func hightLightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
