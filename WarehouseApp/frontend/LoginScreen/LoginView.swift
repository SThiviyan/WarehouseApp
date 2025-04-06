//
//  LoginView.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 06.04.25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationStack{
            VStack{
                
                HStack{
                    Image(systemName: "")
                    Text("Your Products in one convenient spot.")
                }
                HStack
                {
                    Image(systemName: "")
                    Text("")
                }
                HStack
                {
                    Image(systemName: "")
                    Text("")
                }
                
                Button("continue", action: {
                    
                })
                .frame(width: 300, height: 60)
                .background(Color.blue)
                .clipShape(Capsule())
                .buttonStyle(.borderedProminent)
                .bold()
            }
            .navigationTitle("Welcome to Warehouse")
        }
    }
}

#Preview {
    LoginView()
}
