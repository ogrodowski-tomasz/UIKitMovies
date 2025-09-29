import Foundation
import RxRelay
import RxSwift

final class MovieDetailsViewModel {
    
    let movieId: Int
    let disposeBag = DisposeBag()
    private let movieDetails = BehaviorRelay<MovieDetailsApiModel?>(value: nil)
    
    var movieDetailsObservable: Observable<MovieDetailsApiModel> {
        movieDetails.compactMap { $0 }.asObservable()
    }
    
    private let networkManager: MovieNetworkManagerProtocol
    
    init(movieId: Int, networkManager: MovieNetworkManagerProtocol) {
        self.movieId = movieId
        self.networkManager = networkManager
        print("DEBUG: \(String(describing: self)) init for id: \(movieId)")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    func getDetails() {
        networkManager.loadMovieDetails(id: movieId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] fetchedDetails in
                self?.movieDetails.accept(fetchedDetails)
            }, onFailure: { error in
                print("DEBUG: getDetails failed: \(error)")
            }, onDisposed: {
                print("DEBUG: getDetails disposed")
            })
            .disposed(by: disposeBag)
    }
}
