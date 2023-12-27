//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.09.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    private var movie: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movie = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard
                let self = self else {
                return
                
            }
            let index = (0..<self.movie.count).randomElement() ?? 0
            guard
                let movie = self.movie[safe: index] else {
                return
                
            }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            
            let valueOfRating: Float = .random(in: 1...9.9)
            let text = "Рейтинг этого фильма больше чем \(NSString(format: "%.1f", valueOfRating))?"
            let correctAnswer = rating > valueOfRating
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}



