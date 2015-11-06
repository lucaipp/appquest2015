import UIKit
import AVFoundation

class SpeechSynthesizer: NSObject {
    let synthesizer = AVSpeechSynthesizer()
    let languageCode = "de-DE"
    
    override init() {
        super.init()
    }
    
    func speak(text:String, onComplete:()->()) {
        speak(text)
    }
    
    func speak(text:String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        synthesizer.speakUtterance(utterance)
    }
}
