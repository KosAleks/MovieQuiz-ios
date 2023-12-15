//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.09.2023.
//

import Foundation
import UIKit

//В классе MovieQuizViewController есть метод show(quiz result: QuizResultsViewModel). Он отвечает за отображение алерта (окошка с уведомлением) с результатами квиза после прохождения всех вопросов. Но задача отображения другого экрана (алерт в некотором смысле он и есть)

final class AlertPresenter: AlertPresenterProtocol {
    private weak var alertDelegate:  UIViewController?
    init(alertDelegate: UIViewController?) {
        self.alertDelegate = alertDelegate
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
            alertModel.completion()
        }
        alertDelegate?.present(alert, animated: true)
        alert.addAction(action)
    }
}
















//    private func show(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(title: "Этот раунд окончен!", alertMessage: "Ваш результат \(correctAnswers)", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak  self] _ in
//            guard let self = self else {return}
//            // код, который сбрасывает игру и показывает первый вопрос

//
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
////    }
//
