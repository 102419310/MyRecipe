//
//  ViewRecipeViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 4/6/21.
//

import UIKit

class ViewRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var preparationtime: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    var recipe = Recipe()

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeName.text = recipe.name
        difficulty.text = "Difficulty: " + String(recipe.difficulty) + "🌟"
        preparationtime.text = recipe.cooktime
        ingredients.text = recipe.ingredients
        steps.text = recipe.steps
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
