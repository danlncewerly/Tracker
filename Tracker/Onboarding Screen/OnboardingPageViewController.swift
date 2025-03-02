import UIKit

final class OnboardingPageViewController: UIViewController {
    private let imageName: String
    private let descriptionText: String
    var onSkipTapped: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.configureLabel(font: .boldSystemFont(ofSize: 32), textColor: .ccBlack, aligment: .center)
        descriptionLabel.text = descriptionText
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private lazy var skipOnboardingButton: UIButton = {
        let button = UIButton(type: .system)
        button.applyCustomStyle(title: "Вот это технологии!", forState: .normal,
                                titleFont: .systemFont(ofSize: 16), titleColor: .white, titleColorState: .normal,
                                backgroundColor: .ccBlack,
                                cornerRadius: 16)
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        return button
    }()
    
    init(imageName: String, description: String) {
        self.imageName = imageName
        self.descriptionText = description
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        [imageView, descriptionLabel, skipOnboardingButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            
            skipOnboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            skipOnboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            skipOnboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipOnboardingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func skipTapped() {
        onSkipTapped?()
    }
}

