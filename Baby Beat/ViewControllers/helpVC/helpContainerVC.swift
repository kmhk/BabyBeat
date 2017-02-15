//
//  helpContainerVC.swift
//  Baby Beat
//
//  Created by OSX on 31/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit
import EMPageViewController

class helpContainerVC: UIViewController,  EMPageViewControllerDataSource, EMPageViewControllerDelegate
{
    var pageViewController: EMPageViewController?
    var tutorials = ["tut1","tut2","tut3","tut4","tut5","tut6","tut7","tut8"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instantiate EMPageViewController and set the data source and delegate to 'self'
        let pageViewController = EMPageViewController()
        
        // Or, for a vertical orientation
        // let pageViewController = EMPageViewController(navigationOrientation: .Vertical)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set the initially selected view controller
        // IMPORTANT: If you are using a dataSource, make sure you set it BEFORE calling selectViewController:direction:animated:completion
        let currentViewController = self.viewControllerAtIndex(0)!
        pageViewController.selectViewController(currentViewController, direction: .Forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        self.addChildViewController(pageViewController)
        self.view.insertSubview(pageViewController.view, atIndex: 0) // Insert the page controller view below the navigation buttons
        pageViewController.didMoveToParentViewController(self)
        
        self.pageViewController = pageViewController
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - EMPageViewController Data Source
    
    func em_pageViewController(pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if let viewControllerIndex = self.indexOfViewController(viewController as! helpTutorialVC)
        {
            let beforeViewController = self.viewControllerAtIndex(viewControllerIndex - 1)
            return beforeViewController
        } else
        {
            return nil
        }
    }
    
    func em_pageViewController(pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if let viewControllerIndex = self.indexOfViewController(viewController as! helpTutorialVC)
        {
            let afterViewController = self.viewControllerAtIndex(viewControllerIndex + 1)
            return afterViewController
        } else
        {
            return nil
        }
    }
    
    func viewControllerAtIndex(index: Int) -> helpTutorialVC?
    {
        if (self.tutorials.count == 0) || (index < 0) || (index >= self.tutorials.count)
        {
            return nil
        }
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("helpTutorialVC") as! helpTutorialVC
        viewController.tutorial = self.tutorials[index]
        return viewController
    }
    
    func indexOfViewController(viewController: helpTutorialVC) -> Int?
    {
        if let greeting: String = viewController.tutorial
        {
            return self.tutorials.indexOf(greeting)
        } else
        {
            return nil
        }
    }
    


}
