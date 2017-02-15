//
//  helpTutorialVC.swift
//  Baby Beat
//
//  Created by OSX on 31/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit

class helpTutorialVC: UIViewController
{
    var tutorial:String!

    @IBOutlet var mImgVwTutorial: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.clearColor()
        mImgVwTutorial.image=UIImage(named: tutorial)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
    }
}
