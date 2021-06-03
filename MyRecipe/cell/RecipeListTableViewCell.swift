//
//  RecipeListTableViewCell.swift
//  MyRecipe
//
//  Created by Tim Sun on 26/5/21.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {

    static let identifier = "RecipeListTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RecipeListTableViewCell", bundle: nil)
    }

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var time2: UILabel!
    
    
    public func configure(title: String, image: String, time: String){
        recipeName.text = title
        recipeImage.image = UIImage(named: image)
        time2.text = time
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //myImageView.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
