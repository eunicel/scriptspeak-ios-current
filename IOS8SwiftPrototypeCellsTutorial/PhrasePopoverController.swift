//
//  PhrasePopoverController.swift
//  IOS8SwiftPrototypeCellsTutorial
//
//  Created by uid on 11/23/14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

import AVFoundation
import UIKit

class PhrasePopoverController: UIViewController {
    @IBOutlet var playButton: UIButton!
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var myLabel: UILabel!
    var phraseText: String!

    override func viewDidLoad() {
        println("loadingggg")
        super.viewDidLoad()
        myLabel.text = phraseText

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playText(sender: AnyObject) {
        let text = myLabel.text
        var synthesizer = AVSpeechSynthesizer();
        var mySpeechUtterance = AVSpeechUtterance(string:text);
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        synthesizer.speakUtterance(mySpeechUtterance)
    }
    @IBAction func dismissModal(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
