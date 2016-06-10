//
//  PageViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-10.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

//import UIKit
//import Foundation
//
//class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
//    let tabbedview1 = TabbedViewController()
//    let tabbedview2 = TabbedSecondViewController()
//    var viewArray: [UIViewController] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewArray = [tabbedview1, tabbedview2]
//        
//        self.dataSource = self
//        
//        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    // MARK:- UIPageViewControllerDataSource Methods
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
//    {
//        let pageContent: TabbedViewController = viewController as! TabbedViewController
//        
//        var index = pageContent.pageIndex
//        
//        if ((index == 0) || (index == NSNotFound))
//        {
//            return nil
//        }
//        
//        index--;
//        return getViewControllerAtIndex(index)
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
//    {
//        let pageContent: TabbedSecondViewController = viewController as! TabbedSecondViewController
//        
//        var index = pageContent.pageIndex
//        
//        if (index == NSNotFound)
//        {
//            return nil;
//        }
//        
//        index++;
////        if (index == arrPageTitle.count)
////        {
////            return nil;
////        }
//        return getViewControllerAtIndex(index)
//    }
//    
//    // MARK:- Other Methods
//    func getViewControllerAtIndex(index: NSInteger) -> TabbedViewController
//    {
//        // Create a new view controller and pass suitable data.
//        let tabbedViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabbedViewController") as! TabbedViewController
//        
////        pageContentViewController.strTitle = "\(arrPageTitle[index])"
////        pageContentViewController.strPhotoName = "\(arrPagePhoto[index])"
//        tabbedViewController.pageIndex = index
//        
//        return tabbedViewController
//    }
//
//}
