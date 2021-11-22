//
//  FavRepoTableViewCell.swift
//  myProject
//
//  Created by Вадим Сосновский on 10.11.2021.
//

import UIKit

class FavRepoTableViewCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var desc: UILabel!
    @IBOutlet private weak var language: UILabel!
    @IBOutlet private weak var forks: UILabel!
    @IBOutlet private weak var stars: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String, desc: String, language: String, forks: String, stars: String, author: String) {
        self.name.text = name
        self.desc.text = desc
        self.language.text = language
        self.forks.text = forks
        self.stars.text = stars
        self.author.text = author
    }
    
}
