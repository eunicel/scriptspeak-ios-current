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
    
    var favoritePhrases:[String] = [];

//    @IBOutlet var newWordField: UITextField?
//    func wordEntered(alert: UIAlertAction!){
//        // store the new file name
////        self.textView2.text = deletedString + " " + self.newWordField.text
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("segue")
        if segue.identifier == "phraseModal2" {
            var cell: UITableViewCell = sender as UITableViewCell
            var table: UITableView = cell.superview?.superview as UITableView
            let indexPath = table.indexPathForCell(cell)
            
            let vc = segue.destinationViewController as PhrasePopoverController
            var dictation = DictationModel(storageString:favoritePhrases[indexPath!.row]);
            vc.phraseText = dictation.getText();
        }
        else if segue.identifier == "inputModal2" {
            let text = textToPlayField.text
            let vc = segue.destinationViewController as PhrasePopoverController
            vc.phraseText = text
        }
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
    

    
    func fileNameEntered(alert:UIAlertAction!){
        
    }
    
    //problem: when click play from favorites page but text button, playes, but also adds it to favorite dictations..... should add to history dictactions
    @IBAction func playText(sender: UIButton) {
        let text = textToPlayField.text;
        if(text != ""){
            let dictation = DictationModel(text:text, usageCount:0);
            
            // add played phrase to history
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            var historyPhrases :[String]
            if let array : AnyObject? = defaults.objectForKey("historyDictations") {
                if(array != nil){
                    historyPhrases = array! as [String];
                }
                else {
                    historyPhrases = [dictation.getStorageString()];
                }
                historyPhrases.insert(dictation.getStorageString(), atIndex: 0);
                
                defaults.setObject(historyPhrases, forKey: "historyDictations")
                defaults.synchronize()
                
                tableView.reloadData()
                performSegueWithIdentifier("inputModal2", sender: sender)
                textToPlayField.text = "";
            }
        }
    }
    

    @IBOutlet var tapDictationItem: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = self.view.frame;

        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        //read
        if let array : AnyObject? = defaults.objectForKey("favoriteDictations") as? [String]{
            if(array != nil){
                favoritePhrases = array! as [String];
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePhrases.count;
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerView.frame.size.height;
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("PhrasePopover", sender: self)
        var dictation = DictationModel(storageString: favoritePhrases[indexPath.row]);
        let text = dictation.text;
        dictation.incrementUsageCount();
        favoritePhrases[indexPath.row] = dictation.getStorageString();
        var synthesizer = AVSpeechSynthesizer();
        var mySpeechUtterance = AVSpeechUtterance(string:text);
        mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        synthesizer.speakUtterance(mySpeechUtterance);
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as UITableViewCell;
        var cellLabel:UILabel = cell.viewWithTag(50) as UILabel;
        cellLabel.text = DictationModel(storageString: favoritePhrases[indexPath.row]).getText();
        var deleteButton:UIButton? = cell.contentView.viewWithTag(51) as? UIButton;
        deleteButton?.addTarget(self, action: "deleteItemClicked:", forControlEvents: UIControlEvents.TouchDown);
        return cell;
    }
    
    func deleteItemClicked(sender: AnyObject){ //UIBarBUttonItem
        let alertController = UIAlertController(title: "Delete Item?",message:"",preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction!) in
            self.deleteItem(sender);
        });// DeleteEntered);
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil);
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        // Present the controller
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteItem(sender: AnyObject){
        var buttonPosition:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView);
        var indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition);
        if (indexPath != nil)
        {
            var currentIndex = indexPath?.row;
            favoritePhrases.removeAtIndex(currentIndex!);
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(favoritePhrases, forKey: "favoriteDictations")
            defaults.synchronize()//may not need this one?
            tableView.reloadData()
        }
        //MAKE THE HISTORY ONE UNSTARRRRRRRRRRRR
    }
    
    //code for the favorite button on the text field
    @IBAction func favoriteTextInput(sender: UIButton) {
        sender.setImage(UIImage(named:"star-filled.png"), forState:UIControlState.Highlighted);
        let text = textToPlayField.text;
        
        if (text != "") {
            let dictation = DictationModel(text:text);
            dictation.favorite()
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

            if let array : AnyObject? = defaults.objectForKey("historyDictations") as? [String]{
                var history :[String] = array! as [String];
                
                history.insert(dictation.getStorageString(), atIndex: 0);
                favoritePhrases.insert(dictation.getStorageString(), atIndex: 0);//(dictation.getStorageString());
                defaults.setObject(history, forKey: "historyDictations");
                defaults.setObject(favoritePhrases, forKey: "favoriteDictations")
                defaults.synchronize()

            }
            tableView.reloadData()
            textToPlayField.text = "";
        }
    }
}