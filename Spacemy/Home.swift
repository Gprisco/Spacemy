//
//  Home.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            Join()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Events")
                    }
            }
            .tag(0)
            
            Host()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "pencil")
                        Text("Create")
                    }
            }
            .tag(1)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
