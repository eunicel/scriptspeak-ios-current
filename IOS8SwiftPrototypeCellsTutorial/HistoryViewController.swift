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

    
    var historyPhrases :[NSString] = ["Hi, my name is Barbara!","Good morning","Good-bye!","I'm hungry.","Good afternoon.","Happy birthday","Yes","No","PPAT is cool","Caravan","asdf","asdfasdf","asdfasdfasdf"]

    @IBOutlet weak var textToPlayField: UITextField!
    @IBOutlet var tapDictationItem: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = self.view.frame;
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        //read
        if let array : AnyObject? = defaults.objectForKey("historyDictations") {
            println(array);
            if(array != nil){
                historyPhrases = array! as [NSString];
            }
        }
    }
    
    @IBAction func playText(sender: AnyObject) {
        println("happy")
        let text = textToPlayField.text
        if(text != ""){
            var synthesizer = AVSpeechSynthesizer()
            var mySpeechUtterance = AVSpeechUtterance(string:text)
            mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
            synthesizer.speakUtterance(mySpeechUtterance)
            historyPhrases.append(text)
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(historyPhrases, forKey: "historyDictations")
            println("happy")
            defaults.synchronize()
            
            tableView.reloadData()
            textToPlayField.text = ""
        }
    }
    
 /*
    //would be hooked up to the labels on the screen
    @IBAction func playTextFromList(sender: AnyObject) {
        //bascially we just shouldnt be adding to the favorites list every time we play text form the favorites list...it makes no sense
        let text = UILabel.text //wherever the text from the label is coming from......
        var synthesizer = AVSpeechSynthesizer()
        
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
        synthesizer.speakUtterance(mySpeechUtterance)
    }
*/
    
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
    println(indexPath.row);
    var synthesizer = AVSpeechSynthesizer()
    
    var mySpeechUtterance = AVSpeechUtterance(string:text)
    println(text);
    println(historyPhrases);
    mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    synthesizer.speakUtterance(mySpeechUtterance)
  }
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as UITableViewCell;
    var cellLabel:UILabel = cell.viewWithTag(50) as UILabel;
    cellLabel.text = historyPhrases[indexPath.row];
    
    
    var deleteButton:UIButton? = self.view.viewWithTag(51) as? UIButton;
    deleteButton?.addTarget(self, action: "deleteItem:", forControlEvents: UIControlEvents.TouchDown);
    
    var favButton:UIButton? = self.view.viewWithTag(52) as? UIButton;
    favButton?.addTarget(self, action: "favItem:", forControlEvents: UIControlEvents.TouchDown);
    favButton?.setImage(UIImage(named:"star-filled.png"), forState: UIControlState.Highlighted); //should change image of star to filled star when pressed
    
    }
    return cell
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
        println("delete");
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
    
    //somehow the data changes arent being passed in.....idk why but defaults.synchronize is like not working or something?
    //what happens if someone clicks the fave button twice? how do we make sure the item doesn't get added to the favorites list a second time?
    func favItem(sender: AnyObject){
        print (sender) //is it the button that's getting sent in? or not.....
        var buttonPosition:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView);
        println("favorite");
        var indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition);
        if (indexPath != nil)
        {
            var currentIndex = indexPath?.row;
            println( currentIndex);
            
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(historyPhrases, forKey: "historyDictations")
            print(defaults)
            
            if let array : AnyObject? = defaults.objectForKey("favoriteDictations") as? [NSString]{
                println(array);
                if(array != nil){
                    var favorites :[NSString] = array! as [NSString]
                    println(favorites)
                    favorites.append(historyPhrases[currentIndex!])
                    println(favorites)
                    defaults.setObject(favorites, forKey: "favoriteDictations")
                    defaults.synchronize()
                    println("hello")
                    println(defaults.objectForKey("favoriteDictations"))
                }else{ //will never get here...empty array still goes above
                    defaults.setObject([historyPhrases[currentIndex!]], forKey: "favoriteDictations")
                    defaults.synchronize()

                }
            }
            tableView.reloadData()
        }
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


*/


}
