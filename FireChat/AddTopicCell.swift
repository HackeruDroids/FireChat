//
//  AddTopicCell.swift
//  FireChat
//
//  Created by hackeru on 12 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddTopicCell: UITableViewCell {

    @IBAction func addTopic(_ sender: UIButton) {
        //we also need:
        //ownerName, topicId -> Todo get it from childByAutoId
        //Date
        guard let text = topicTextField.text,
        let userid = Auth.auth().currentUser?.uid
        else {
            //no data to write to database.
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat], animations: {
            //transform
            sender.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
        
        
        let topicsRef = Database.database().reference(withPath: "topics").childByAutoId()
        let topicID = topicsRef.key
        
        let topic = Topic(topic: text, id: topicID, owner: userid)
        
        topicsRef.setValue(topic.json) { (error, ref) in
            if error == nil{
                self.topicTextField.text = nil
            }
            //cancel the animation
            sender.layer.removeAllAnimations()
            
            //restore the button to the default state.
            sender.transform = CGAffineTransform.identity
        }
    }
    
    @IBOutlet weak var topicTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
