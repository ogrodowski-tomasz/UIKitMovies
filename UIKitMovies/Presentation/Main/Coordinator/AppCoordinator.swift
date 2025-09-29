import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    let networkManager: MovieNetworkManagerProtocol
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        networkManager = MovieNetworkManager()
        super.init(navigationController: UINavigationController())
    }
    
    deinit {
        print("DEBUG: AppCoordinator deinit")
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coordinator = TabBarCoordinator(navigationController: navigationController, networkManager: networkManager)
        store(coordinator: coordinator)
        
        coordinator.start()
    }
}
