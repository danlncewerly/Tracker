import UIKit

final class OnboardingViewController: UIViewController {
    var onboardingDidEnd: (() -> Void)?
    
    private let viewModel = OnboardingViewModel()
    private var pageViewController: UIPageViewController!
    private let pages: [OnboardingPageViewController] = [
        OnboardingPageViewController(imageName: "onboardingBlue", description: "Отслеживайте только то, что хотите"),
        OnboardingPageViewController(imageName: "onboardingRed", description: "Даже если это не литры воды и йога")
    ]
    private var currentIndex = 0
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .ccBlack
        control.pageIndicatorTintColor = .ccGray
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageViewController()
        setupUI()
        setupConstraints()
        setupCallbacks()
    }
    
    private func setupUI() {
        pageControl.numberOfPages = pages.count
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -130),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.frame = view.bounds
    }
    
    private func setupCallbacks() {
        for page in pages {
            page.onSkipTapped = { [weak self] in
                self?.finishOnboarding()
            }
        }
    }
    
    @objc private func finishOnboarding() {
        viewModel.setOnboardingSeen()
        onboardingDidEnd?()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingPageViewController) else { return nil }
        let previousIndex = (index - 1 + pages.count) % pages.count
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingPageViewController) else { return nil }
        let nextIndex = (index + 1) % pages.count
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController, let index = pages.firstIndex(of: currentVC) {
            currentIndex = index
            pageControl.currentPage = index
        }
    }
}

