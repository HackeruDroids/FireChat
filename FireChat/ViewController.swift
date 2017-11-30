//
//  ViewController.swift
//  FireChat
//
//  Created by hackeru on 12 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Auth.auth().currentUser else{
            //send to a sign in viewcontroller.
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                self.user = user
            })
            return
        }
        self.user = user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

