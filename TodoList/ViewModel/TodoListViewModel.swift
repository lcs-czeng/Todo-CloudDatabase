//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by 曾梓恒 on 2025-04-03.
//

import Foundation

@Observable
class TodoListViewModel {
    
    // MARK: Stored properties
    // The list of to-do items
    var todos: [TodoItem]
    
    // MARK: Initializer(s)
    init(todos: [TodoItem] = []) {
        self.todos = todos
        Task {
            try await getTodos()
        }
    }
    
    // MARK: Functions
    
    func getTodos() async throws {
        
        do {
            let results: [TodoItem] = try await supabase
                .from("todos")
                .select()
                .execute()
                .value
            
            self.todos = results
            
        } catch {
            debugPrint(error)
        }
        
    }
    
    func createToDo(withTitle title: String) {
        
        // Create the new to-do item instance
        let todo = TodoItem(
            title: title,
            done: false
        )
        
        // Append to the array
        todos.append(todo)
        
    }
    
    func delete(_ todo: TodoItem) {
        
        // Create a unit of asynchronous work to add the to-do item
        Task {
            
            do {
                
                // Run the delete command
                try await supabase
                    .from("todos")
                    .delete()
                    .eq("id", value: todo.id!)  // Only delete the row whose id
                    .execute()                  // matches that of the to-do being deleted
                
                // Update the list of to-do items held in memory to reflect the deletion
                try await self.getTodos()
                
            } catch {
                debugPrint(error)
            }
            
            
        }
        
    }
    
    func update(todo updatedTodo: TodoItem) {
        
        // Create a unit of asynchronous work to add the to-do item
        Task {
            
            do {
                
                // Run the update command
                try await supabase
                    .from("todos")
                    .update(updatedTodo)
                    .eq("id", value: updatedTodo.id!)   // Only update the row whose id
                    .execute()                          // matches that of the to-do being deleted
                
            } catch {
                debugPrint(error)
            }
            
        }
        
    }
    
}
