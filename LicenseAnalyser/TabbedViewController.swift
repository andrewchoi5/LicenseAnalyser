//
//  TabbedViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-09.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class TabbedViewController: UIViewController {
    
    //@IBOutlet weak var aggregateScore: UILabel!

    @IBOutlet weak var social: UILabel!
    @IBOutlet weak var thirdParty: UILabel!
    @IBOutlet weak var enhanced: UILabel!
    @IBOutlet weak var basic: UILabel!
    var pageIndex: Int = 0
    
    var socialScore = Double()
    var thirdPartyScore = Double()
    var enhancedScore = Double()
    var basicScore = Double()

    //@IBOutlet weak var progress: KDCircularProgress!
    @IBOutlet weak var aggregateScore: UILabel!
    @IBOutlet weak var progress: KDCircularProgress!
    
    @IBAction func tapped(sender: AnyObject) {
        progress.animateFromAngle(-90, toAngle: 360, duration: 2) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
    }
//    @IBAction func tabbed(sender: AnyObject) {
//
//        progress.animateFromAngle(0, toAngle: 180, duration: 5) { completed in
//            if completed {
//                print("animation stopped, completed")
//            } else {
//                print("animation stopped, was interrupted")
//            }
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here on tab")
        progress.progressThickness = 0.25
        progress.trackThickness = 0.25
        
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        
        progress.startAngle = -90
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        
        progress.animateFromAngle(0, toAngle: 180, duration: 5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        
//        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        progress.startAngle = -90
//        progress.progressThickness = 0.2
//        //progress.trackThickness = 0.6
//        progress.clockwise = true
//        progress.gradientRotateSpeed = 2
//        progress.roundedCorners = false
//        progress.glowMode = .Forward
//        progress.glowAmount = 0.9
//        progress.setColors(UIColor.cyanColor() ,UIColor.whiteColor(), UIColor.magentaColor(), UIColor.whiteColor(), UIColor.orangeColor())
//        progress.center = CGPoint(x: view.center.x, y: view.center.y + 25)
//        view.addSubview(progress)
        print("hello")
//        progress.animateFromAngle(0, toAngle: 180, duration: 1000) { completed in
//            if completed {
//                print("animation stopped, completed")
//            } else {
//                print("animation stopped, was interrupted")
//            }
//        }
        
        social.text = String(round(100.0 * GlobalScore.socialScore) / 100.0)
        thirdParty.text = String(round(100.0 * GlobalScore.govtScore) / 100.0)
        enhanced.text = String(round(100.0 * GlobalScore.enhancedScore) / 100.0)
        basic.text = String(round(100.0 * GlobalScore.coreScore) / 100.0)
        
        var aggregateScore = GlobalScore.coreScore + GlobalScore.enhancedScore + GlobalScore.govtScore + GlobalScore.socialScore
        aggregateScore = round(100.0 * aggregateScore) / 100.0
        self.aggregateScore.text = String(aggregateScore)
        
        // Do any additional setup after loading the view.
    }
    
//    @IBAction func sliderDidChangeValue(sender: UISlider) {
//        progress.angle = Double(sender.value)
//    }
    
//    @IBAction func animateButtonTapped(sender: UIButton) {
//        progress.animateFromAngle(0, toAngle: 360, duration: 5) { completed in
//            if completed {
//                print("animation stopped, completed")
//            } else {
//                print("animation stopped, was interrupted")
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        circularProgressView.animateFromAngle(0, toAngle: 360, duration: 30) { completed in
//            if completed {
//                print("animation stopped, completed")
//            } else {
//                print("animation stopped, was interrupted")
//            }
//        }
//        
//        // Do any additional setup after loading the view.
//    }

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
