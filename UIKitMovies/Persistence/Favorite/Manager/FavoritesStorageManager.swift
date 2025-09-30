import Foundation
import RxSwift
import RealmSwift

protocol FavoritesRepositoryManagerProtocol {
    func observeFavorites() -> Observable<[FavoriteMovieModel]>
    func getFavorite(by movieId: Int) -> Maybe<FavoriteMovieModel?>
    func markAsFavorite(_ movie: FavoriteMovieModel) -> Completable
    func unmarkAsFavorite(_ movie: FavoriteMovieModel) -> Completable
}

final class FavoritesStorageManager: Repository.Favorite {
    
    func observeFavorites() -> Observable<[FavoriteMovieModel]> {
        observe(FavoriteMovieModel.self)
    }
    
    func getFavorite(by movieId: Int) -> Maybe<FavoriteMovieModel?> {
        return read(FavoriteMovieModel.self, key: movieId)
    }
    
    func markAsFavorite(_ movie: FavoriteMovieModel) -> Completable {
        create(movie, update: false)
    }
    
    func unmarkAsFavorite(_ movie: FavoriteMovieModel) -> Completable {
        delete(movie)
    }
}
