import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    
    /// Parent Coordinator which is responsible for object deallocation
    weak var parentCoordinator: BaseCoordinator?
    private var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("Override this method in child class!")
    }
    
    func finish() {
        parentCoordinator?.free(coordinator: self)
    }
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
