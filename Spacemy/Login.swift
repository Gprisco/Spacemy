//
//  Login.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 18/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Login: View {
    @State var regNumber: String = ""
    @State var password: String = ""
    
    @ObservedObject var authController = AuthModel()
    @Binding var authToken: String
    
    @State var register = false
    
    var body: some View {
        NavigationView {
            if !register {
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
                        self.authController.login(regNumber: Int(self.regNumber)!, password: self.password)
                        
                        UserDefaults().set(self.authController.authToken, forKey: "authToken")
                        
                        self.authToken = self.authController.authToken
                    }) {
                        Text("Sign In")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.title)
                            .cornerRadius(10.0)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                        
                        Button(action: {
                            self.register.toggle()
                        }) {
                            Text("Sign up")
                        }
                    }
                    
                    Spacer()
                }
                .navigationBarTitle("Login")
                .padding(.top, 50)
            } else {
                Register(regNumber: self.$regNumber, password: self.$password, authController: self.authController, register: self.$register)
            }
        }
    }
}
