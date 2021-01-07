//
//  ToDoItemViewController.swift
//  todoapp
//
//  Created by Bidhan Rai on 04/01/2021.
//

import UIKit
import os.log

class ToDoItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    /*
     This value is either passed by `ToDoItemTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new todo item.
     */
    var todoItem: ToDoItem?
    
//    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        
        // Set up views if editing an existing todo item.
        if let todoItem = todoItem {
            titleTextField.text = todoItem.title
        }
        
        //update the state of save button
        updateSaveButtonState()
        
        dateTimePicker.preferredDatePickerStyle = .compact
        dateTimePicker.minimumDate = Date()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyborad
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let title = titleTextField.text ?? ""
        let date = dateTimePicker.date
        
//        // Create Date Formatter
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.string(from: date)
         
        // Set the todo item to be passed to ToDoItemTableViewController after the unwind segue.
        todoItem = ToDoItem(title: title, date: date, active: true)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    //MARK: Actions
    @IBAction func cancel() {
        //depending on the style of presentation , this view controller needs to be dismissed in two different ways
        
        let isPresentingInAddToDoItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoItemMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationControllerv = navigationController {
            owningNavigationControllerv.popViewController(animated: true)
        }else {
            fatalError("The ToDoItemViewController is not inside a navigation controller.")
        }
    }

}

