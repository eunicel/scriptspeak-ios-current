//
//  ViewController.swift
//  IOS8SwiftPrototypeCellsTutorial
//
//  Created by Arthur Knopper on 10/08/14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UITableViewController {
    @IBOutlet weak var footerView: UIView!
  
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textToPlayField: UITextField!
    
    @IBAction func playText(sender: UIButton) {
        let text = textToPlayField.text
        var synthesizer = AVSpeechSynthesizer()
        var mySpeechUtterance = AVSpeechUtterance(string:text)
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
        synthesizer.speakUtterance(mySpeechUtterance)
        historyPhrases.append(text)
        tableView.reloadData()
    }
  var historyPhrases = ["Hi, my name is Barbara!","Good morning","Good-bye!","I'm hungry.","Good afternoon.","Happy birthday","Yes","No","PPAT is cool","Caravan","asdf","asdfasdf","asdfasdfasdf"]
                            

    @IBOutlet var tapDictationItem: UITapGestureRecognizer!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.frame = self.view.frame;
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return historyPhrases.count
  }
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return footerView.frame.size.height;
  }
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footerView
  }
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let text = historyPhrases[indexPath.row]
    var synthesizer = AVSpeechSynthesizer()
    var mySpeechUtterance = AVSpeechUtterance(string:text)
    mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    synthesizer.speakUtterance(mySpeechUtterance)
  }
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as? UITableViewCell
    
    cell?.textLabel.text = historyPhrases[indexPath.row]
    
    var imageName = UIImage(named: historyPhrases[indexPath.row])
    cell?.imageView.image = imageName
    
    return cell!
  }

  

  
}
