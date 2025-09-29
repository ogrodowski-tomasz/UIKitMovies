import UIKit
import RxRelay
import RxSwift
import SnapKit

final class MovieListSectionCell: UITableViewCell {
    
    var onMovieSelected: ((_ selectedMovie: MovieApiModel) -> Void)?
    
    private var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize.rowWithImageSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCarouselCollectionViewCell.self, forCellWithReuseIdentifier: MovieCarouselCollectionViewCell.description())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let items = BehaviorRelay<[MovieApiModel]>(value: [])
    private var collectionViewItemsDisposable: Disposable?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstarints()
        setupObservables()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionViewItemsDisposable?.dispose()
        collectionViewItemsDisposable = nil
    }
    
    private func setupViews() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupConstarints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupObservables() {
        guard collectionViewItemsDisposable == nil else { return }
        collectionViewItemsDisposable = items
            .subscribe(onNext: { [weak self] movies in
                self?.collectionView.reloadData()
            })
    }
    
    func fill(with movies: [MovieApiModel]) {
        items.accept(movies)
        setupObservables()
    }
}

extension MovieListSectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCollectionViewCell.description(), for: indexPath) as? MovieCarouselCollectionViewCell else { return UICollectionViewCell() }
        let movie = items.value[indexPath.item]
        cell.configure(with: movie.title, imageURL: URL(imagePath: movie.posterPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.rowWithImageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = items.value[indexPath.item]
        onMovieSelected?(model)
    }
    
}

