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
    
    func deleteButtonClicked(sender: UIBarButtonItem) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete Item:",message:"",preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil);// DeleteEntered);
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil);
        
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
            // text-to-speech
            var synthesizer = AVSpeechSynthesizer()
            var mySpeechUtterance = AVSpeechUtterance(string:text)
            mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
            synthesizer.speakUtterance(mySpeechUtterance)
            
            // add played phrase to history
            //favoritePhrases.append(text);
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            var historyPhrases :[NSString] = [];
            //defaults.setObject(favoritePhrases, forKey: "favoriteDictations")
            defaults.setObject(historyPhrases, forKey: "historyDictations")
            historyPhrases.append(text);
            defaults.synchronize()
            
            tableView.reloadData()
            textToPlayField.text = "";
        }
        
    }
    
    //Eventually I want this: so one play button just plays the phrase and adds it to the history list. The other just plays the phrase (like assuming its from the labels)
/* //would be hooked up fo the input text play button
    @IBAction func playTextFromPlayButton(sender: UIButton) {
        let text = textToPlayField.text;
        if(text != ""){
            var synthesizer = AVSpeechSynthesizer()
            var mySpeechUtterance = AVSpeechUtterance(string:text)
            mySpeechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
            synthesizer.speakUtterance(mySpeechUtterance)
            historyPhrases.append(text);
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
            defaults.setObject(historyPhrases, forKey:"historyDictations")
    
            defaults.synchronize()
    
            tableView.reloadData()
            textToPlayField.text = "";
        }
    }
*/
    
    var favoritePhrases:[NSString] = [];

    @IBOutlet var tapDictationItem: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.frame = self.view.frame;
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        //read
        if let array : AnyObject? = defaults.objectForKey("favoriteDictations") as? [NSString]{
            println("array");
            println (array);
            favoritePhrases = array! as [NSString]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePhrases.count
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerView.frame.size.height;
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
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dictationCell") as UITableViewCell;
        println(cell)
        
        var cellLabel:UILabel = cell.viewWithTag(50) as UILabel;
        cellLabel.text = favoritePhrases[indexPath.row];
        
        var deleteButton:UIButton? = self.view.viewWithTag(51) as? UIButton;
        
//        deleteButton?.addTarget(self, action: "deleteItemClicked:", forControlEvents: UIControlEvents.TouchDown);
        deleteButton?.addTarget(self, action: "deleteItem:", forControlEvents: UIControlEvents.TouchDown);
        
        return cell
    }

    func deleteItemClicked(sender: AnyObject){
        let alertController = UIAlertController(title: "Delete Item:",message:"",preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, nil);// DeleteEntered);
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil);
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        presentViewController(alertController, animated: true, completion: nil)
    }
    
//    USE FOR DELETE DIALOG (dont look at this now)s
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        var previouslySelectedCell: UITableViewCell?
//        if checkedIndexPath != nil {
//            previouslySelectedCell = tableView.cellForRowAtIndexPath(checkedIndexPath)
//        }
//        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        let selectedCurrency = PortfolioCurrencyStore.sharedStore().allCurrencies[indexPath.row]
//        
//        if selectedCurrency.symbol != GlobalSettings.sharedStore().portfolioCurrency {
//            
//            // Warning : changing the portfolio currency will reset the portfolio
//            var resetWarning = UIAlertController(title: NSLocalizedString("Currency Picker VC:AS title", comment: "Changing currency will reset portfolio"), message: nil, preferredStyle: .ActionSheet)
//            
//            // destructive button
//            let resetAction = UIAlertAction(title: NSLocalizedString("Currency Picker VC:AS destructive", comment: "Destructive button title"), style: .Destructive, handler: { (action: UIAlertAction!) in
//                
//                // Remove checkmark from the previously marked cell
//                previouslySelectedCell?.accessoryType = .None
//                
//                // Add checkmark to the selected cell
//                selectedCell?.accessoryType = .Checkmark
//                self.checkedIndexPath = indexPath
//                
//                // Animate deselection of cell
//                self.tableView.deselectRowAtIndexPath(indexPath, animated:true)
//                
//                // Stock the portfolio currency as NSUserDefaults
//                GlobalSettings.sharedStore().portfolioCurrency = selectedCurrency.symbol // link between portfolioCurrency as a String and currency.symbol as the property of a Currency instance.
//                
//                // Delete all items from the StockStore
//                StockStore.sharedStore().removeAllStocks()
//                println("StockStore : all entries were deleted")
//                
//                
//                // Reload tableView
//                self.tableView.reloadData()
//                
//            })
//            
//            // cancel button
//            let cancelAction = UIAlertAction(title: NSLocalizedString("Currency Picker VC:AS cancel", comment: "Cancel button title"), style: .Cancel, handler:nil)
//            
//            resetWarning.addAction(resetAction)
//            resetWarning.addAction(cancelAction)
//            
//            presentViewController(resetWarning, animated: true, completion: nil)
//            
//        } else {
//            // Animate deselection of cell
//            tableView.deselectRowAtIndexPath(indexPath, animated:true)
//        }
//    }
//    
//    
//    
//    
//    
//    @interface MyClass : … {
//    NSIndexPath deleteIndexPath;
//    }
//    @end
//    
//    - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//    deleteIndexPath = indexPath;
//    //code for UIAlrtView
//    // …
//    }
//    }
//    
//    - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//    {
//    if(buttonIndex == 0)//OK button pressed
//    {
//    [array removeObjectAtIndex:deleteIndexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    }
    
    func deleteItem(sender: AnyObject){
        var buttonPosition:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView);
        println("delete");
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
    }
    
    //code for the save button on the text field..not tested yet
    @IBAction func favoriteTextInput(sender: UIButton) {
        
        let text = textToPlayField.text;
        if (text != "") {
            favoritePhrases.append(text);
            
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            if let array : AnyObject? = defaults.objectForKey("historyDictations") as? [NSString]{
                println(array);
                var history :[NSString] = array! as [NSString]
                history.append(text)
                defaults.setObject(history, forKey: "historyDictations")
            }
            
            defaults.setObject(favoritePhrases, forKey: "favoriteDictations")
            
            defaults.synchronize()
            tableView.reloadData()
            textToPlayField.text = "";
        }
        //what do we do conceptually about changing to filled star?
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
