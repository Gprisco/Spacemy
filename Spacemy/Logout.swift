//
//  Logout.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Logout: View {
    @ObservedObject var authModel = AuthModel()
    
    var body: some View {
        Button(action: {
            self.authModel.logout()
            
            UserDefaults().removeObject(forKey: "authToken")
        }) {
            Text("Logout")
        }
    }
}

struct Logout_Previews: PreviewProvider {
    static var previews: some View {
        Logout()
    }
}
