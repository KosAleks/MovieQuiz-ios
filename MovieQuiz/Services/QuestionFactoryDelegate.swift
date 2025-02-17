//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.09.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {               // AnyObject - это тоже протокол
    func didReceiveNextQuestion(question: QuizQuestion?) // получен новый вопрос
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
