import Foundation
import RealmPersistenceModule

enum Repository {
    typealias Favorite = FavoritesRepositoryManagerProtocol & BaseRealmRepositoryManager
}
