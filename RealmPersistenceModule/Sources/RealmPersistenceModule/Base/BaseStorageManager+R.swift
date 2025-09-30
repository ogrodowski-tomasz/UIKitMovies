import RealmSwift
import Foundation
import RxSwift

public extension BaseRealmRepositoryManager {

    func read<T: Object>(_ type: T.Type, key: Any) -> Maybe<T?> {
        Maybe<T?>.create { [weak self] maybe in
            guard let realm = self?.realm else {
                maybe(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            let model = realm.object(ofType: type, forPrimaryKey: key)
            maybe(.success(model))
            return Disposables.create {}
        }
    }

    func read<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Maybe<Results<T>> {
        Maybe<Results<T>>.create { [weak self] maybe in
            guard let realm = self?.realm else {
                maybe(.error(PersistenceError(type: .uninitialized)))
                return Disposables.create {}
            }
            if predicate == nil {
                maybe(.success(realm.objects(type)))
            } else {
                maybe(.success(realm.objects(type).filter(predicate!)))
            }
            return Disposables.create {}
        }
    }
    
    func observe<T: Object>(_ type: T.Type) -> Observable<[T]> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            let token = realm.objects(type).observe { changes in
                switch changes {
                case .initial(let collection):
                    observer.onNext(Array(collection))
                case .update(let collection,_,_,_):
                    observer.onNext(Array(collection))
                case .error(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                token.invalidate()
            }
        }
    }
}
