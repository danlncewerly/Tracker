

import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func alertPresent(alertModel: AlertModel) {
        
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: alertModel.preferredStyle)
        
        let primaryButton = UIAlertAction(title: alertModel.primaryButton.title,
                                          style: alertModel.primaryButton.style,
                                          handler: alertModel.primaryButton.handler)
        
        alert.addAction(primaryButton)
        
        if let secondaryButton = alertModel.secondaryButton {
            let secondaryAction = UIAlertAction(title: secondaryButton.title,style: secondaryButton.style)
            alert.addAction(secondaryAction)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.sendAlert(alert: alert)
        }

    }
}
 
