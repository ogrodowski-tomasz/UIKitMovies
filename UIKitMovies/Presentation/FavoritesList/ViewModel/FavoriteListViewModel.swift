import Foundation
import RxRelay
import RxSwift

final class FavoriteListViewModel {
    
    let favoritesRelay = BehaviorRelay<[FavoriteMovieModel]>(value: [])
    private let favoriteRepository: Repository.Favorite
    
    let disposeBag = DisposeBag()
    
    init(favoriteRepository: Repository.Favorite) {
        self.favoriteRepository = favoriteRepository
        observeFavorites()
    }
    
    private func observeFavorites() {
        favoriteRepository.observeFavorites()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] persistedMovies in
                self?.favoritesRelay.accept(persistedMovies)
            }, onError: { error in
                print("DEBUG: Error observing favorites: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
}
