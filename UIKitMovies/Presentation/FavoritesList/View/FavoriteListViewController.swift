import UIKit

final class FavoriteListViewController: UIViewController {
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: FavoriteMovieTableViewCell.description())
        return tableView
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupObservables() {
        viewModel.favoritesRelay
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritesRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieTableViewCell.description(), for: indexPath) as? FavoriteMovieTableViewCell else { return UITableViewCell() }
        let model = viewModel.favoritesRelay.value[indexPath.row]
        cell.fill(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectFavorite(at: indexPath.row)
    }
}
