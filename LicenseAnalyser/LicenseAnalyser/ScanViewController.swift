//
//  ScanViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-15.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    @IBAction func scanBack(sender: UIButton) {
    }
    @IBAction func scanFront(sender: UIButton) {
    }
    @IBOutlet weak var driversLicense: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
