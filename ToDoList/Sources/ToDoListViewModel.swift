import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    /// Le dépôt pour charger et sauvegarder les éléments de la liste
    private let repository: ToDoListRepositoryType

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.allToDoItems = repository.loadToDoItems()
        self.toDoItems = allToDoItems
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }
    
    /// L'index du filtre actuel
    var selectedFilterIndex: Int = 0
    
    /// Tous les éléments de la liste, non filtrés
    var allToDoItems: [ToDoItem] = []

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allToDoItems.append(item)
        
        applyFilter(at: selectedFilterIndex)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allToDoItems.firstIndex(where: { $0.id == item.id }) {
            allToDoItems[index].isDone.toggle()
            
            applyFilter(at: selectedFilterIndex)
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        allToDoItems.removeAll { $0.id == item.id }
        
        applyFilter(at: selectedFilterIndex)
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering
        switch index {
        case 0:
            toDoItems = allToDoItems
        case 1:
            toDoItems = allToDoItems.filter { $0.isDone }
        case 2:
            toDoItems = allToDoItems.filter { !$0.isDone }
        default:
            break
        }
        
        selectedFilterIndex = index
    }
}
