import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }
    
    @Published var filteredToDoItems: [ToDoItem] = []
    @Published var selectedFilterIndex: Int = 0

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering
        
        selectedFilterIndex = index
        
        switch index {
        case 0:
            filteredToDoItems = toDoItems
        case 1:
            filteredToDoItems = toDoItems.filter { $0.isDone }
        case 2:
            filteredToDoItems = toDoItems.filter { !$0.isDone }
        default:
            filteredToDoItems = toDoItems
        }
    }
}
