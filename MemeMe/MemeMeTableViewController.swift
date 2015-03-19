//
//  MemeMeTableViewController.swift
//  MemeMe
//
//  Created by Florin Tudose on 17.03.15.
//  Copyright (c) 2015 FLO Media. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.memes = applicationDelegate.memes
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
  
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    @IBAction func addNewMeme(sender: UIBarButtonItem) {
        
        let memeMeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMeViewController")! as MemeMeViewController
       
        self.presentViewController(memeMeViewController, animated: true, completion: nil)

    }

}
