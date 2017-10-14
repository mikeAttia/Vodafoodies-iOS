//
//  ProfileViewcontroller.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    //Instance Properties
    var user = Const.Global.loggedInUser
    
    //MARK: - View Outlets
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var contactCard: UIView!
    
    override func viewDidLoad() {
        // setting view
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1.0)
        
        // Setup pic
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.clipsToBounds = true
//        profilePic.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1.0).cgColor
//        profilePic.layer.borderWidth = 1
        
        // setup contact card
        contactCard.backgroundColor = UIColor.white
        contactCard.layer.cornerRadius = 7
        
        fillUserData()
    }
    
    func fillUserData(){
        //TESTING
        user.phoneNo = "01285294378"
        ////////
        profilePic.kf.setImage(with: URL(string: user.imageURL))
        nameBtn.setTitle(user.name, for: .normal)
        phoneBtn.setTitle(user.phoneNo, for: .normal)
        nameBtn.titleLabel?.text = user.name
        phoneBtn.titleLabel?.text = user.phoneNo
    }
    
    //MARK: - View actions
    @IBAction func goToFBProfile(_ sender: Any) {
    }
    
    
    @IBAction func callUser(_ sender: Any) {
        
        if let url = URL(string: "tel://\(user.phoneNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func logoutUser(_ sender: UIButton) {
        LoginManager().logoutUser()
    }
    
}
