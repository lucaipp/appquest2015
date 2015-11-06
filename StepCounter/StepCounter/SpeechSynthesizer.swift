import UIKit
import AVFoundation

class SpeechSynthesizer: NSObject {
    let languageCode = "de-DE"
    
    override init() {
        super.init()
        // TODO: AVSpeechSynthesizer aufsetzen
    }
    
    func speak(text:String, onComplete:()->()) {
        // TODO: gebe den Text aus und rufe den onComplete-Callback auf
    }
}
