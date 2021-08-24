import SwiftUI

struct ContentView: View {
    @ObservedObject var rpcObservable: DiscordRPCObservable = DiscordRPCObservable()
    var body: some View {
        VStack {
            HStack {
                Text("Track")
                    .bold()
                Spacer()
                Text(verbatim: rpcObservable.rpcData.track ?? self.rpcObservable.notPlayingText)
            }
            HStack {
                Text("Artist")
                    .bold()
                Spacer()
                Text(verbatim: rpcObservable.rpcData.artist ?? self.rpcObservable.notPlayingText)
            }
            HStack {
                Text("Album")
                    .bold()
                Spacer()
                Text(verbatim: rpcObservable.rpcData.album ?? self.rpcObservable.unknownAlbumText)
            }
            HStack {
                Button(action: {
                    if self.rpcObservable.isDiscordConnected {
                        self.rpcObservable.disconnectFromDiscord()
                    } else {
                        self.rpcObservable.connectToDiscord()
                    }
                }) {
                    if self.rpcObservable.isDiscordConnected {
                        Text("Disconnect from Discord")
                    } else {
                        Text("Connect to Discord")
                    }
                }.disabled(self.rpcObservable.isChangingConnectionStatus)
                Spacer()
                switch rpcObservable.rpcData.state {
                case .playing:
                    Image(systemName: "play.fill")
                case .paused:
                    Image(systemName: "pause.fill")
                case .stopped:
                    Image(systemName: "stop.fill")
                }
                if !self.rpcObservable.isDiscordConnected {
                    Image(systemName: "wifi.exclamationmark")
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { output in
            self.rpcObservable.disconnectFromDiscord()
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
