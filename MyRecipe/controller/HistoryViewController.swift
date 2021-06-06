//
//  HistoryViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 6/6/21.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    var list = [History]()
    let db = DBHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        list = db.readHistory()
    }
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        //sort by recipe rating
        case 0:
            list.sort(by:{
            (a1:History, a2:History)->Bool
            in
            return a1.rating>a2.rating
        })
        table.reloadData()
        //sort by date
        case 1:
            list.sort(by:{
            (a1:History, a2:History)->Bool
            in
            return a1.date>a2.date
        })
        table.reloadData()
        //sort by phone number from small to large
        default:
            break
        }
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
        cell.textLabel?.text = list[indexPath.row].name + " | " + list[indexPath.row].date
        cell.detailTextLabel?.text = String(list[indexPath.row].rating) + "🌟 " + list[indexPath.row].comment
        return cell
    }
    
    //reload the table when history is created
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        list = db.readHistory()
        table.reloadData()
    }
}
