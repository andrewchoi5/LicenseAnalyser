//
//  ConfidenceLevelViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-09.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class ConfidenceLevelViewController: UIViewController {

    
//    let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        addSubview(self.progressIndicatorView)
//        progressIndicatorView.frame = bounds
//        progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
//    }


    @IBAction func button1(sender: AnyObject) {
        self.performSegueWithIdentifier("loading", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        self.progressIndicatorView.frame = bounds
//        self.progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
