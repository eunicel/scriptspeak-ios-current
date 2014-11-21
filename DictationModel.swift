import Foundation
import AVFoundation
// 1
class CrowdSpeech {
    
    // 2
    var text: String
    let timeCreated: NSDate
    var usageCount: Int
    var synthesizer:AVSpeechSynthesizer
    
    
    init(text:String,usageCount:Int) {
        self.synthesizer = AVSpeechSynthesizer()
        self.text = text
        self.timeCreated = NSDate()
        self.usageCount = usageCount
    }
    convenience init(text:String) {
        self.init(text:text,usageCount:0)
    }
    
    
    func incrementUsageCount() {
        usageCount++
    }
    
    func getText() -> String {
        return text
    }
    func play(){
        
    }
    
    
}