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




