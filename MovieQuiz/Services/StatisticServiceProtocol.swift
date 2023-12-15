//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 14.09.2023.
//

protocol StatisticServiceProtocol {
    
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get } 
    var bestGame: BestGame? { get }
}





