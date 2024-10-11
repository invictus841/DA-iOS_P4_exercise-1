import SwiftUI

struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoListViewModel
    @State private var newTodoTitle = ""
    @State private var isShowingAlert = false
    @State private var isAddingTodo = false
    
    // New state for filter index
    @State private var filterIndex = 0
    
    // MARK: - la valeur par défaut dans le picker
    @State private var selectedStatus: TaskStatus = .all
        
    // MARK: - ici les deux états d'un ToDoItem, et all
        enum TaskStatus: String, CaseIterable {
            case all = "All"
            case done = "Done"
            case notDone = "Not Done"
        }
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter selector
                // TODO: - Add a filter selector which will call the viewModel for updating the displayed data
                Picker("Task Status", selection: $selectedStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                            .tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                // List of tasks
                List {
                    ForEach(viewModel.filteredToDoItems) { item in
                        HStack {
                            Button(action: {
                                viewModel.toggleTodoItemCompletion(item)
                            }) {
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(item.isDone ? .green : .primary)
                            }
                            Text(item.title)
                                .font(item.isDone ? .subheadline : .body)
                                .strikethrough(item.isDone)
                                .foregroundColor(item.isDone ? .gray : .primary)
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let item = viewModel.toDoItems[index]
                            viewModel.removeTodoItem(item)
                        }
                    }
                }
                .onChange(of: selectedStatus) { newValue in
                    viewModel.applyFilter(at: selectedStatus.hashValue)
                }
                
                // Sticky bottom view for adding todos
                if isAddingTodo {
                    HStack {
                        TextField("Enter Task Title", text: $newTodoTitle)
                            .padding(.leading)

                        Spacer()
                        
                        Button(action: {
                            if newTodoTitle.isEmpty {
                                isShowingAlert = true
                            } else {
                                viewModel.add(
                                    item: .init(
                                        title: newTodoTitle
                                    )
                                )
                                newTodoTitle = "" // Reset newTodoTitle to empty.
                                isAddingTodo = false // Close the bottom view after adding
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                
                // Button to toggle the bottom add view
                Button(action: {
                    isAddingTodo.toggle()
                }) {
                    Text(isAddingTodo ? "Close" : "Add Task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()

            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
            .onAppear {
                viewModel.applyFilter(at: selectedStatus.hashValue)
            }
        }
    }
    
//    private var filteredTodos: [ToDoItem] {
//            switch selectedStatus {
//            case .all:
//                return viewModel.toDoItems
//            case .done:
//                return viewModel.toDoItems.filter { $0.isDone }
//            case .notDone:
//                return viewModel.toDoItems.filter { !$0.isDone }
//            }
//        }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(
            viewModel: ToDoListViewModel(
                repository: ToDoListRepository()
            )
        )
    }
}
