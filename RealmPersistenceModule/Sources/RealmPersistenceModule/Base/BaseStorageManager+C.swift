import RealmSwift
import RxSwift

public extension BaseRealmRepositoryManager {

    func create<T: Object>(_ data: T, update: Bool) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            do {
                try realm.safeWrite {
                    switch update {
                    case true:
                        realm.add(data, update: Realm.UpdatePolicy.all)
                    case false:
                        realm.add(data)
                    }
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create<T: Object>(_ data: [T], update: Realm.UpdatePolicy?) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            do {
                try realm.safeWrite {
                    if let update = update {
                        realm.add(data, update: update)
                    } else {
                        realm.add(data)
                    }
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }
}
