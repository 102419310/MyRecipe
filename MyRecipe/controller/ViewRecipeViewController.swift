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
    
    //share the recipe to twitter
    @IBAction func share(_ sender: Any) {
        //content of the tweet
        let tweetText = "Recipe: \(recipe.name), Ingredients: \(recipe.ingredients), Steps: \(recipe.steps)"
        //let tweetUrl = ""
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)"
        //encode the shareString (space) for url cast
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        //cast to an url
        let url = URL(string: escapedShareString)
        //content displayed on the alert
        let alert = UIAlertController(title:"Recipe details", message: "Share this recipe", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Share on Twitter", style: .default) { (action )in
           //open the retweet in the browser
            UIApplication.shared.open(url!)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add action to action sheet
        alert.addAction(action1)
        alert.addAction(actionCancel)
        //present or we say pop up the alert
        self.present(alert, animated: true, completion:nil)
 
    }
    
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
}
