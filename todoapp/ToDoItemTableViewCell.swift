//
//  ToDoItemTableViewCell.swift
//  todoapp
//
//  Created by Bidhan Rai on 04/01/2021.
//

import UIKit

class ToDoItemTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var toDoItemDateAndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
