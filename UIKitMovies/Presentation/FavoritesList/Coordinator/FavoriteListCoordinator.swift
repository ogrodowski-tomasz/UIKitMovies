import Foundation
import UIKit

final class FavoriteListCoordinator: BaseCoordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        print("DEBUG: \(String(describing: self)) init")
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let viewModel = FavoriteListViewModel()
        let vc = FavoriteListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
