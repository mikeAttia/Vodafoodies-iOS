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
import Pastel

class LoginViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Adding the gradient animated background
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)
            ])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
    }
    
//    @IBAction func tryAnimation(_ sender: Any) {
//        
//        let sb = UIStoryboard(name: "loadingView", bundle: Bundle.main)
//        let loadingView = sb.instantiateInitialViewController() as! LoadingViewController
//        loadingView.modalPresentationStyle = .overCurrentContext
//        self.present(loadingView, animated: true, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            // Put your code which should be executed with a delay here
//            loadingView.dismiss(animated: true, completion: nil)
//        })
//    }
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
