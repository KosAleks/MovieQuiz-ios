//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 27.12.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol?
    private var currentQuestion: QuizQuestion?
    
    init (viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func isLastQuestion()-> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    
    var correctAnswers = 0
    
    var alertPresenter: AlertPresenterProtocol?
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    private func didAnswer (isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWhithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWhithAnswer (isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.hightLightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else {return}
            self.proceedToNextQuestionOrResult()
        }
    }
    
    private func proceedToNextQuestionOrResult () {
        if self.isLastQuestion() {
            let text = correctAnswers == self.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            viewController?.show(quiz:viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    func makeMessage () -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error")
            return ""}
        let resultGame = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let countGame = "Количество сыграных квизов: \(statisticService.gamesCount)"
        let recordGame = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let totalAccuracy = "Средняя точность: \(String(format:"%.2f", statisticService.totalAccuracy))%"
        let message = [
            resultGame, countGame, recordGame, totalAccuracy
        ].joined(separator: "\n")
        return message
    }
}




