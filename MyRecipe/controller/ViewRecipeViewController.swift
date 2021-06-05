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
    
    //save the tried recipe
    @IBAction func finish(_ sender: Any) {
        let alert = UIAlertController(title: "Rate this recipe", message: "How you went through this recipe", preferredStyle: UIAlertController.Style.alert )
            let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let rating = alert.textFields![0] as UITextField
            let comment = alert.textFields![1] as UITextField
            let formatter = DateFormatter()
                formatter.timeStyle = .medium
            let time = formatter.string(from: Date())
            let db = DBHelper()
                db.insertHistory(name: self.recipe.name, date: time, comment: comment.text!, rating: Int(rating.text!)!)
            }
                alert.addTextField { (textField) in
                textField.placeholder = "Enter your rating of the recipe (0-5) "
                }
                alert.addTextField { (textField) in
                textField.placeholder = "Enter your short comments"
                }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
                alert.addAction(save)
                alert.addAction(cancel)
                self.present(alert, animated:true, completion: nil)
            }

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
