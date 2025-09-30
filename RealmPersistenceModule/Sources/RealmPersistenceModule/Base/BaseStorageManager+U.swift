import RealmSwift
import RxSwift

public extension BaseRealmRepositoryManager {

    func update(action: @escaping () -> Void) -> Completable {
        Completable.create { [weak self] completable in
            guard let realm = self?.realm else {
                completable(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            do {
                try realm.safeWrite {
                    action()
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create {}
        }
    }
}
