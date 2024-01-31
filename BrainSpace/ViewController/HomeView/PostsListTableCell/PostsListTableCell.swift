//
//  PostsListTableCell.swift
//  BrainSpace
//
//  Created by Kiran Sarvaiya on 31/01/24.
//  Copyright © 2024 Kiran Sarvaiya. All rights reserved.
//

import UIKit

class PostsListTableCell: UITableViewCell {
    
    @IBOutlet weak var postTitleLabel: UILabel?
    @IBOutlet weak var postDetailsLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setPostDetails(title: String?, body: String?) {
        postTitleLabel?.text = title
        postDetailsLabel?.text = body
    }
}
