//
//  ViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 26/5/21.
//

import UIKit
import UserNotifications
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UISearchBarDelegate {
    //connect to db
    let db = DBHelper()
    //list for db load
    var list = [Recipe]()
    //recipe object for preparation
    var recipe = Recipe()
    var filteredlist = [Recipe]()
    var searching = false
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //rigister nib for use
        table.register(RecipeListTableViewCell.nib(), forCellReuseIdentifier: RecipeListTableViewCell.identifier)
       // db.insert(name: "test")
        list = db.read()
       // filteredlist = list
    }
    
    //create recipe on button click
    @IBAction func createRecipe(_ sender: Any) {
        performSegue(withIdentifier: "createRecipe", sender: self)
    }
    
    //https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
    //Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // searching = true
        //closure filters contain logic with case insensitive
        filteredlist = searchText.isEmpty ? list : list.filter { (item: Recipe) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
        table.reloadData()
    }
    
    //show searchbar when focused
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
        //Disable editing while searching
        self.table.setEditing(false, animated: true)
        self.searchBar.showsCancelButton = true
    }
    //clear searchbar when out of focus
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        table.reloadData()
    }
    
    //reload the table when new recipe is created
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        list = db.read()
        table.reloadData()
    }
    
    //disable editing during searching
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searching{
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //swipe to delete ttps://www.youtube.com/watch?v=F6dgdJCFS1Q
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //confirm deletion https://stackoverflow.com/questions/25511945/swift-alert-view-with-ok-and-cancel-which-button-tapped
            let refreshAlert = UIAlertController(title: "Delete recipe", message: "This recipe will be permanently removed.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!) in
                db.delete(name: list[indexPath.row].name)
                list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        recipe = list[indexPath.row]
       
        performSegue(withIdentifier: "showRecipe", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListTableViewCell.identifier, for: indexPath) as! RecipeListTableViewCell
        
        //find the document directory, userDomainmask and path of that image of the recipe
        //https://developer.apple.com/documentation/foundation/1414224-nssearchpathfordirectoriesindoma
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = paths.first
        //image will have the name of the recipe
        let imageURL = URL(fileURLWithPath: path!).appendingPathComponent("\(list[indexPath.row].name).jpg")
        
        if searching{
            cell.configure(title: filteredlist[indexPath.row].name, image: imageURL, time: filteredlist[indexPath.row].cooktime + " mins")
        }else{
            cell.configure(title: list[indexPath.row].name, image: imageURL, time:list[indexPath.row].cooktime + " mins")}
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return filteredlist.count
        }else{
            return list.count
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipe"
        {
        let viewController = segue.destination as! ViewRecipeViewController
            viewController.recipe = recipe
        }
    }
}

