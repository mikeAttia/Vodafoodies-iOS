//
//  LoginMgr.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/4/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FirebaseAuth

class LoginMgr {
    
    var completionHandler: ((LoginResult)->Void)!
    
    enum LoginResult {
        case success
        case fail(Error)
        case cancelled
        case noPhone
    }
    
    func loginUser(controller: UIViewController, completion:@escaping (LoginResult)->Void ) {
        
        self.completionHandler = completion
        
        startLoginChain(controller: controller)
        
    }
    
    private func startLoginChain(controller: UIViewController){
        loginUserWithFb(controller: controller)
    }
    
    private func loginUserWithFb(controller: UIViewController){
    
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn([.publicProfile, .email],
                             viewController: controller) { result in
                                
                                switch result{
                                case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                                    self.getUserDataFromFacebook(token: token)
                                case .failed(let error):
                                    self.completionHandler(LoginResult.fail(error))
                                case .cancelled:
                                    self.completionHandler(LoginResult.cancelled)
                                }
        }
    }
    
    private func getUserDataFromFacebook(token: AccessToken){
        
        let request = GraphRequest(graphPath: token.userId!,
                                   parameters: ["fields":"name,email,picture.type(large)"],
                                   accessToken: token,
                                   httpMethod: .GET,
                                   apiVersion: .defaultVersion)
        
        request.start { (response, result) in
            
            switch response{
            case .some(_):
                //TODO: Parse the user data coming from facebook into a User Object
                //TODO: Cache the user object into the UserDefaults
                print(result)
                //TODO: Login User to Firebase
                self.loginUserToFirebase(token: token)
            case .none:
                //TODO: Call the completion handler with an error object of can't get user data
                break
            }
        }
    }
    
    private func loginUserToFirebase(token: AccessToken){
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
        Auth.auth().signIn(with: credential){ (user, error) in
            
            if let error = error {
                print(error)
                self.completionHandler(LoginResult.fail(error))
                return
            }
            
            // User is signed in
            // TODO: Cache the user uid to the UserDefaults to use later
            // TODO: call the writeUserDataToFirebase to create the user node on firebase with the user details from the user defaults (or get it from previous method)
            print("+++++++======+=+=====++==+=+=++=+=+=+++++Firebase Login Success")
            print(user?.uid)
            guard (user?.uid) != nil else{
                //TODO: compose an error object and call the completion handler
                return
            }
            
            guard (user?.phoneNumber) != nil else{
                self.completionHandler(LoginResult.noPhone)
                return
            }
            
            self.completionHandler(LoginResult.success)
        
        }
    
    }
    
    private func writeUserDataToFirebase(userId: String, userData: User){
    
        //TODO: Check first for ways to store and access the user data from other profiles if possible 
        // before writing it in separate node in the database
        //TODO: Write the facebook UserData to firebase 
//        self.completionHandler(LoginResult.success)
    }
    
}
