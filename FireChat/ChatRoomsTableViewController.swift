//
//  ChatRoomsTableViewController.swift
//  FireChat
//
//  Created by hackeru on 12 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatRoomsTableViewController: UITableViewController {
    
    var user: User?
    var data:[Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Auth.auth().currentUser else{
            //send to a sign in viewcontroller.
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                self.user = user
                self.startObserving()
            })
            return
        }
        self.user = user
        //can read from the database!
        startObserving()
    }
    func startObserving(){
        let ref = Database.database().reference(withPath: "topics")
        ref.observe(.childAdded) { (snapshot) in
            guard let topic = Topic(snapshot: snapshot) else{return}
            
            let path = IndexPath(row: self.data.count, section: 1)
            self.data.append(topic)
            self.tableView.insertRows(at: [path], with: .automatic)
        }
        
        
        ref.observe(.childChanged) { (snapshot) in
            //deserialization...
            guard let topic = Topic(snapshot: snapshot) else{return}
            
            for (i, t) in self.data.enumerated(){
                if t.id == topic.id{
                    //found
                    //1) change the value in the data array
                    self.data[i] = topic
                    //2) update the tableView
                    let idxPath = IndexPath(row: i, section: 1)
                    self.tableView.reloadRows(at: [idxPath], with: .automatic)
                    return
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //add Topic cell...
            return tableView.dequeueReusableCell(withIdentifier: "addTopicCell", for: indexPath)
        }
        
        //if we got thus far... Topic Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! TopicCell
        
        // Data Binding
        let item = data[indexPath.row]
        cell.topicLabel.text = item.topic
        return cell
    }
    
    //perform the segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic:Topic = data[indexPath.row]
        
        performSegue(withIdentifier: "toChat", sender: topic)
    }
    
    //pass data with the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? ChatController,
              let topic = sender as? Topic
            else {return}
        
        dest.topic = topic
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
