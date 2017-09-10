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

class LoginManager {
    
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
        
        FacebookLogin.LoginManager().logIn([.publicProfile, .email],
                             viewController: controller) { result in
                                
                                switch result{
                                case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                                    self.getUserDataFromFacebook(token: token)
                                case .failed(let error):
                                    self.completionHandler(LoginResult.fail(error))
                                    printError(error.localizedDescription, title: "Facebook Login Error")
                                case .cancelled:
                                    self.completionHandler(LoginResult.cancelled)
                                }
        }
    }
    
    private func getUserDataFromFacebook(token: AccessToken){
        
        GraphRequest(graphPath: token.userId!,
                     parameters: ["fields":"name,gender,email,link,picture.type(large)"],
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
                        let userGender = userData?["gender"] as? String
                        let pictureData = userData?["picture"] as? [String : Any]
                        let imageData = pictureData?["data"] as? [String : Any]
                        let isSilhouette = imageData?["is_silhouette"] as? Int ?? 0
                        
                        //Saving user's gender
                        Const.Global.userGender = userGender ?? ""
                        
                        //saving user image
                        var imageUrl : String?
                        if isSilhouette == 0{
                            imageUrl = imageData?["url"] as? String
                        }
                        
                        // Saving user data Object
                        self.userData = User(firebaseID: "",
                                             name: userName ?? "",
                                             imageURL: imageUrl ?? "http://menshealthnz.org.nz/wp-content/uploads/2016/05/placeholder-user-photo.png",
                                             phoneNo: "",
                                             email: userMail ?? "",
                                             profile: userProfile ?? "")
                        
                        //Continue login chain
                        self.loginUserToFirebase(token: token)
                    case .failed(let error):
                        printError(error.localizedDescription, title: "Facebook Graph Request Error")
                        self.completionHandler(LoginManager.LoginResult.fail(error))
                    }
                    
                case .none:
                    //TODO: Call the completion handler with an error object of can't get user data
                    let err = RequestError(error: "Couldn't get user data from facebook")
                    self.completionHandler(LoginResult.fail(err))
                }
        }
    }
    
    private func loginUserToFirebase(token: AccessToken){
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
        Auth.auth().signIn(with: credential){ (user, error) in
            
            if let error = error {
                printError(error.localizedDescription, title: "FireBase Login Error")
                self.completionHandler(LoginResult.fail(error))
                return
            }
            
            
            guard let userID = user?.uid else{
                let err = RequestError(error: "Couldn't get user id from firebase")
                self.completionHandler(LoginResult.fail(err))
                return
            }
            
            self.userData?.firebaseID = userID
            Const.Global.userID = userID
            Const.Global.loggedInUser = self.userData!
            self.writeUserDataToFirebase()
            self.completionHandler(LoginResult.success)
        }
        
    }
    
    private func writeUserDataToFirebase(){
        
        func callBack(_ err: RequestError?){
            if let err = err{
                printError(err.error, title: "Submitting user data to Firebase error")
            }
        }
        
        if let userData = userData{
            let request = VodaFoodies.Request.user(.updateUserData(userData: userData,callBack: callBack))
            DataStore.shared.getData(req: request)
        }
        
        
    }
}
