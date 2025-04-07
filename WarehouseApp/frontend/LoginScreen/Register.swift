//
//  register.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 07.04.25.
//

import SwiftUI
import GoogleSignInSwift

struct Register: View {
    @State var emailField: String = ""
    @State var passwordField: String = ""
    
    @Environment(\.colorScheme) var colorScheme

    
    
    @State var authfailed: Bool = false
    
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Registrierung")
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
         
            
            Text("Email bereits registriert")
                .font(.subheadline)
                .bold()
                .foregroundStyle(.red)
                .opacity(authfailed ? 1 : 0)
            
                
            
            Button(action: {
                
                let success = handleSignUp(email: emailField, password: passwordField)
                
                if(!success)
                {
                    print("Email bereits registriert")
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
                        
                        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: {}, completion: {_ in print("Main App activated")})
                    }
                }
               
            }, label:{
                Text("Registrieren")
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
            
           
        }
       
    }
        
}



func handleSignUp(email: String, password: String) -> Bool
{
    return true
}

#Preview {
    Register()
}
