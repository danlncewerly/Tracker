import Foundation
import AppMetricaCore

class AnalyticsService {
    // MARK: - Открытие/Закрытие экрана
    func trackScreenOpen(screenName: String) {
        AppMetrica.reportEvent(name: "open", parameters: ["screen": screenName])
    }
    
    func trackScreenClose(screenName: String) {
        AppMetrica.reportEvent(name: "close", parameters: ["screen": screenName])
    }
    
    // MARK: - Тапы на кнопки
    func trackButtonClick(screen: String, button: String) {
        AppMetrica.reportEvent(name: "click", parameters: ["screen": screen, "item": button])
    }
    
    // MARK: - Конкретные события
    func didTapAddTracker() {
        trackButtonClick(screen: "Trackers", button: "add_track")
    }
    
    func didTapEditTracker(trackerId: String) {
        AppMetrica.reportEvent(name: "click", parameters: ["screen": "Trackers", "item": "edit", "trackerId": trackerId])
    }
    
    func didTapDeleteTracker(trackerId: String) {
        AppMetrica.reportEvent(name: "click", parameters: ["screen": "Trackers", "item": "delete", "trackerId": trackerId])
    }
    
    func didTapFilterButton() {
        trackButtonClick(screen: "Trackers", button: "filter")
    }
    
    func didPinTracker(trackerId: String) {
        AppMetrica.reportEvent(name: "TrackerPinned", parameters: ["trackerId": trackerId])
    }
    
    func didUnpinTracker(trackerId: String) {
        AppMetrica.reportEvent(name: "TrackerUnpinned", parameters: ["trackerId": trackerId])
    }
    
    func didCompleteTracker(trackerId: String) {
        AppMetrica.reportEvent(name: "TrackerComplete", parameters: ["trackerId": trackerId])
    }
    
    func didUncompleteTracker(trackerId: String) {
        AppMetrica.reportEvent(name: "TrackerUncomplete", parameters: ["trackerId": trackerId])
    }
    
    func didChangeDate(selectedDate: String) {
        AppMetrica.reportEvent(name: "DateChanged", parameters: ["selectedDate": selectedDate])
    }
}
