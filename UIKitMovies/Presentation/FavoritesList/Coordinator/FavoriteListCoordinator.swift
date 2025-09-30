import Foundation
import UIKit

final class FavoriteListCoordinator: BaseCoordinator {
    
    private let favoriteRepository: Repository.Favorite
    
    init(favoriteRepository: Repository.Favorite, navigationController: UINavigationController) {
        self.favoriteRepository = favoriteRepository
        super.init(navigationController: navigationController)
        print("DEBUG: \(String(describing: self)) init")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let viewModel = FavoriteListViewModel(favoriteRepository: favoriteRepository)
        let vc = FavoriteListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
