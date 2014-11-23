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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "phraseModal"{
            var cell: UITableViewCell = sender as UITableViewCell
            var table: UITableView = cell.superview?.superview as UITableView
            let indexPath = table.indexPathForCell(cell)
            let vc = segue.destinationViewController as PhrasePopoverController
            var dictation = DictationModel(storageString:historyPhrases[indexPath!.row]);
            vc.phraseText = dictation.getText();
        }
        else if segue.identifier == "inputModal" {
            let text = textToPlayField.text
            let vc = segue.destinationViewController as PhrasePopoverController
            vc.phraseText = text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor();

        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = self.view.frame;
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        //read
        if let array : AnyObject? = defaults.objectForKey("historyDictations") {
            if(array != nil){
                historyPhrases = array! as [String];
            }
        }
    }
    
    @IBAction func playText(sender: AnyObject) {
        let text = textToPlayField.text
        if(text != ""){
            var dictation = DictationModel(text:text);
            historyPhrases.insert(dictation.getStorageString(), atIndex: 0);(dictation.getStorageString());
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(historyPhrases, forKey: "historyDictations")
            defaults.synchronize();
            
            tableView.reloadData();
            performSegueWithIdentifier("inputModal", sender: sender)

            textToPlayField.text = "";
        }
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
    var synthesizer = AVSpeechSynthesizer();
    var mySpeechUtterance = AVSpeechUtterance(string:text);
    mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    synthesizer.speakUtterance(mySpeechUtterance)
  }
    
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as UITableViewCell;
    var cellLabel:UILabel = cell.viewWithTag(50) as UILabel;
    
    var dictation = DictationModel(storageString:historyPhrases[indexPath.row]);
    cellLabel.text = dictation.getText();
    var deleteButton:UIButton? = cell.contentView.viewWithTag(51) as? UIButton;
    deleteButton?.addTarget(self, action: "deleteItemClicked:", forControlEvents: UIControlEvents.TouchDown);
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
}
