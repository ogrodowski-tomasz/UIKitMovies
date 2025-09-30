import Realm
import RealmSwift
import RxSwift

public enum PersistenceErrorType {
    case unknown
    case uninitialized
    case modelNotFound
}

public struct PersistenceError: Error {
    let type: PersistenceErrorType
}

// MARK: - PROTOCOL DEFINITION

public protocol BaseRepositoryProtocol: AnyObject {
    // WRITE
    func create<T: Object>(_ data: T, update: Bool) -> Completable
    func create<T: Object>(_ data: [T], update: Realm.UpdatePolicy?) -> Completable

    // READ
    func read<T: Object>(_ type: T.Type, key: Any) -> Maybe<T?>
    func read<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Maybe<Results<T>>

    // UPDATE
    func update(action: @escaping () -> Void) -> Completable

    // DELETE
    func delete<T: Object>(_ data: T) -> Completable
    func delete<T: Object>(_ data: Results<T>) -> Completable
    func deleteByType<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Completable

    // OVERWRITE
    func overwrite<T: Object>(_ type: T.Type, data: [T], update: Realm.UpdatePolicy, primaryKey: Int?) -> Completable
    func overwrite<T: Object>(_ type: T.Type, data: T, update: Realm.UpdatePolicy, primaryKey: Int?) -> Completable
}

open class BaseRealmRepositoryManager: BaseRepositoryProtocol {
    
    let realm: Realm
    
    public init(realmType: RealmType) {
        switch realmType {
        case .production:
            var config = Realm.Configuration(schemaVersion: 2)
            config.deleteRealmIfMigrationNeeded = true
            let realm = try! Realm(configuration: config)
            self.realm = realm
        case .test:
            let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
            let realm = try! Realm(configuration: configuration)
            self.realm = realm
        }
    }
}
