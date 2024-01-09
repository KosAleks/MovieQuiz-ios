//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 18.12.2023.
//

import Foundation
protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
