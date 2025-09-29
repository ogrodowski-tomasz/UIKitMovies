import UIKit

final class FavoriteListViewController: UIViewController {
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "Favorites\nImplement realm/coreData storage"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let viewModel: FavoriteListViewModel
    
    init(viewModel: FavoriteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite List"
        setupViews()
        setupConstraints()
        setupObservables()
    }
    
    private func setupViews() {
        view.addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupObservables() {
        
    }
}
