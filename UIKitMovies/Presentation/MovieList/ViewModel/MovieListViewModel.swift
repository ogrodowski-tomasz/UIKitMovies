import Foundation
import RxSwift
import RxRelay

final class MovieListViewModel {
    private let selectedMovie = PublishSubject<MovieApiModel>()
    var selectedMovieObservable: Observable<MovieApiModel> {
        selectedMovie.asObservable()
    }
    
    let sections = BehaviorRelay<[MovieListSection]>(value: [])
    
    let disposeBag = DisposeBag()
    
    private let networkManager: MovieNetworkManagerProtocol
    private let popular = BehaviorRelay<[MovieApiModel]>(value: [])
    private let nowPlaying = BehaviorRelay<[MovieApiModel]>(value: [])
    private let topRated = BehaviorRelay<[MovieApiModel]>(value: [])
    
    init(networkManager: MovieNetworkManagerProtocol) {
        self.networkManager = networkManager
        observeMovies()
    }
    
    func selectedMovie(_ movie: MovieApiModel) {
        selectedMovie.onNext(movie)
    }
    
    func fetchMovies() {
        networkManager.loadMovieList(.popular)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] fetchedMovies in
                guard let self else { return }
                popular.accept(fetchedMovies)
            }, onFailure: { [weak self] error in
                guard let self else { return }
                print("DEBUG: ERROR FETCHING POPULAR MOVIES: \(error)")
            })
            .disposed(by: disposeBag)
        
        networkManager.loadMovieList(.nowPlaying)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] fetchedMovies in
                guard let self else { return }
                nowPlaying.accept(fetchedMovies)
            }, onFailure: { [weak self] error in
                guard let self else { return }
                print("DEBUG: ERROR FETCHING NOW PLAYING MOVIES: \(error)")
            })
            .disposed(by: disposeBag)
        
        networkManager.loadMovieList(.topRated)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] fetchedMovies in
                guard let self else { return }
                topRated.accept(fetchedMovies)
            }, onFailure: { [weak self] error in
                guard let self else { return }
                print("DEBUG: ERROR FETCHING NOW PLAYING MOVIES: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func observeMovies() {
        Observable.combineLatest(popular, nowPlaying, topRated)
            .map { popularMovies, nowPlayingMovies, topRatedMovies -> [MovieListSection] in
                var sections: [MovieListSection] = []
                
                if !popularMovies.isEmpty {
                    sections.append(MovieListSection(title: "Popular", items: popularMovies))
                }
                
                if !nowPlayingMovies.isEmpty {
                    sections.append(MovieListSection(title: "Now Playing", items: nowPlayingMovies))
                }
                
                if !topRatedMovies.isEmpty {
                    sections.append(MovieListSection(title: "Top Rated", items: topRatedMovies))
                }
                
                return sections
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
}
