//
//  ViewController.swift
//  IOS8SwiftPrototypeCellsTutorial
//
//  Created by Arthur Knopper on 10/08/14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//
import AVFoundation
import UIKit

class FavoriteViewController: UITableViewController {

    @IBOutlet weak var favoriteItem: UITabBarItem!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textToPlayField: UITextField!
    
    @IBOutlet var newWordField: UITextField?
    func wordEntered(alert: UIAlertAction!){
        // store the new file name
//        self.textView2.text = deletedString + " " + self.newWordField.text
    }

    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Enter folder name"
//        self.newWordField = textField
    }
    
    @IBAction func addBarButtonClicked(sender: UIBarButtonItem) {
        // Create the alert controller
        let alertController = UIAlertController(title: "New Folder:",message:"",preferredStyle: UIAlertControllerStyle.Alert)
    
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: fileNameEntered);
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil);
        
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        presentViewController(alertController, animated: true, completion: nil)
    }
    func fileNameEntered(aler:UIAlertAction!){
        
    }
    
    @IBAction func playText(sender: UIButton) {
        let text = textToPlayField.text
        var synthesizer = AVSpeechSynthesizer()
        var mySpeechUtterance = AVSpeechUtterance(string:text)
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
        synthesizer.speakUtterance(mySpeechUtterance)
        favoritePhrases.append(text)
        tableView.reloadData()
    }

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
        return favoritePhrases.count
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerView.frame.size.height; // UITabBarItem height is 30
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let text = favoritePhrases[indexPath.row]
        var synthesizer = AVSpeechSynthesizer()
        var mySpeechUtterance = AVSpeechUtterance(string:text)
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        synthesizer.speakUtterance(mySpeechUtterance)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as? UITableViewCell
        
        cell?.textLabel.text = favoritePhrases[indexPath.row]
        
        var imageName = UIImage(named: favoritePhrases[indexPath.row])
        cell?.imageView.image = imageName
        
        return cell!
    }
    
    
    /*
    
    var historyPhrases = ["Hi, my name is Barbara!","Good morning","Good-bye!","I'm hungry.","Good afternoon.","Happy birthday","Yes","No","PPAT is cool","Caravan","asdf","asdfasdf","asdfasdfasdf"]
    
    var favoritePhrases = ["Hello I'm saved"]
    
    @IBAction func sendInputText(sender: UIButton) {
    let text = textToPlayField.text
    historyPhrases.append(text)
    tableView.reloadData()
    playText(text)
    showInputTextAlert(text)
    }
    
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