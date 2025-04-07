//
//  LoginView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 07.04.25.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

struct LoginView: View {
    @State var emailField: String = ""
    @State var passwordField: String = ""
    
    @Environment(\.colorScheme) var colorScheme

    
    
    @State var authfailed: Bool = false
    @State var registerSheet: Bool = false
    
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Login")
                .font(.title)
                .padding()
            
            Group{
                TextField("Email", text: $emailField)
                    .textFieldStyle(.automatic)
                    .padding()
                SecureField("Passwort", text: $passwordField)
                    .textFieldStyle(.automatic)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .clipShape(.buttonBorder)
            .padding(.leading)
            .padding(.trailing)
         
            
            Text("Email oder Passwort falsch")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.red)
                .opacity(authfailed ? 1 : 0)
            
                
            
            Button(action: {
                
                let success = handleLogin(email: emailField, password: passwordField)
                
                if(!success)
                {
                    print("Login fehlgeschlagen")
                    authfailed = true
                }
                else
                {
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "LoggedIn")
                    defaults.set(false, forKey: "FirstLaunch")
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                        
                        let tabbar = getTabbar()
                        
                        window.rootViewController = tabbar
                        window.makeKeyAndVisible()
                        
                        UIView.transition(with: window, duration: 0.4, options: [.transitionFlipFromRight], animations: {}, completion: {_ in print("tabbar")})
                    }
                }
               
            }, label:{
                Text("Einloggen")
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .buttonStyle(.borderless)
                    .tint(Color.white)
                    .clipShape(.buttonBorder)
                    .padding()
            })
            .padding()
        
            
            Text("oder:")
                .font(.title3)
            
            
            if(self.colorScheme == .light)
            {
                SignInWithAppleView()
                    .signInWithAppleButtonStyle(.black)
            }
            else
            {
                SignInWithAppleView()
                    .signInWithAppleButtonStyle(.white)
            }
            
            GoogleSignInButton(action: {
                handleGSignIn()
            })
            .frame(width: 300, height: 50)
            .buttonStyle(.plain)
            
            Spacer()
            
            Button(action: {
                registerSheet = true
            }, label:{
                Text("Noch keinen Account? Hier Registrieren")
            })
        }
        .sheet(isPresented: $registerSheet, content: {
            Register()
        })
    }
        
}



struct SignInWithAppleView: View{
    var body: some View
    {
        SignInWithAppleButton(
            onRequest: { request in
                
            },
            onCompletion: { result in
            
            }
        )
        .frame(width: 300, height: 50)
      
    }
}




func handleGSignIn()
{
    
}


func handleLogin(email: String, password: String) -> Bool
{
    
    
    
    return true
}

#Preview {
    LoginView(emailField: "", passwordField: "")
}
