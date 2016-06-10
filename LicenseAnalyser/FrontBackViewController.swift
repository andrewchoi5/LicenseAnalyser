//
//  FrontBackViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-10.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class FrontBackViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var container: UIView!
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.addTarget(self, action: "didChangePageControlValue", forControlEvents: .ValueChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tutorialPageViewController = segue.destinationViewController as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    @IBAction func didTapNextButton(sender: UIButton) {
        tutorialPageViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

extension FrontBackViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {

        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        

        pageControl.currentPage = index
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
