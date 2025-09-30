import UIKit

final class FavoriteMovieTableViewCell: UITableViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.equalTo(150/1.778)
            make.height.equalTo(150)
        }
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let dateAddedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let labelsVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let mainHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        releaseDateLabel.text = nil
        voteAverageLabel.text = nil
        
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }
    
    func fill(with model: FavoriteMovieModel) {
        posterImageView.kf.setImage(with: URL(imagePath: model.posterPath))
        titleLabel.text = model.title
        releaseDateLabel.text = "Released: \(model.releaseDate ?? "-")"
        voteAverageLabel.text = String(format: "Vote average: ⭐️ %.1f", model.voteAverage ?? 0.0)
        dateAddedLabel.text = "Added: \(model.dateAdded.formatted(date: .abbreviated, time: .shortened))"
    }
    
    
    private func setupViews() {
        labelsVStack.addArrangedSubview(titleLabel)
        labelsVStack.addArrangedSubview(releaseDateLabel)
        labelsVStack.addArrangedSubview(voteAverageLabel)
        labelsVStack.addArrangedSubview(dateAddedLabel)
        
        mainHStack.addArrangedSubview(posterImageView)
        mainHStack.addArrangedSubview(labelsVStack)
        mainHStack.addArrangedSubview(UIView()) // Spacer
        
        contentView.addSubview(mainHStack)
    }
    
    private func setupConstaints() {
        
        mainHStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
}
