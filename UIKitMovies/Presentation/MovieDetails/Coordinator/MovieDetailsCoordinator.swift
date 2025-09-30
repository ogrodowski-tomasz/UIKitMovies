import UIKit

final class MovieDetailsCoordinator: BaseCoordinator {
    let movieId: Int
    private let networkManager: MovieNetworkManagerProtocol
    private let favoriteRepository: Repository.Favorite
    
    init(
        movieId: Int,
        navigationController: UINavigationController,
        networkManager: MovieNetworkManagerProtocol,
        favoriteRepository: Repository.Favorite
    ) {
        self.movieId = movieId
        self.networkManager = networkManager
        self.favoriteRepository = favoriteRepository
        super.init(navigationController: navigationController)
        print("DEBUG: \(String(describing: self)) init")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let viewModel = MovieDetailsViewModel(
            movieId: movieId,
            networkManager: networkManager,
            favoriteRepository: favoriteRepository
        )
        let vc = MovieDetailsViewController(
            viewModel: viewModel,
            onPop: { [weak self] in
                self?.finish()
            })
        navigationController.pushViewController(vc, animated: true)
    }
}
