import Realm
import RealmSwift
import RxSwift

public extension BaseRealmRepositoryManager {

    func delete<T: Object>(_ data: T) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            do {
                try realm.safeWrite {
                    realm.delete(data)
                }
            } catch {
                completable(.error(error))
            }
            completable(.completed)
            return Disposables.create {}
        }
    }

    func deleteByType<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            let objects = predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
            do {
                try realm.safeWrite {
                    realm.delete(objects)
                }
            } catch {
                completable(.error(error))
            }
            completable(.completed)
            return Disposables.create {}
        }
    }

    func delete<T: Object>(_ data: Results<T>) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            do {
                try realm.safeWrite {
                    realm.delete(data)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }

    func eraseRealm() -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            do {
                try realm.safeWrite {
                    realm.deleteAll()
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }
}
