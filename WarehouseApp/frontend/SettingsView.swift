//
//  SettingsView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 26.03.25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack
        {
            Form
            {
                Section
                {
                    Button(action: {print("pressed")})
                    {
                        HStack{
                            
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text("email")
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                        .padding()
                    }
                }
                Section
                {
                    Text("change password")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
