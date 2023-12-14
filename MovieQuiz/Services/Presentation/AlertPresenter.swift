//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.09.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var alertDelegate:  UIViewController?
    init(alertDelegate: UIViewController?) {
        self.alertDelegate = alertDelegate
    }
    // ведущий оповещения
    func show(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            //"Этот раунд окончен!",
            message: alertModel.message, // "Ваш результат \(correctAnswers)",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
            // код, который сбрасывает игру и показывает первый вопрос
            alertModel.completion()
        }
        
        alertDelegate?.present(alert, animated: true)
        alert.addAction(action)
        // self.present(alert, animated: true, completion: nil) // present - предоставить. Эта функция автоматом заложена в UIAlertAction
    }
}




