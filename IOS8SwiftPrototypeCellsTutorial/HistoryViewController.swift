//
//  ViewController.swift
//  IOS8SwiftPrototypeCellsTutorial
//
//  Created by Arthur Knopper on 10/08/14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//
import AVFoundation
import UIKit

class HistoryViewController: UITableViewController {
  
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var historyPhrases :[String] = [];

    @IBOutlet weak var textToPlayField: UITextField!
    @IBOutlet var tapDictationItem: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        println("view did load history");
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = self.view.frame;
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        //read
        if let array : AnyObject? = defaults.objectForKey("historyDictations") {
            if(array != nil){
                historyPhrases = array! as [String];
            }
        }
        println("history view loaded successful");
    }
    
    @IBAction func playText(sender: AnyObject) {
        println("play text start");
        let text = textToPlayField.text
        if(text != ""){
            println(text);
            var dictation = DictationModel(text:text);
            var synthesizer = AVSpeechSynthesizer();
            var mySpeechUtterance = AVSpeechUtterance(string:text);
            mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
            synthesizer.speakUtterance(mySpeechUtterance);
            historyPhrases.insert(dictation.getStorageString(), atIndex: 0);(dictation.getStorageString());
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(historyPhrases, forKey: "historyDictations")
            defaults.synchronize();
            
            tableView.reloadData();
            textToPlayField.text = "";
        }
        println("done playing text");
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return historyPhrases.count;
  }
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return footerView.frame.size.height;
  }
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footerView;
  }
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let dictation = DictationModel(storageString: historyPhrases[indexPath.row])
    dictation.incrementUsageCount();
    historyPhrases[indexPath.row] = dictation.getStorageString();
    let text = dictation.text;
    println(indexPath.row);
    var synthesizer = AVSpeechSynthesizer();
    var mySpeechUtterance = AVSpeechUtterance(string:text);
    mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    synthesizer.speakUtterance(mySpeechUtterance)
  }
    
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    println("history setting cell label start");
    let cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as UITableViewCell;
    var cellLabel:UILabel = cell.viewWithTag(50) as UILabel;
    var dictation = DictationModel(storageString:historyPhrases[indexPath.row]);
    cellLabel.text = dictation.getText();
    var deleteButton:UIButton? = cell.contentView.viewWithTag(51) as? UIButton;
    deleteButton?.addTarget(self, action: "deleteItem:", forControlEvents: UIControlEvents.TouchDown);
    var favButton:UIButton? = cell.contentView.viewWithTag(52) as? UIButton;
    favButton?.addTarget(self, action: "favItem:", forControlEvents: UIControlEvents.TouchDown);
    if(dictation.getFavorite()){
        favButton?.setImage(UIImage(named:"star-filled.png"), forState: UIControlState.Normal);
    } else {
        favButton?.setImage(UIImage(named:"star-empty.png"), forState: UIControlState.Normal);
    }
    return cell;
  }
    
    //to make sure text labels will wrap
    //how to get cell.cellLabel.preferred...cell.cellLabel.frame..... from this method???
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews();
//        
//        self.preferredMaxLayoutWidth = self.frame.size.width;
//        self.view.setNeedsLayout();
//        self.view.layoutSubviews();
//    }
    
    func deleteItem(sender: AnyObject){
        var buttonPosition:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView);
        var indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition);
        if (indexPath != nil)
        {
            var currentIndex = indexPath?.row;
            historyPhrases.removeAtIndex(currentIndex!);
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(historyPhrases, forKey: "historyDictations")
            defaults.synchronize()
            tableView.reloadData()
        }
    }
    
    //what happens if someone clicks the fave button twice? how do we make sure the item doesn't get added to the favorites list a second time?
    func favItem(sender: AnyObject){
        sender.setImage(UIImage(named:"star-filled.png"), forState:UIControlState.Normal); //should change image of star to filled star when pressed
        var buttonPosition:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView);
        var indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition);
        if (indexPath != nil)
        {
            var currentIndex = indexPath?.row;
            let dictation = DictationModel(storageString: historyPhrases[currentIndex!]);
            if (dictation.getFavorite() == false) {
                var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                if let array : AnyObject? = defaults.objectForKey("favoriteDictations") as? [String]{
                    var favorites: [String]
                    if(array != nil){
                        favorites = array! as [String];
                    }
                    else {
                        favorites = [historyPhrases[currentIndex!]];
                    }
                    dictation.favorite()
                    favorites.insert(dictation.getStorageString(), atIndex: 0);
                    defaults.setObject(favorites, forKey: "favoriteDictations");
                    historyPhrases[currentIndex!] = dictation.getStorageString()
                    defaults.setObject(historyPhrases, forKey: "historyDictations");
                    defaults.synchronize();
                }
            }
        }
    }
    
    //saves the text to favorites and clears it from the text field
    @IBAction func favoriteTextInput(sender: AnyObject) {
        sender.setImage(UIImage(named:"star-filled.png"), forState:UIControlState.Normal); //should change image of star to filled star when pressed
        let text = textToPlayField.text
        if(text != ""){
            let dictation = DictationModel(text:text);
            dictation.favorite()
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            //add to fav list
            if let array : AnyObject? = defaults.objectForKey("favoriteDictations") as? [String]{
                var favorites :[String] = array! as [String];
                favorites.insert(dictation.getStorageString(), atIndex: 0);//(dictation.getStorageString());
                historyPhrases.insert(dictation.getStorageString(), atIndex: 0);
                defaults.setObject(favorites, forKey: "favoriteDictations");
                defaults.setObject(historyPhrases, forKey: "historyDictations");
            }
            
            defaults.synchronize();
            
            tableView.reloadData();
            textToPlayField.text = "";
        }
    }

    /*

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


*/


}
