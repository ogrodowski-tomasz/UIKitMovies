import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    let favoriteRepository: Repository.Favorite 
    let networkManager: MovieNetworkManagerProtocol
    let window: UIWindow
    
    init(
        window: UIWindow
    ) {
        self.window = window
        networkManager = MovieNetworkManager()
        favoriteRepository = FavoritesStorageManager(realmType: .production)
        super.init(
            navigationController: UINavigationController()
        )
    }
    
    init(
        window: UIWindow,
        navigationController: UINavigationController,
        favoriteRepository: Repository.Favorite,
        networkManager: MovieNetworkManagerProtocol
    ) {
        self.window = window
        self.networkManager = networkManager
        self.favoriteRepository = favoriteRepository
        super.init(navigationController: navigationController)
    }
    
    deinit {
        print("DEBUG: AppCoordinator deinit")
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coordinator = TabBarCoordinator(
            navigationController: navigationController,
            networkManager: networkManager,
            favoriteRepository: favoriteRepository
        )
        store(coordinator: coordinator)
        
        coordinator.start()
    }
}
