//
//  PostsCommentTableCell.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright © 2024 Kiran Sarvaiya. All rights reserved.
//

import UIKit

class PostsCommentTableCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel?
    @IBOutlet weak var userEmailLabel: UILabel?
    @IBOutlet weak var userCommentLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCommentData(_ name: String?, email: String?, _ body: String?) {
        userNameLabel?.text = name
        userEmailLabel?.text = email
        userCommentLabel?.text = body
    }
    
}
