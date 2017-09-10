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
    @IBOutlet weak var emailBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TESTING
        user.phoneNo = "01285294378"
        ////////
        profilePic.kf.setImage(with: URL(string: user.imageURL))
        nameBtn.setTitle(user.name, for: .normal)
        emailBtn.setTitle(user.email, for: .normal)
        phoneBtn.setTitle(user.phoneNo, for: .normal)
        nameBtn.titleLabel?.text = user.name
        emailBtn.titleLabel?.text = user.email
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
    @IBAction func openEmail(_ sender: Any) {
    }
    
}
