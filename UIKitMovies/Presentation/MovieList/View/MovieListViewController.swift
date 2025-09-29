import UIKit
import SnapKit

class PoppableViewController: UIViewController {
    
    private let onPop: () -> Void
    
    init(onPop: @escaping () -> Void) {
        self.onPop = onPop
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            onPop()
        }
    }
}

final class MovieListViewController: UIViewController {
    
    let viewModel: MovieListViewModel
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.register(MovieListSectionCell.self, forCellReuseIdentifier: MovieListSectionCell.description())
        return tableView
    }()
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movie List"
        setupViews()
        setupConstraints()
        setupObservables()
        viewModel.fetchMovies()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupObservables() {
        viewModel.sections
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListSectionCell.description(), for: indexPath) as? MovieListSectionCell else { return UITableViewCell() }
        let model = viewModel.sections.value[indexPath.section].items
        cell.fill(with: model)
        cell.onMovieSelected = { [weak self] selectedMovie in
            self?.viewModel.selectedMovie(selectedMovie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGSize.rowWithImageSize.height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allSections = viewModel.sections.value
        return allSections.isEmpty ? nil : allSections[section].title
    }
}
