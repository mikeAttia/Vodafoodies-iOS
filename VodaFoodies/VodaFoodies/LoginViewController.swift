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
    
    //View Outlets
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var catchPhraseImg: UIImageView!
    @IBOutlet weak var madeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGradientBackground()
        fbLoginBtn.layer.cornerRadius = 5
        fbLoginBtn.clipsToBounds = true
        
        catchPhraseImg.transform = CGAffineTransform(scaleX: 0, y: 0)
        fbLoginBtn.alpha = 0
        madeLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoCenterConstraint.constant = -100
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self!.view.layoutIfNeeded()
            self!.catchPhraseImg.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { [weak self] (done) in
            if done{
                UIView.animate(withDuration: 1, animations: {
                    self!.fbLoginBtn.alpha = 1
                }, completion: { [weak self] (done) in
                    if done{
                        UIView.animate(withDuration: 0.5, animations: {
                            self!.madeLabel.alpha = 1
                        })
                    }
                })
                
            }
        }
        
        
    }
    
    private func addGradientBackground(){
        // Adding the gradient animated background
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 223/255, green: 233/255, blue: 243/255, alpha: 1.0),UIColor.white ])
        
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
