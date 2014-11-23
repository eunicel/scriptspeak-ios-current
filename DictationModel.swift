import Foundation
import AVFoundation

class DictationModel {
    var text: String;
    let timeCreated: NSDate;
    var usageCount: Int;
    var synthesizer:AVSpeechSynthesizer;
    let delim = "||||||||||||";
    var favorited: Bool;
    
    init(storageString:String) {
        let tokens = storageString.componentsSeparatedByString(delim);
        self.synthesizer = AVSpeechSynthesizer();
        self.text = tokens[0];
        self.usageCount = tokens[1].toInt()!;
        var dateFormatter : NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss.sss";
        self.timeCreated = dateFormatter.dateFromString(tokens[2])!;
        
        if(tokens.count >= 4  ){
            self.favorited = tokens[3] == "true";
        } else {
            println("error: not favorited or favorited");
            println(tokens[3]);
            self.favorited = false;
        }
    }
    init(text:String,usageCount:Int) {
        self.synthesizer = AVSpeechSynthesizer();
        self.text = text;
        self.timeCreated = NSDate();
        self.usageCount = usageCount;
        self.favorited = false;
    }
    convenience init(text:String) {
        self.init(text:text,usageCount:0);
    }
    
    func incrementUsageCount() {
        usageCount++;
    }
    func getFavorite() -> Bool {
        return favorited;
    }
    func favorite() {
        favorited = true;
    }
    func unfavorite() {
        favorited = false;
    }
    func getText() -> String {
        return text;
    }
    func getStorageString() -> String {
        var dateFormatter : NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss.sss";
        //var dateStyle = NSDateFormatterStyle.FullStyle
        //let timeStyle = NSDateFormatterStyle.FullStyle
        
        //dateFormatter.dateStyle = dateStyle
        //dateFormatter.timeStyle = timeStyle
        var dateString :String = dateFormatter.stringFromDate(timeCreated);
        var storageString:String = self.text+self.delim+String(self.usageCount);
        storageString =  storageString+self.delim+dateString+self.delim  ;
        return storageString+(self.favorited ? "true" : "false");
        
    }
    func play(){
        var mySpeechUtterance = AVSpeechUtterance(string:text);
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        synthesizer.speakUtterance(mySpeechUtterance);
    }
    
    
}