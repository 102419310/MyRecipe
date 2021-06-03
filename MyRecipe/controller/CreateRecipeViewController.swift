//
//  CreateRecipeViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 3/6/21.
//

import UIKit

class CreateRecipeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var recipename: UITextField!
    @IBOutlet weak var cooktime: UITextField!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var steps: UITextView!
    @IBOutlet weak var difficulty: UISlider!
    @IBOutlet weak var indicator: UILabel!
    @IBOutlet weak var warning: UILabel!
    
    @IBAction func sliderChanged(_ sender: Any) {
        let sliderValue = Int(round(difficulty.value))
        indicator.text = "Difficulty: " + String(sliderValue)
    }
    //check the data and go back to home page
    //validation tut:https://www.youtube.com/watch?v=GczyH6sPBbI
    @IBAction func confirm(_ sender: Any) {
        //character within 0~25
        guard let name = recipename.text, (recipename.text?.count) != 0, (recipename.text!.count) <= 25
        else {
            warning.text = "Please enter your recipe name correctly."
            return
        }
        //cannot be empty
        guard let cookt = cooktime.text, (cooktime.text?.count) != 0
        else {
            warning.text = "Please enter your cook time."
            return
        }
        //cannot be empty
        guard let ingred = ingredients.text, (ingredients.text?.count) != 0
        else {
            warning.text = "Please enter your ingredients."
            return
        }
        //cannot be empty
        guard let step = steps.text, (steps.text?.count) != 0
        else {
            warning.text = "Please enter your steps."
            return
        }
        let db = DBHelper()
        db.insert(name: name, cooktime: cookt, ingredients: ingred, steps: step, difficulty: Int(round(difficulty.value)))
        _ = navigationController?.popViewController(animated: true)
    }
    //planning to make these into table view so users can select whether to add more columns
    override func viewDidLoad() {
        super.viewDidLoad()
        steps.layer.borderWidth = 0.3
        ingredients.layer.borderWidth = 0.3
        warning.text = ""
    }
    
//remove the keyboard when other place is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
