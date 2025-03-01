

import UIKit

final class TaskCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let reuseIdentifier = "Tracker Cell"
    var onCompleteTaskButtonTapped: (() -> Void)?
    
    private let viewModel = TaskListViewModel()
    
    private lazy var themeColorContainer: UIView = {
        let item = UIView()
        item.layer.cornerRadius = 16
        item.clipsToBounds = true
        return item
    }()
    
    private lazy var emoji: UILabel = {
        let item = UILabel()
        item.textColor = .white
        item.font = UIFont.systemFont(ofSize: 16)
        item.backgroundColor = .white.withAlphaComponent(0.3)
        item.layer.cornerRadius = 12
        item.clipsToBounds = true
        return item
    }()
    
    private lazy var titleTracker: UILabel = {
        let item = UILabel()
        item.configureLabel(font: .systemFont(ofSize: 17), textColor: .white, aligment: nil)
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
        item.imageView?.tintColor = .white
        item.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        return item
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [quantityView, themeColorContainer, emoji, titleTracker,
         dayCountLabel, buttonDone].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            themeColorContainer.heightAnchor.constraint(equalToConstant: 90),
            themeColorContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            themeColorContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeColorContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emoji.widthAnchor.constraint(equalToConstant: 24),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.topAnchor.constraint(equalTo: themeColorContainer.topAnchor, constant: 12),
            emoji.leadingAnchor.constraint(equalTo: themeColorContainer.leadingAnchor, constant: 12),
            
            titleTracker.heightAnchor.constraint(equalToConstant: 34),
            titleTracker.topAnchor.constraint(equalTo: emoji.bottomAnchor, constant: 12),
            titleTracker.leadingAnchor.constraint(equalTo: themeColorContainer.leadingAnchor, constant: 12),
            
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        switch count {
        case 1: dayCountLabel.text = "\(count) день"
        case 2...4: dayCountLabel.text = "\(count) дня"
        default: dayCountLabel.text = "\(count) дней"
        }
    }
    
    // MARK: - Actions
    
    @objc private func buttonDoneTapped() {
        onCompleteTaskButtonTapped?()
    }
}
