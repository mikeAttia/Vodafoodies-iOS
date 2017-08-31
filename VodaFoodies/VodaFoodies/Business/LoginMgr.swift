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
import Alamofire

class LoginMgr {
    
    var completionHandler: ((LoginResult)->Void)!
    var userData: User?
    
    enum LoginResult {
        case success
        case fail(Error)
        case cancelled
        //        case noPhone
    }
    
    
    /// Use to login the user using facebook OAuth
    func loginUser(controller: UIViewController, completion:@escaping (LoginResult)->Void ) {
        
        self.completionHandler = completion
        
        startLoginChain(controller: controller)
        
    }
    
    private func startLoginChain(controller: UIViewController){
        loginUserWithFb(controller: controller)
    }
    
    private func loginUserWithFb(controller: UIViewController){
        
        LoginManager().logIn([.publicProfile, .email],
                             viewController: controller) { result in
                                
                                switch result{
                                case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                                    self.getUserDataFromFacebook(token: token)
                                case .failed(let error):
                                    self.completionHandler(LoginResult.fail(error))
                                    print(error)
                                case .cancelled:
                                    self.completionHandler(LoginResult.cancelled)
                                }
        }
    }
    
    private func getUserDataFromFacebook(token: AccessToken){
        
        GraphRequest(graphPath: token.userId!,
                     parameters: ["fields":"name,email,link,picture.type(large)"],
                     accessToken: token,
                     httpMethod: .GET,
                     apiVersion: .defaultVersion)
            .start { (response, result) in
                
                switch response{
                case .some(_):
                    //TODO: Cache the user object into the UserDefaults
                    switch result{
                    case .success(response: let response):
                        let userData = response.dictionaryValue
                        let userName = userData?["name"] as? String
                        let userMail = userData?["email"] as? String
                        let userProfile = userData?["link"] as? String
                        let pictureData = userData?["picture"] as? [String : Any]
                        let imageData = pictureData?["data"] as? [String : Any]
                        let isSilhouette = imageData?["is_silhouette"] as? Int ?? 0
                        var imageUrl : String?
                        if isSilhouette == 0{
                            imageUrl = imageData?["url"] as? String
                        }
                        
                        self.userData = User(firebaseID: "",
                                             name: userName ?? "user",
                                             imageURL: imageUrl ?? "http://menshealthnz.org.nz/wp-content/uploads/2016/05/placeholder-user-photo.png",
                                             phoneNo: "not found",
                                             email: userMail ?? "not found",
                                             profile: userProfile ?? "no profile link")
                        
                        self.loginUserToFirebase(token: token)
                    case .failed(let error):
                        print(error)
                        self.completionHandler(LoginMgr.LoginResult.fail(error))
                    }
                    
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
            
            
            guard let userID = user?.uid else{
                //TODO: compose an error object can't sign in to firebase and call the completion handler
                return
            }
            
            self.userData?.firebaseID = userID
            
            self.writeUserDataToFirebase()
            self.completionHandler(LoginResult.success)
        }
        
    }
    
    private func writeUserDataToFirebase(){
        
        let parameters: Parameters = [
            (userData?.firebaseID)! :
                ["name" : (userData?.name)!,
                 "email" : (userData?.email)!,
                 "img" : (userData?.imageURL)!,
                 "phone" : (userData?.phoneNo)!
            ]
        ]
        //TODO: - Replse the following with an Alamofire Request
        
        //        Alamofire.request("http://localhost:5000/vodafoodies-e3f2f/us-central1/updateUserData", method: .post, parameters: parameters).response { res in
        //
        //            print(res.response ?? "response")
        //        }
        
    }
}
