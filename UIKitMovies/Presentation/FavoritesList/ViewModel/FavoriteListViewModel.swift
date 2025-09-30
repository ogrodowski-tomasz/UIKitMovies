import Foundation
import RxRelay
import RxSwift

final class FavoriteListViewModel {
    
    var onFavoriteSelected: ( (_ movie: FavoriteMovieModel) -> Void)?
    let favoritesRelay = BehaviorRelay<[FavoriteMovieModel]>(value: [])
    private let favoriteRepository: Repository.Favorite
    
    let disposeBag = DisposeBag()
    
    init(favoriteRepository: Repository.Favorite) {
        self.favoriteRepository = favoriteRepository
        observeFavorites()
    }
    
    func didSelectFavorite(at index: Int) {
        let model = favoritesRelay.value[index]
        print("DEBUG: Selected favorite movie: \(model.title)")
        onFavoriteSelected?(model)
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
