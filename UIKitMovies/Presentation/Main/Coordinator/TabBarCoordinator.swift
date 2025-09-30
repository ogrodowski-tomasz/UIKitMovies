import Foundation
import UIKit

final class TabBarCoordinator: BaseCoordinator {
    let networkManager: MovieNetworkManagerProtocol
    let favoriteRepository: Repository.Favorite
    
    private var tabBarController: TabBarController!
    
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
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    override func start() {
        let movieListNavVC = UINavigationController()
        
        let movieListCoordinator = MovieListCoordinator(
            navigationController: movieListNavVC,
            networkManager: networkManager,
            favoriteRepository: favoriteRepository
        )
        store(coordinator: movieListCoordinator)
        movieListCoordinator.parentCoordinator = self
        movieListCoordinator.start()
        movieListNavVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "camera"), tag: 0)
        
        let favoritesListNavVC = UINavigationController()
        let favoritesListCoordinator = FavoriteListCoordinator(
            favoriteRepository: favoriteRepository,
            navigationController: favoritesListNavVC
        )
        store(coordinator: favoritesListCoordinator)
        favoritesListCoordinator.parentCoordinator = self
        favoritesListCoordinator.start()
        favoritesListNavVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        
        tabBarController = TabBarController(with: [movieListNavVC, favoritesListNavVC])
        #if DEBUG
        #warning("Delete this line in release")
        tabBarController.selectedIndex = 1
        #endif
        navigationController.pushViewController(tabBarController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
    
}

class TabBarController: UITabBarController {
    init(with controllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = controllers
        navigationItem.backButtonDisplayMode = .minimal

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = nil
        appearance.shadowColor = .black.withAlphaComponent(0.3)
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        appearance.backgroundColor = .clear
//        appearance.stackedLayoutAppearance.normal.iconColor = .labelsPrimary
//        appearance.stackedLayoutAppearance.selected.iconColor = .odxHighlight
        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            appearance.backgroundColor = .white
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
