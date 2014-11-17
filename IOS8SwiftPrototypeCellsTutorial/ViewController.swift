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
    var favoritePhrases = ["Favorite phrases", "helloooooo"]

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

  
    /*

var historyPhrases = ["Hi, my name is Barbara!","Good morning","Good-bye!","I'm hungry.","Good afternoon.","Happy birthday","Yes","No","PPAT is cool","Caravan","asdf","asdfasdf","asdfasdfasdf"]

var favoritePhrases = ["Hello I'm saved"]

@IBAction func sendInputText(sender: UIButton) {
let text = textToPlayField.text
if (text != "") { //_____________ADDED CHANGEEEEEEEEE _________
    
    historyPhrases.append(text)
    tableView.reloadData()
    playText(text)
    showInputTextScreen(text)
    }
}
    //http://prateekvjoshi.com/2014/02/16/ios-app-passing-data-between-view-controllers/
    FIRST CONTROLLER 
    import secondController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var secondViewController: SecondViewController = segue.destinationViewController as SecondViewController
        var text = textToPlayField.text
        secondViewController.text = text
    }
    http://ios-blog.co.uk/tutorials/developing-ios8-apps-using-swift-part-6-interaction-with-multiple-views/
    
    
    //make a new screen  on page  -->new viewcontroller (Option-click on a button on one screen and drag over to the other screen and release to create a segue.
    //make a close button on this second screen
    //http://mathewsanders.com/animated-transitions-in-swift/
    //http://mathewsanders.com/custom-menu-transitions-in-swift/#fn:projects
    //control click on button and drag and release to screen exit segue icon

    //method  for the exit segue of this screen:  removes current screen that is on top (so doesn't matter whats below yayy)
    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {
    } //may go in second controller....
    
    
    //SECOND VIEW CONTROLLER
    import UIKit
    need property String text
    @IBOutlet var textLabel: UILabel! ???
    
    class MenuViewController: UIViewController {
    
    // create instance of our custom transition manager
    let transitionManager = MenuTransitionManager()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.transitioningDelegate = self.transitionManager
    
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    
    }
    
    add play button and favorite button!!!!!! (look up code to add buttons)
    add button using object library http://www.raywenderlich.com/77176/learn-to-code-ios-apps-with-swift-tutorial-4
    for play and favorite, close
    add constraints to container, add title
    @IBAction func playButtonPressed() {
        NSLog("PlayButtonPressed")
    }
    
    @IBAction func favoriteButtonPressed() {
        NSLog("favoriteButtonPressed)
    }
    
    @IBAction func closeButtonPressed() {
        NSLog("closeButtonPressed)
    }
    
    
    
    ..may need transition manager class for basic fade out transition


//shows the popup screen featuring the recently input text, that the user can replay or save
func showInputTextAlert(text:String) {
//eventually use the text as the alert!!!
// Create the alert controller
let alertController = UIAlertController(title: "hi", message: "Message", preferredStyle: .Alert)

// Create the actions
let okAction = UIAlertAction(title: "Replay", style: UIAlertActionStyle.Default) {
UIAlertAction in
NSLog("Replay Pressed")
self.playText(text)
}

let favoriteAction = UIAlertAction (title: "Favorite", style: UIAlertActionStyle.Default) {
UIAlertAction in
NSLog("Favorite Pressed")
self.favoritePhrases.append(text)
// tableView.reloadData() //though this should actually be for the favorite phrases page..idk if we want to reload it here

}
let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) {
UIAlertAction in
NSLog("Close Pressed")
}

// Add the actions
alertController.addAction(okAction)
alertController.addAction(cancelAction)
alertController.addAction(favoriteAction)

// Present the controller
presentViewController(alertController, animated: true, completion: nil)
}

//plays the text out loud
func playText(text:String) {
var synthesizer = AVSpeechSynthesizer()
var mySpeechUtterance = AVSpeechUtterance(string:text)
mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
synthesizer.speakUtterance(mySpeechUtterance)
}

//history page favorite text: need to attach a star to each element that when pressed will
//add the data to the starred page

*/


}
