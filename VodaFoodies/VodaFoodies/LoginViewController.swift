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
    
    @IBAction func tryAnimation(_ sender: Any) {
        
        let sb = UIStoryboard(name: "loadingView", bundle: Bundle.main)
        let loadingView = sb.instantiateInitialViewController() as! LoadingViewController
        loadingView.modalPresentationStyle = .overCurrentContext
        self.present(loadingView, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            // Put your code which should be executed with a delay here
            loadingView.dismiss(animated: true, completion: nil)
        })
    }
    @IBAction func signIn(_ sender: UIButton) {
        
        //TODO: Start the loading indicator
        
        let loginManager = LoginManager()
        loginManager.loginUser(controller: self) { result in
            
            //TODO: end the loading indicator
            
            switch result{
            case .success:
                self.performSegue(withIdentifier: "gotohome", sender: nil)
                break
            case .fail(let error):
                print(error)
                //TODO : Show an error message to the user
                break
            case .cancelled:
                break
            }
        }
        
    }
    
    
}
