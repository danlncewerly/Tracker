

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
        private let viewModel = TaskListViewModel()
            
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTab()
    }
    
    // MARK: - Private Helper Methods
    
    private func configureTab() {
        tabBar.backgroundColor = .ccWhite
        tabBar.unselectedItemTintColor = .ccGray
        tabBar.tintColor = .systemBlue
        tabBar.clipsToBounds = true
        
       
        updateTabBarBorder(for: traitCollection)
        
        let tasks = self.createNavigationTab(with: NSLocalizedString("trackers", comment: ""), icon: UIImage(systemName: "record.circle.fill")!, viewControler: TaskListViewController(viewModel: viewModel))
        let statistics = self.createNavigationTab(with: NSLocalizedString("statistics", comment: ""), icon: UIImage(systemName: "hare.fill")!, viewControler: StatisticViewController(viewModel: viewModel))
        
        setViewControllers([tasks, statistics], animated: true)
    }

   
    private func updateTabBarBorder(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            
            tabBar.layer.borderWidth = 0.5
            tabBar.layer.borderColor = UIColor.black.cgColor
        } else {
           
            tabBar.layer.borderWidth = 0.5
            tabBar.layer.borderColor = UIColor.ccGray.cgColor
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        

        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateTabBarBorder(for: traitCollection)
        }
    }

    
    private func createNavigationTab(with title: String, icon image: UIImage, viewControler viewController: UIViewController) -> UINavigationController {
        let navigationBar = UINavigationController(rootViewController: viewController)
        
        navigationBar.tabBarItem.title = title
        navigationBar.tabBarItem.image = image
        navigationBar.viewControllers.first?.navigationItem.title = title
        navigationBar.setupNavigationBarColor(titleTextAttributes: .ccBlack, largeTitleTextAttributes: .ccBlack)
        return navigationBar
    }
}

