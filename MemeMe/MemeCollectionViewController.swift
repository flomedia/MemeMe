//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Florin Tudose on 16.03.15.
//  Copyright (c) 2015 FLO Media. All rights reserved.
//

import Foundation

import UIKit


class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.memes = applicationDelegate.memes
        

    }
    
    // MARK: Table View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeMeCollectionViewCell", forIndexPath: indexPath) as MemeMeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        cell.memeImageView?.contentMode = UIViewContentMode.ScaleAspectFill

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 3
    }

    @IBAction func addMeme(sender: UIBarButtonItem) {
        
        let memeMeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMeViewController")! as MemeMeViewController
        
        self.presentViewController(memeMeViewController, animated: true, completion: nil)
    }
}
