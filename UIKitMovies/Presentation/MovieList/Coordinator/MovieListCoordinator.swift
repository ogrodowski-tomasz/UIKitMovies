import UIKit
import RxSwift

final class MovieListCoordinator: BaseCoordinator {
    
    private let networkManager: MovieNetworkManagerProtocol
    private let favoriteRepository: Repository.Favorite
    
    init(
        navigationController: UINavigationController,
        networkManager: MovieNetworkManagerProtocol,
        favoriteRepository: Repository.Favorite
    ) {
        self.networkManager = networkManager
        self.favoriteRepository = favoriteRepository
        super.init(navigationController: navigationController)
        print("DEBUG: \(String(describing: self)) init")
    }
    
    let disposeBag = DisposeBag()
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let viewModel = MovieListViewModel(
            networkManager: networkManager
        )
        let vc = MovieListViewController(
            viewModel: viewModel
        )
        
        viewModel.selectedMovieObservable
            .subscribe(onNext: { [weak self] selected in
                self?.navigateToDetails(for: selected)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func navigateToDetails(for movie: MovieApiModel) {
        let coordinator = MovieDetailsCoordinator(
            movieId: movie.id,
            navigationController: navigationController,
            networkManager: networkManager,
            favoriteRepository: favoriteRepository
        )
        coordinator.parentCoordinator = self
        store(coordinator: coordinator)
        coordinator.start()
    }
}
