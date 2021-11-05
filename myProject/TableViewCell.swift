//
//  TableViewCell.swift
//  myProject
//
//  Created by Вадим Сосновский on 03.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var labelProgLang: UILabel!
    @IBOutlet private weak var labelForks: UILabel!
    @IBOutlet private weak var labelStars: UILabel!
    @IBOutlet private weak var labelAuthorName: UILabel!
    @IBOutlet private weak var imageViewAuthor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        labelName.text = "Vadim"
        labelDescription.text = "21"
        labelProgLang.text = "Swift"
        labelForks.text = "Forks"
        labelStars.text = "Stars"
        labelAuthorName.text = "Vadim Sosnovsky"
    }
    
}
