import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    // MARK: - Lifecycle
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var questionLabel: UILabel!
    
    @IBOutlet private var indexLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol? 
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError (message: String) {
        activityIndicator.isHidden = true
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in guard let self = self else {return}
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter?.show(alertModel: model)
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func show (quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        
        if presenter.isLastQuestion() {
            showFinalResults()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeMessage(),
            buttonText: "Сыграть еще раз" ,
            completion: { [weak self] in
                self?.presenter.resetQuestionIndex()
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            } )
        alertPresenter?.show(alertModel: alertModel)
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
  
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenResult = false
        showAnswerResult(isCorrect: givenResult == currentQuestion.correctAnswer)
    }
   
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenResult = true
        showAnswerResult(isCorrect: givenResult == currentQuestion.correctAnswer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient()), delegate: self)
        alertPresenter = AlertPresenter(alertDelegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        statisticService = StatisticServiceImplementation()
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
