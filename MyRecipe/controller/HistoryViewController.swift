//
//  HistoryViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 6/6/21.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    var list = [History]()
    let db = DBHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        list = db.readHistory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "History", for: indexPath)
        
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "History")
        }
        //enable subtitle style
        cell.textLabel?.text = list[indexPath.row].name + " " + list[indexPath.row].date
        cell.detailTextLabel?.text = String(list[indexPath.row].rating) + "🌟 " + list[indexPath.row].comment
        return cell
    }
}
