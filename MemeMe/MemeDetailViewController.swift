//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Florin Tudose on 17.03.15.
//  Copyright (c) 2015 FLO Media. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memeDetailImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        memeDetailImage.image = meme.memedImage
        memeDetailImage.contentMode = UIViewContentMode.ScaleAspectFit
    }
}
