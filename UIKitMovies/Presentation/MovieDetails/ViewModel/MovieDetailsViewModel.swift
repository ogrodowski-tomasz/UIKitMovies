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
    
    private let favoriteModelRelay = BehaviorRelay<FavoriteMovieModel?>(value: nil)
    var isFavoriteObservable: Observable<Bool> {
        favoriteModelRelay
            .map { $0 != nil }
            .asObservable()
    }
    
    private let networkManager: MovieNetworkManagerProtocol
    private let favoriteRepository: Repository.Favorite
    
    init(
        movieId: Int,
        networkManager: MovieNetworkManagerProtocol,
        favoriteRepository: Repository.Favorite
    ) {
        self.movieId = movieId
        self.networkManager = networkManager
        self.favoriteRepository = favoriteRepository
        checkFavoriteStatus()
        print("DEBUG: \(String(describing: self)) init for id: \(movieId)")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    func toggleFavorite() {
        guard let movieDetailsValue = movieDetails.value else {
            return
        }
        let action: Completable
        if let favoriteModel = favoriteModelRelay.value {
            action = favoriteRepository.unmarkAsFavorite(favoriteModel)
        } else {
            let favorite = FavoriteMovieModel(
                id: movieDetailsValue.id,
                title: movieDetailsValue.title,
                posterPath: movieDetailsValue.posterPath,
                voteAverage: movieDetailsValue.voteAverage,
                releaseDate: movieDetailsValue.releaseDate
            )
            action = favoriteRepository.markAsFavorite(favorite)
        }
        
        action
            .andThen(favoriteRepository.getFavorite(by: movieId))
            .subscribe(onSuccess: { [weak self] fetchedModel in
                print("DEBUG: toggleFavorite success. Is currently favorite: \(fetchedModel != nil)")
                self?.favoriteModelRelay.accept(fetchedModel)
            }, onDisposed: {
                print("DEBUG: toggleFavorite disposed")
            })
            .disposed(by: disposeBag)
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
    
    private func checkFavoriteStatus() {
        favoriteRepository.getFavorite(by: movieId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] fetchedModel in
                print("DEBUG: checkFavoriteStatus success. Is currently favorite: \(fetchedModel != nil)")
                self?.favoriteModelRelay.accept(fetchedModel)
            }, onError: { error in
                print("DEBUG: checkFavoriteStatus failed: \(error)")
            }, onDisposed: {
                print("DEBUG: checkFavoriteStatus disposed")
            })
            .disposed(by: disposeBag)
            
    }
    
    private func markAsFavorite() {
        
    }
}
