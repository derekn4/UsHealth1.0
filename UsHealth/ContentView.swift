//
//  ContentView.swift
//  UsHealth
//
//  Created by Derek Nguyen on 1/27/21.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct ContentView: View {
    
    @ObservedObject var info : AppDelegate
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        VStack{
            if user != nil {
                Home()
            }
            else {
                OnBoard()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (_) in
                self.user = Auth.auth().currentUser
            }
        }
    }
}

struct OnBoard : View {
    
    @State var onBoard = [
      
              Board(title: "Data Analysis", detail: "Data analysis is a process of inspecting, cleansing, transforming and modeling data with the goal of discovering useful information, informing conclusions and supporting decision-making.", pic: "b1"),
              
              Board(title: "Social Media", detail: "Social media are interactive computer-mediated technologies that facilitate the creation or sharing of information, ideas, career interests and other forms of expression via virtual communities and networks.", pic: "b2"),
              
              Board(title: "Software Development", detail: "Software development is the process of conceiving, specifying, designing, programming, documenting, testing, and bug fixing involved in creating and maintaining applications, frameworks, or other software components.", pic: "b3"),
      
          ]

    @State var  index = 0
    var body: some View {
        VStack{
            Image(self.onBoard[self.index].pic).resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            HStack(spacing: 12){
                ForEach(0..<self.onBoard.count, id: \.self){ i in
                    Circle().fill(self.index == i ? Color.gray : Color.black.opacity(0.07))
                        .frame(width: 10, height: 10)
                }
            }.padding(.top, 30)
            Text(self.onBoard[self.index].title).font(.title).fontWeight(.bold).foregroundColor(.black).padding(.top, 35)
            Text(self.onBoard[self.index].detail).foregroundColor(.black).padding(.top).padding(.horizontal, 20)
            
            Spacer(minLength: 0)
            
            Button(action: {
                if self.index < self.onBoard.count - 1{
                    self.index+=1
                }
                else{
                    GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                    
                    GIDSignIn.sharedInstance()?.signIn()
                }
            }) {
                HStack(spacing: 30){
                    if self.index == self.onBoard.count - 1{
                        Image("google").resizable().renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                    }
                    
                    Text(self.index == self.onBoard.count - 1 ? "Login" : "Next")
                        .foregroundColor(.white).fontWeight(.bold)
                }.padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 200).background(Color.red).clipShape(Capsule())
            }
            
        }.edgesIgnoringSafeArea(.top)
    }
}

struct Home : View {
    @State var progressValue: Float = 0.0
    var body: some View {
        VStack{
                ZStack{
                    Color.yellow.opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack{
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 150.0, height: 150.0)
                                .padding(40.0)
                            
                            let formatted = String(format: "%.2f", progressValue)
                            Text("\(formatted)% Completed")
                        }
                        Spacer()
                    }
                }
        }
//            Text("Logged in As  \n\(Auth.auth().currentUser!.email ?? "No email")").multilineTextAlignment(.center)
//            Text("Start Dashboard View Setup")
    }
}

struct Board {
    var title : String
    var detail : String
    var pic : String
}
