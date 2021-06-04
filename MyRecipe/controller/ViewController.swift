//
//  ViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 26/5/21.
//

import UIKit
import UserNotifications
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    //connect to db
    let db = DBHelper()
    //list for db load
    var list = [Recipe]()
    //recipe object for preparation
    var recipe = Recipe()
    //deletion confirmation
    var rdelete = false

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //rigister nib for use
        table.register(RecipeListTableViewCell.nib(), forCellReuseIdentifier: RecipeListTableViewCell.identifier)
       // db.insert(name: "test")
        list = db.read()
    }
    
    //create recipe on button click
    @IBAction func createRecipe(_ sender: Any) {
        performSegue(withIdentifier: "createRecipe", sender: self)
    }
    //reload the table when new recipe is created
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        list = db.read()
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    /*Deprecated
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        completionHandler(UNNotificationPresentationOptions.banner)
    }
    */
    
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
        //1. Create notification center object
        let center = UNUserNotificationCenter.current()
        //2. Ask for permission
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            //do something if denied
        }
        //3. Create notification content, with title and body
        let content = UNMutableNotificationContent()
       // content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
        content.title = "Hey there"
        content.body = "Check out for popular recipe!⬆️"
        content.sound = UNNotificationSound.default
        UIApplication.shared.applicationIconBadgeNumber += 1
        //4. Create a notification trigger
        let date = Date().addingTimeInterval(1)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //5. Create a request to encapsule items above as an object
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        //6. Register the request with notificatino center
        center.add(request){(error) in
            if error != nil {
                  // Handle any errors.
               }
        }
        performSegue(withIdentifier: "showRecipe", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListTableViewCell.identifier, for: indexPath) as! RecipeListTableViewCell
        cell.configure(title: list[indexPath.row].name, image: "dish", time: list[indexPath.row].cooktime + " mins")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipe"
        {
        let viewController = segue.destination as! ViewRecipeViewController
            viewController.recipe = recipe
        }
    }
}

