//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 14.09.2023.
//

protocol StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    
    var totalAccuracy: Double { get } // средняя точность
    var gamesCount: Int { get } // количество сыграных квизов
    var bestGame: BestGame? { get }
}





