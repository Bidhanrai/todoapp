//
//  ToDoListTableViewController.swift
//  todoapp
//
//  Created by Bidhan Rai on 04/01/2021.
//

import UIKit
import os.log

class ToDoListTableViewController: UITableViewController {
    
    //MARK: Properties
    var toDoItems = [ToDoItem]()
    
    //object of class LocalNotificationManager
    let localNotificationManager = LocalNotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //load saved data otherwise load sample data
        if let savedToDoItems = loadToDoItems() {
            toDoItems += savedToDoItems
        } else {
            //load sample data in table
            loadSamples()
        }
   
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ToDoItemTableViewCell"
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate todo item for the data source layout.
        let toDoItem = toDoItems[indexPath.row]
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
    
        cell.toDoLabel.text = toDoItem.title
        cell.toDoItemDateAndTime.text = dateFormatter.string(from: toDoItem.date)
//        if toDoItem.active {
//            cell.tickImage.image = UIImage(named: "right.png")
//        } else {
//            cell.tickImage.image = UIImage(named: "wrong.png")
//        }
      

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            toDoItems.remove(at: indexPath.row)
            
            //when deleteing to todo item deleting its corresponding notification
            localNotificationManager.removeNotification(identifier: [String(indexPath.row)])
            
            saveToDoItems()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
            case "AddToDoItem":
                os_log("Adding a new Todo item.", log: OSLog.default, type: .debug)
            case "ShowDetail":
                guard let toDoItemViewController = segue.destination as? ToDoItemViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedToDoCell = sender as? ToDoItemTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedToDoCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedToDoItem = toDoItems[indexPath.row]
                toDoItemViewController.todoItem = selectedToDoItem
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
    }
    
    
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
        //updating the table when adding or editing the items
        if let sourceViewController = sender.source as? ToDoItemViewController, let toDoItem = sourceViewController.todoItem {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing todo item.
                toDoItems[selectedIndexPath.row] = toDoItem
                //removing the old notificaton of the corresponding todo item
                localNotificationManager.removeNotification(identifier: [String(selectedIndexPath.row)])
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                localNotificationManager.addNotifications(toDoItem: toDoItem, indexValue: selectedIndexPath.row)
            } else {
                // Add a new todo item.
                let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
                toDoItems.append(toDoItem)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                localNotificationManager.addNotifications(toDoItem: toDoItem, indexValue: newIndexPath.row)
            }
            
            saveToDoItems()
            
        }
        
    }
    
    //MARK: Private Methods
    
    private func loadSamples() {
        //loading dummy data to array
        guard  let data1 = ToDoItem(title: "Buy Movie Tickets", date: Date(), active: true) else {
            fatalError("Unable to instantiate data1")
        }
        
        guard  let data2 = ToDoItem(title: "Buy Pork Chops", date: Date(), active: true) else {
            fatalError("Unable to instantiate data1")
        }
        
        toDoItems += [data1, data2]
    }
    
    private func saveToDoItems() {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: toDoItems, requiringSecureCoding: false)
        do {
            try data.write(to: ToDoItem.ArchiveURl)
            print("Saved Succesfully")
            
        } catch{
            print("cound not write to save file" + error.localizedDescription)
        }
    }
    
    private func loadToDoItems() -> [ToDoItem]? {
        guard let codedData = try? Data(contentsOf: ToDoItem.ArchiveURl) else { return nil }
        
        // 3
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as?
            [ToDoItem]

    }
    

}
