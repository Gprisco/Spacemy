//
//  ContentView.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 10/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var authToken: String = UserDefaults().string(forKey: "authToken") ?? ""
    
    var body: some View {
        VStack {
            if authToken != "" {
                Home()
            } else {
                Login(authToken: self.$authToken)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
