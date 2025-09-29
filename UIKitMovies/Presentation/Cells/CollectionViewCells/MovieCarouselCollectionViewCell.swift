import UIKit
import RxRelay
import RxSwift
import SnapKit
import Kingfisher

final class MovieCarouselCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.black.withAlphaComponent(0.5) : UIColor.black.withAlphaComponent(0.2)
        }
    }
    
    
    let posterImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()        
    }
    
    private func setupViews() {
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        posterImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(snp.width).multipliedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(-4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        posterImage.kf.cancelDownloadTask()
        posterImage.image = nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, imageURL: URL?) {
        titleLabel.text = title
        posterImage.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo"))
    }
}
