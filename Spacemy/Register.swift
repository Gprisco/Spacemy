//
//  Register.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Register: View {
    @Binding var regNumber: String
    @Binding var password: String
    
    @ObservedObject var authController: AuthModel
    
    @Binding var register: Bool
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Reg. Number", text: $regNumber)
                }
                .padding(.horizontal)
                
                Section {
                    SecureField("Password", text: $password)
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                self.authController.register(regNumber: Int(self.regNumber)!, password: self.password)
                
                self.register.toggle()
            }) {
                Text("Sign up")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title)
                    .cornerRadius(10.0)
            }
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                
                Button(action: {
                    self.register.toggle()
                }) {
                    Text("Sign in")
                }
            }
            
            Spacer()
        }
        .navigationBarTitle("Register")
        .padding(.top, 50)
    }
}
