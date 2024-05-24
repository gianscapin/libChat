//
//  TypeTableViewController.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/10/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

class TypeTableViewController: UITableViewController {

    private var botones: [Buttons] = []
    
    private var botonesHistory:[Int] = []
    
    
    @IBOutlet var typeTableView: UITableView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.botones = UserDefaults.standard.getConfig()?.types ?? []
        
        if(botones.count == 1 && (botones[0].childs == nil ||  botones[0].childs?.count == 0)) {
            openChat(id: botones[0].id)
        } else {
            super.viewDidAppear(true)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Volver", style: UIBarButtonItem.Style.done, target: self, action: #selector(TypeTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        
        if(botonesHistory.isEmpty) {
             _ = navigationController?.popViewController(animated: true)
        } else {
            botonesHistory.removeLast()
            
            self.botones = UserDefaults.standard.getConfig()?.types ?? []
            self.botonesHistory.forEach { (index) in
                self.botones = self.botones[index].childs!
            }
            self.typeTableView.reloadData()
            
        }
    }


    
    // MARK: - Table view data sourc

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return botones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TypeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TypeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        let button = botones[indexPath.row]
        
        cell.typeButton.text = button.name
        cell.typeButton.backgroundColor = self.hexStringToUIColor(hex: button.backgroundColor ?? "#ffffff")
        cell.typeButton.textColor =  self.hexStringToUIColor(hex: button.textColor ?? "#000000")
        cell.typeButton.font = cell.typeButton.font.withSize(CGFloat((button.fontSize ?? "30").floatValue))
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TypeTableViewCell
        
        if(botones[indexPath.row].childs == nil || botones[indexPath.row].childs?.count == 0 ) {
            print(cell.typeButton.text!)
            openChat(id: botones[indexPath.row].id)
        } else {
            self.botonesHistory.append(indexPath.row)
            self.botones = botones[indexPath.row].childs!
            self.typeTableView.reloadData()
        }
        
        
    }
    
    private func openChat(id: Int) {
        let chatView =  self.storyboard?.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
        chatView.tipo = String(id)
        let navigationController = UINavigationController()
        navigationController.viewControllers = [chatView]
        self.present(navigationController, animated: true, completion: nil)
        
    }
    

}
