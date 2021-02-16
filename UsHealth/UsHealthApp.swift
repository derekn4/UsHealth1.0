//
//  UsHealthApp.swift
//  UsHealth
//
//  Created by Derek Nguyen on 1/27/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct UsHealthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(info: self.delegate)
        }
    }
}

//To Observer or read data from app delegate

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject {
    @Published var email = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Initialize Firebase
        FirebaseApp.configure()
        
        //Initialize Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
      }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }else {
            print("Log Out for \(self.email) success!")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else {return}
        
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken,
                                                       accessToken: user.authentication.accessToken)
        //Signin to Firebase
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }

            
            NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"),  object: nil)
            
            self.email = (result?.user.email)!
            //print(result?.user.email)
            
        }
    
    }

}
