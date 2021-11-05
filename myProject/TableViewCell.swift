//
//  TableViewCell.swift
//  myProject
//
//  Created by Вадим Сосновский on 03.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var desc: UILabel!
    @IBOutlet private weak var language: UILabel!
    @IBOutlet private weak var forks: UILabel!
    @IBOutlet private weak var stars: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        name.text = "Vadim"
        desc.text = "21"
        language.text = "Swift"
        forks.text = "Forks"
        stars.text = "Stars"
        author.text = "Vadim Sosnovsky"
    }
    
}
