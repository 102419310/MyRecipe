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
    
    @IBAction func sliderChanged(_ sender: Any) {
        let sliderValue = Int(round(difficulty.value))
        indicator.text = "Difficulty: " + String(sliderValue)
    }
    //check the data and go back to home page
    @IBAction func confirm(_ sender: Any) {
        let db = DBHelper()
        db.insert(name: recipename.text!, cooktime: cooktime.text!, ingredients: ingredients.text!, steps: steps.text!, difficulty: Int(round(difficulty.value)))
        _ = navigationController?.popViewController(animated: true)
    }
    //planning to make these into table view so users can select whether to add more columns
    override func viewDidLoad() {
        super.viewDidLoad()
        steps.layer.borderWidth = 0.3
        ingredients.layer.borderWidth = 0.3
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
