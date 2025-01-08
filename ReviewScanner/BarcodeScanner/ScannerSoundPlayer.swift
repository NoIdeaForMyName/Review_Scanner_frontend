import AVFoundation

let SCANNER_SOUND_FILENAME = "scanner-beep"
let SCANNER_SOUND_EXTENSION = "wav"

class ScannerSoundPlayer {
    private var audioPlayer: AVAudioPlayer?

    func playScannerSound() {
        guard let soundURL = Bundle.main.url(forResource: SCANNER_SOUND_FILENAME, withExtension: SCANNER_SOUND_EXTENSION) else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
