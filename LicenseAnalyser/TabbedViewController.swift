//
//  TabbedViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-09.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class TabbedViewController: UIViewController {

    @IBOutlet weak var social: UILabel!
    @IBOutlet weak var thirdParty: UILabel!
    @IBOutlet weak var enhanced: UILabel!
    @IBOutlet weak var basic: UILabel!
    var pageIndex: Int = 0
    
    
    var socialScore = Double()
    var thirdPartyScore = Double()
    var enhancedScore = Double()
    var basicScore = Double()

    @IBOutlet weak var circularProgressView: KDCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        social.text = String(GlobalScore.socialScore)
        thirdParty.text = String(GlobalScore.govtScore)
        enhanced.text = String(GlobalScore.enhancedScore)
        basic.text = String(GlobalScore.coreScore)
        
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
