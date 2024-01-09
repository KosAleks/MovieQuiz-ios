//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.12.2023.
//

import Foundation

struct NetworkClient: NetworkRouting {
    private enum NetworkError: Error {
        case codeError
    }
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { // распаковываем ошибку
                handler(.failure(error)) // это то же самое что и Result.failure(error)
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            if let response = response as? HTTPURLResponse, // приводим наш response - ответ к виду, соответсттвующему стандарту  HTTP,
               response.statusCode < 200 || response.statusCode >= 300 { // успешный ли результат узнаем по коду
                handler(.failure(NetworkError.codeError))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            guard let data = data else { return } //
            handler(.success(data))
        }
        task.resume()
    }
}
