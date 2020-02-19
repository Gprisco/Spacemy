//
//  ContentView.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 10/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    let userDefaults = UserDefaults()

    var body: some View {
        TabView(selection: $selection) {
            Text("First View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
                    }
                }
                .tag(1)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
