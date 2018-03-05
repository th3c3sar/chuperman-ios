//
//  ViewController.swift
//  chuperman
//
//  Created by Cesar Saravia on 2/1/18.
//  Copyright © 2018 Cesar Saravia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginbutton=FBSDKLoginButton()
        view.addSubview(loginbutton)
        loginbutton.frame = CGRect(x: 16, y: 500, width: view.frame.width - 32, height: 50)
        loginbutton.delegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did Logout of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            print(error)
        }
        
        print("Succesfully logged in with Facebook..." )
        ShowEmailAddress()
    }
    
    func ShowEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accesTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accesTokenString)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil
            {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            print("Succesfully logged in with our user: ",user ?? "")
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{(connection,result,err) in
            if err != nil
            {
                print("Failed to start Graph Request", err ?? "")
            }
            print(result ?? "")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

