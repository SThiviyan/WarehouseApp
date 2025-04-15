//
//  ChangePasswordView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 13.04.25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var app = App.shared
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    
    @State private var showWrongOldPassword: Bool = false
    @State private var showWrongConfirmPassword: Bool = false

    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                
                Spacer()
                
                Group{
                    SecureField("altes Passwort", text: $oldPassword)
                        .textFieldStyle(.automatic)
                        .padding()
                        .textContentType(.password)
                    
                    SecureField("neues Passwort", text: $newPassword)
                        .textFieldStyle(.automatic)
                        .padding()
                        .textContentType(.newPassword)
                    
                    SecureField("Passwort bestätigen", text: $confirmPassword)
                        .textFieldStyle(.automatic)
                        .padding()
                        .textContentType(.newPassword)
                }
                .background(Color.gray.opacity(0.1))
                .clipShape(.buttonBorder)
                .padding(.leading)
                .padding(.trailing)
                
                
                Text("altes Passwort falsch")
                    .font(.caption)
                    .foregroundStyle(Color.red)
                    .opacity(showWrongOldPassword ? 1 : 0)

                
                Text("neues Passwort nicht gleich der Bestätigung")
                    .font(.caption)
                    .foregroundStyle(Color.red)
                    .opacity(showWrongConfirmPassword ? 1 : 0)

                
                Spacer()
                
                Button(action: {
                    if(newPassword == confirmPassword)
                    {
                        if app.changePassword(oldPassword: oldPassword, newPassword: newPassword)
                        {
                            showWrongOldPassword = false
                            dismiss()
                        }
                        else
                        {
                            showWrongOldPassword = true
                            showWrongConfirmPassword = false
                        }
                    }
                    else
                    {
                        showWrongConfirmPassword = true
                        showWrongOldPassword = false
                    }
                }, label: {
                    Text("Bestätigen")
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .buttonStyle(.borderless)
                        .tint(Color.white)
                        .clipShape(.buttonBorder)
                        .padding()
                })
            }
            .navigationTitle("Passwort ändern")
            .toolbar
            {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack
                        {
                            Image(systemName: "chevron.left")
                            Text("Zurück")
                        }
                    })
                
                })
            }
        }
    }
}

#Preview {
    ChangePasswordView()
}
