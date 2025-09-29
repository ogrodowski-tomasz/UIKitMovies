import UIKit

final class MovieDetailsCoordinator: BaseCoordinator {
    let movieId: Int
    private let networkManager: MovieNetworkManagerProtocol
    
    init(movieId: Int, navigationController: UINavigationController, networkManager: MovieNetworkManagerProtocol) {
        self.movieId = movieId
        self.networkManager = networkManager
        super.init(navigationController: navigationController)
        print("DEBUG: \(String(describing: self)) init")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let viewModel = MovieDetailsViewModel(movieId: movieId, networkManager: networkManager)
        let vc = MovieDetailsViewController(viewModel: viewModel, onPop: { [weak self] in
            self?.finish()
        })
        navigationController.pushViewController(vc, animated: true)
    }
}
