//
//  UserCell.swift
//  GithubAPITest
//
//  Created by 김민순 on 2021/10/29.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
