import Kingfisher
import UIKit
import RxCocoa

final class MovieDetailsViewController: PoppableViewController {
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .thin)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private let viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel, onPop: @escaping () -> Void) {
        self.viewModel = viewModel
        super.init(onPop: onPop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Loading..."
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        setupObservables()
        viewModel.getDetails()
    }
    
    deinit {
        print("DEBUG: \(String(describing: self)) deinit")
    }
    
    private func setupFavoriteButton() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(toggleFavorite))
        barButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = barButton

    }
    
    @objc
    private func toggleFavorite() {
        
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(originalTitleLabel)
        contentView.addSubview(overviewLabel)
        
        backdropImageView.backgroundColor = .systemRed
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalToSuperview().priority(.low)
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).dividedBy(1.778)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        originalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(originalTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
    }
    
    private func setupObservables() {
        viewModel.movieDetailsObservable
            .subscribe(onNext: { [weak self] model in
                self?.fill(with: model)
                self?.setupFavoriteButton()
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.movieDetailsObservable
            .map {
                $0.title
            }
            .bind(to: navigationItem.rx.title)
            .disposed(by: viewModel.disposeBag)
    }
    
    private func fill(with model: MovieDetailsApiModel) {
        let url = URL(imagePath: model.backdropPath)
        print("DEBUG: url: \(url)")
        backdropImageView.kf.setImage(with: url)
        titleLabel.text = model.title
        originalTitleLabel.text = model.originalTitle
        overviewLabel.text = model.overview
    }
}
