import UIKit

final class TaskCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "Tracker Cell"
    var onCompleteTaskButtonTapped: (() -> Void)?
    
    lazy var themeColorContainer: UIView = {
        let item = UIView()
        item.layer.cornerRadius = 16
        item.clipsToBounds = true
        return item
    }()
    
    private lazy var emoji: UILabel = {
        let item = UILabel()
        item.font = UIFont.systemFont(ofSize: 20)
        item.backgroundColor = .ccWhite.withAlphaComponent(0.3)
        item.layer.cornerRadius = 14
        item.clipsToBounds = true
        item.textAlignment = .center
        return item

    }()
    
    private lazy var titleTracker: UILabel = {
        let item = UILabel()
        item.configureLabel(font:  .systemFont(ofSize: 12, weight: .medium), textColor: .white, aligment: nil)
        return item
    }()
       
    private lazy var pin: UIButton = {
        let item = UIButton()
        item.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        item.clipsToBounds = true
        item.imageView?.tintColor = .white
        return item
    }()
    
    private lazy var quantityView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var dayCountLabel: UILabel = {
        let item = UILabel()
        item.configureLabel(font: .systemFont(ofSize: 12), textColor: .ccBlack, aligment: nil)
        return item
    }()
    
    private lazy var buttonDone: UIButton = {
        let item = UIButton()
        item.setImage(UIImage(systemName: "plus"), for: .normal)
        item.clipsToBounds = true
        item.layer.cornerRadius = 17
        item.imageView?.tintColor = .ccWhite
        item.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        return item
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        [emoji, titleTracker, pin].forEach {
            themeColorContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [dayCountLabel, buttonDone].forEach {
            quantityView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [themeColorContainer, quantityView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            themeColorContainer.heightAnchor.constraint(equalToConstant: 90),
            themeColorContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            themeColorContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeColorContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emoji.widthAnchor.constraint(equalToConstant: 30),
            emoji.heightAnchor.constraint(equalToConstant: 30),
            emoji.leadingAnchor.constraint(equalTo: themeColorContainer.leadingAnchor, constant: 12),
            emoji.topAnchor.constraint(equalTo: themeColorContainer.topAnchor, constant: 15),
            
            titleTracker.heightAnchor.constraint(equalToConstant: 34),
            titleTracker.topAnchor.constraint(equalTo: emoji.bottomAnchor, constant: 12),
            titleTracker.leadingAnchor.constraint(equalTo: themeColorContainer.leadingAnchor, constant: 12),
            titleTracker.trailingAnchor.constraint(equalTo: themeColorContainer.trailingAnchor, constant: -4),
            
            pin.widthAnchor.constraint(equalToConstant: 18),
            pin.heightAnchor.constraint(equalToConstant: 18),
            pin.trailingAnchor.constraint(equalTo: themeColorContainer.trailingAnchor, constant: -12),
            pin.topAnchor.constraint(equalTo: themeColorContainer.topAnchor, constant: 15), 
            
            quantityView.heightAnchor.constraint(equalToConstant: 58),
            quantityView.topAnchor.constraint(equalTo: themeColorContainer.bottomAnchor),
            quantityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buttonDone.widthAnchor.constraint(equalToConstant: 34),
            buttonDone.heightAnchor.constraint(equalToConstant: 34),
            buttonDone.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 8),
            buttonDone.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -12),
            
            dayCountLabel.heightAnchor.constraint(equalToConstant: 18),
            dayCountLabel.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 16),
            dayCountLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: 12)
        ])
    }
    
    // MARK: - Public Helper Methods
    
    func configure(with model: Tracker?) {
        guard let model else { return }
        titleTracker.text = model.name
        emoji.text = model.emoji
        themeColorContainer.backgroundColor = model.color
        buttonDone.backgroundColor = model.color
    }
    
    func updateButtonImage(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark" : "plus"
        buttonDone.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func updateDayCountLabel(with count: Int) {
        let formatString: String = NSLocalizedString("days_сount", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, count)
        dayCountLabel.text = resultString
    }
    
    func updatePinStatus(isPinned: Bool) {
        pin.isHidden = !isPinned
    }
    
    // MARK: - Actions
    
    @objc private func buttonDoneTapped() {
        onCompleteTaskButtonTapped?()
    }
}
