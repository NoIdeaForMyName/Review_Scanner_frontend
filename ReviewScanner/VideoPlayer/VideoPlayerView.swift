import SwiftUI
import AVKit

let VIDEO_FILE_NAME = "" // TO BE ADDED
let VIDEO_FILE_EXTENSION = "" // TO BE ADDED

struct VideoPlayerView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: VIDEO_FILE_NAME, withExtension: VIDEO_FILE_EXTENSION)!))
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                isPresented = false
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                    Text("Back")
                        .font(.system(size: 18))
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .padding(.leading)
                .padding(.top, 40)
            }
        }
    }
}
