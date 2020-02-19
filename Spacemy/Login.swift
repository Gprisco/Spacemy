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
    
    @ObservedObject var authController = AuthController()
    
    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Reg. number").font(.callout)) {
                    TextField("Reg. Number", text: $regNumber)
                }
                .padding(.horizontal)
                
                Section(header: Text("Password").font(.callout)) {
                    SecureField("Password", text: $password)
                }
                .padding(.horizontal)
                
                Button(action: {
                    self.authController.login(regNumber: Int(self.regNumber)!, password: self.password)
                    
                    UserDefaults().set(self.authController.authToken, forKey: "authToken")
                    
                    print(self.authController.authToken)
                }) {
                    Text("Sign In")
                }
                
                Text(self.authController.authToken)
                
                Spacer()
            }
            .navigationBarTitle("Login")
            .padding(.top, 50)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
