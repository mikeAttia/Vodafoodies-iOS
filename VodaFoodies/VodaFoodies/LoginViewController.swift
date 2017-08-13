//
//  ViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/3/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class LoginViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "gotohome", sender: nil)
        
        //WARNING: Remove the line above and uncomment the code below
        
        
//        //TODO: Start the loading indicator
//        
//        let loginManager = LoginMgr()
//        loginManager.loginUser(controller: self) { result in
//            
//            switch result{
//            case .success:
//                //TODO: end the loading indicator
//                self.performSegue(withIdentifier: "gotohome", sender: nil)
//                break
//            case .fail(let error):
//                print(error)
//                break
//            case .cancelled:
//                break
//            }
//        }
        
    }
    
    
}
