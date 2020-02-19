//
//  Join.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI

struct Join: View {
    @ObservedObject var eventsController = EventsModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if self.eventsController.events.count > 0 {
                    List {
                        GeometryReader { g -> Text in
                            
                            let frame = g.frame(in: CoordinateSpace.global)
                            
                            if frame.origin.y > 250 {
                                self.eventsController.fetchEvents()
                                return Text("Loading...")
                            }
                            
                            return Text("")
                        }
                        
                        ForEach(self.eventsController.events, id: \.id) { event in
                            NavigationLink(destination: EventDetails(eventsController: self.eventsController, event: event)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3.0) {
                                        Text(event.name).font(.headline)
                                        Text(event.description).font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(event.event_date.dayMonth) - \(event.event_date.isoToTimeString)").font(.headline)
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Events")
                } else {
                    Text("No events to show")
                        .font(.headline)
                        .navigationBarTitle("Events")
                }
            }
        }
        .onAppear(perform: {
            self.eventsController.fetchEvents()
        })
    }
}

struct Join_Previews: PreviewProvider {
    static var previews: some View {
        Join()
    }
}
