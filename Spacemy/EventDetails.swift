//
//  EventDetails.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import SwiftUI
import UserNotifications

struct EventDetails: View {
    @ObservedObject var eventsController: EventsModel
    let event: Event
        
    var body: some View {
        VStack {
            List {
                VStack {
                    Text("\(event.collab_id)").font(.title)
                    Text(event.description).font(.body)
                    Text("\(event.event_date.dayMonth)")
                }
            }
            
            Button(action: {
                self.eventsController.participate(event_id: self.event.id)
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
                    (granted, error) in
                    if granted {
                        let content = UNMutableNotificationContent()
                        content.title = self.event.name
                        content.body = "The event is starting in 1 hour in collab \(self.event.collab_id)"

                        let trigger = UNCalendarNotificationTrigger(
                            dateMatching: DateComponents(
                                year: Calendar.current.component(.year, from: self.event.event_date),
                                month: Calendar.current.component(.month, from: self.event.event_date),
                                day: Calendar.current.component(.day, from: self.event.event_date),
                                hour: Calendar.current.component(.hour, from: self.event.event_date) - 1),
                            repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "Event\(self.event.id)", content: content, trigger: trigger)

                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    } else {
                        print("No")
                    }
                }
            }) {
                Text("Participate")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title)
                    .cornerRadius(10.0)
            }
            
            Spacer()
        }
        .navigationBarTitle(event.name)
    }
}
