//
//  SessionDetailView.swift
//  LetSwift Data Manager
//
//  Created by BumMo Koo on 2019/08/05.
//  Copyright © 2019 Cleanios. All rights reserved.
//

import SwiftUI

struct SessionDetailView: View {
    @State private var presentNewVideo = false
    
    @ObservedObject var session: Session
    
    // MARK: - Body
    var body: some View {
        Form {
            Section() {
                TextField("Title", text: $session.title)
                Picker("Speaker", selection: $session.speaker) {
                    List {
                        ForEach(DataStore.shared.participants) { participant in
                            Text(participant.profile.preferredName)
                            .tag(participant)
                        }
                    }
                }
                Picker("Track", selection: $session.track) {
                    ForEach(Session.Track.allCases) { track in
                        Text(track.localizedName)
                        .tag(track)
                    }
                }
                TextField("Location", text: $session.location)
                DatePicker(selection: $session.timespan.start, displayedComponents: [.hourAndMinute]) {
                    Text("Start Time")
                }
                DatePicker(selection: $session.timespan.end, displayedComponents: [.hourAndMinute]) {
                    Text("End Time")
                }
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $session.description)
            }
            Section(header: Text("Video")) {
                if session.video == nil {
                    Button(action: newVideo) {
                        Text("Add Video...")
                    }
                } else {
                    Text(session.video!.url.absoluteString)
                    Text("\(session.video!.length)")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(session.title)
    }
    
    private func newVideo() {
        presentNewVideo.toggle()
    }
}

#if DEBUG
struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let placeholderProfile = Profile(familyName: "Appleseed",
                                         givenName: "John")
        let placeholderParticipant = Participant(profile: placeholderProfile,
                                      role: .unspecified,
                                      description: "",
                                      imageUrlString: "",
                                      socialAccounts: [])
        let session = Session(title: "",
                               description: "",
                               speaker: placeholderParticipant,
                               location: "",
                               timespan: DateInterval(),
                               track: .unspecified,
                               video: nil)
        return SessionDetailView(session: session)
    }
}
#endif
