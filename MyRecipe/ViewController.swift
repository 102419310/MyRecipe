//
//  ViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 26/5/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(RecipeListTableViewCell.nib(), forCellReuseIdentifier: RecipeListTableViewCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        //show badge
        //UIApplication.shared.applicationIconBadgeNumber = 0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    /*Deprecated
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        completionHandler(UNNotificationPresentationOptions.banner)
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //1. Create notification center object
        let center = UNUserNotificationCenter.current()
        //2. Ask for permission
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            //do something if denied
        }
        //3. Create notification content, with title and body
        let content = UNMutableNotificationContent()
       // content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
        content.title = "Hey there"
        content.body = "Check out for popular recipe!⬆️"
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber;
        content.sound = UNNotificationSound.default
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListTableViewCell.identifier, for: indexPath) as! RecipeListTableViewCell
        cell.configure(title: "Unadon", image: "dish", time: "15~20"+" mins")
        return cell
    }
}

