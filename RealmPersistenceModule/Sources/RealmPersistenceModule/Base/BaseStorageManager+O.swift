import RealmSwift
import RxSwift

public extension BaseRealmRepositoryManager {

    func overwrite<T: Object>(_ type: T.Type, data: T, update: Realm.UpdatePolicy = .all, primaryKey: Int? = nil) -> Completable {
        overwrite(type, data: [data], update: update, primaryKey: primaryKey)
    }

    func overwrite<T: Object>(_ type: T.Type, data: [T], update: Realm.UpdatePolicy = .all, primaryKey: Int? = nil) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            if let primaryKey = primaryKey {
                let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
                do {
                    try realm.safeWrite {
                        if let object = object {
                            realm.delete(object)
                        }
                        realm.add(data, update: update)
                        completable(.completed)
                    }
                } catch {
                    completable(.error(error))
                }
            } else {
                let objects = realm.objects(type)
                do {
                    try realm.safeWrite {
                        realm.delete(objects)
                        realm.add(data, update: update)
                        completable(.completed)
                    }
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create {}
        }
    }
}
