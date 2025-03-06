import Foundation
import AppMetricaCore

final class TaskListViewModel {

    // MARK: - Properties

    var selectedDay: Date = Date() {
        didSet {
            onSelectedDayChanged?()
        }
    }
    var onSelectedDayChanged: (() -> Void)?
    var onDataGetChanged: (() -> Void)?
    var onCompletedDaysCountUpdated: (() -> Void)?
    var selectedFilter: Filters = .allTasks

    private var currentDate: Date {
        return Date()
    }
    var categories: [TrackerCategory] = []

    private let trackerStore = StoreManager.shared.trackerStore
    private let trackerRecordStore = StoreManager.shared.recordStore
    private let trackerCategoryStore = StoreManager.shared.categoryStore
    private let analyticsService = AnalyticsService()

    init() {
        trackerStore.onDataGetChanged = { [weak self] in
            self?.onDataGetChanged?()
        }

        trackerRecordStore.onRecordsUpdated = { [weak self] in
            self?.onCompletedDaysCountUpdated?()
        }
    }

    // MARK: - Public Helper Methods

    func applyFilter(searchText: String?) {
        switch selectedFilter {
        case .allTasks:
            categories = fetchTasksForDate(selectedDay)
        case .tasksForToday:
            selectedDay = Date()
            categories = fetchTasksForDate(selectedDay)
        case .completed:
            categories = fetchTasksForDate(selectedDay).map { category in
                TrackerCategory(
                    title: category.title,
                    tasks: category.tasks.filter { isTaskCompleted(for: $0, on: selectedDay) }
                )
            }.filter { !$0.tasks.isEmpty }
        case .incomplete:
            categories = fetchTasksForDate(selectedDay).map { category in
                TrackerCategory(
                    title: category.title,
                    tasks: category.tasks.filter { !isTaskCompleted(for: $0, on: selectedDay) }
                )
            }.filter { !$0.tasks.isEmpty }

        case .onSearch:
            guard let searchText = searchText else { return }
            categories = fetchTasksForDate(selectedDay).map { category in
                TrackerCategory(
                    title: category.title,
                    tasks: category.tasks.filter {
                        $0.name.lowercased().contains(searchText)
                    }
                )
            }.filter { !$0.tasks.isEmpty }

            if let pinnedIndex = categories.firstIndex(where: { $0.title == "Закрепленные" }) {
                var pinnedCategory = categories[pinnedIndex]
                pinnedCategory.tasks = pinnedCategory.tasks.filter {
                    $0.name.lowercased().contains(searchText)
                }
                if pinnedCategory.tasks.isEmpty {
                    categories.remove(at: pinnedIndex)
                } else {
                    categories[pinnedIndex] = pinnedCategory
                }
            }
        }
        onDataGetChanged?()
    }

    func fetchFilteredTasks(searchText: String?) -> [TrackerCategory] {
        applyFilter(searchText: searchText)
        return categories
    }

    func hasFilteredTasks(searchText: String?) -> Bool {
        return fetchFilteredTasks(searchText: searchText).flatMap { $0.tasks }.isEmpty == false
    }

    func fetchTasksForDate(_ date: Date) -> [TrackerCategory] {
        var fetchedCategoriesForToday = trackerCategoryStore.fetchCategoriesOnDate(date: date)
        let pinnedTrackerList = fetchedCategoriesForToday.flatMap { $0.tasks.filter { UserDefaultsSettings.shared.isPinned(trackerId: $0.id) } }

        fetchedCategoriesForToday = fetchedCategoriesForToday.map { category in
            let filteredTasks = category.tasks.filter { !UserDefaultsSettings.shared.isPinned(trackerId: $0.id) }
            return TrackerCategory(title: category.title, tasks: filteredTasks)
        }.filter { !$0.tasks.isEmpty }

        if !pinnedTrackerList.isEmpty {
            fetchedCategoriesForToday.insert(TrackerCategory(title: "Закрепленные", tasks: pinnedTrackerList), at: 0)
        }
        categories = fetchedCategoriesForToday
        onDataGetChanged?()
        return fetchedCategoriesForToday
    }

    func hasTasksForToday() -> Bool {
        return categories.isEmpty == false
    }

    func isTaskCompleted(for task: Tracker, on date: Date) -> Bool {
        return trackerRecordStore.isTaskComplete(for: task, on: date)
    }

    func toggleCompletionStatus(_ task: Tracker, on date: Date) {
        if isTaskCompleted(for: task, on: date) {
            unmarkTaskAsCompleted(task, on: date)
        } else {
            markTaskAsCompleted(task, on: date)
        }
    }

    func completedDaysCount(for taskId: UUID) -> Int {
        return trackerRecordStore.countCompletedDays(for: taskId)
    }

    // MARK: - Private Helper Methods

    private func markTaskAsCompleted(_ task: Tracker, on date: Date) {
        analyticsService.didCompleteTracker(trackerId: task.id.uuidString)
        trackerRecordStore.addRecordForTracker(for: task, on: date)
    }

    private func unmarkTaskAsCompleted(_ task: Tracker, on date: Date) {
        analyticsService.didUncompleteTracker(trackerId: task.id.uuidString)
        trackerRecordStore.removeRecordForTracker(for: task, on: date)
    }
}
