import Foundation
import UIKit

final class FavoriteListCoordinator: BaseCoordinator {
    
    private let networkManager: MovieNetworkManagerProtocol
    private let favoriteRepository: Repository.Favorite
    
    init(
        favoriteRepository: Repository.Favorite,
        navigationController: UINavigationController,
        networkManager: MovieNetworkManagerProtocol
    ) {
        self.favoriteRepository = favoriteRepository
        self.networkManager = networkManager
        super.init(navigationController: navigationController)
        print("DEBUG: \(String(describing: self)) init")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let viewModel = FavoriteListViewModel(favoriteRepository: favoriteRepository)
        viewModel.onFavoriteSelected = { [weak self] favorite in
            self?.navigateToDetails(favorite)
        }
        let vc = FavoriteListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func navigateToDetails(_ model: FavoriteMovieModel) {
        let coordinator = MovieDetailsCoordinator(
            movieId: model.id,
            navigationController: navigationController,
            networkManager: networkManager,
            favoriteRepository: favoriteRepository
        )
        coordinator.parentCoordinator = self
        store(coordinator: coordinator)
        coordinator.start()
    }
    
    
}
