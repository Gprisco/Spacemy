//
//  Host.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Host: View {
    @ObservedObject var collabsController = CollabsModel()
    
    @State var title = ""
    @State var description = ""
    @State var date = Date()
    @State var category: Int = 0
    @State var collab: Int = 0
    @State var durationHour: Double = 1.0
    
    let user = decode(jwtToken: UserDefaults().string(forKey: "authToken")!)
    
    var categories: [Category] = [.meetAndShare, .notPrivate, .notPublic]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $title)
                    }
                    
                    Section {
                        TextField("Description", text: $description)
                    }
                    
                    Section {
                        Picker(selection: self.$category, label: Text("Activity Category")) {
                            ForEach(0 ..< self.categories.count) { i in
                                Text(self.categories[i].rawValue).tag(i)
                            }
                        }
                    }
                    
                    Section {
                        DatePicker(selection: self.$date, displayedComponents: .init([.date, .hourAndMinute])) {
                            Text("Date")
                        }
                    }
                    
                    Section {
                        VStack {
                            Text("Duration in Hours: \(Int(self.durationHour))")
                            Slider(value: self.$durationHour, in: 1...4, step: 1.0)
                        }
                    }
                    
                    if !self.collabsController.collabs.isEmpty {
                        Section {
                            Picker(selection: self.$collab, label: Text("Collab")) {
                                ForEach(0 ..< self.collabsController.collabs.count) { i in
                                    Text("\(self.collabsController.collabs[i].id)")
                                }
                            }
                        }
                    }
                }
                
                Button(action: {
                    let event = CreateEvent(category_id: self.category + 1, duration_hour: Int(self.durationHour), name: self.title, creator_id: self.user["id"] as! Int, event_date: self.date, collab_id: self.collabsController.collabs[self.collab].id, description: self.description)
                    
                    print(event)
                                        
                    EventsModel().createEvent(event: event)
                }) {
                    HStack {
                        Spacer()
                        Text("Create")
                            .padding(5)
                        Spacer()
                    }
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10.0)
                .padding()
                .disabled(self.title == "")
            }
            .navigationBarTitle("Create")
            .onAppear(perform: {
                self.collabsController.fetchCollabs(categoryId: self.category + 1, date: self.date, durationHour: Int(self.durationHour))
            })
        }
    }
}

struct Host_Previews: PreviewProvider {
    static var previews: some View {
        Host()
    }
}
