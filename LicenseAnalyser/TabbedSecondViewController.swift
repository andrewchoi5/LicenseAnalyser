//
//  TabbedSecondViewController.swift
//  LicenseAnalyser
//
//  Created by Chelsea Thiel-Jones on 2016-06-10.
//  Copyright © 2016 Dylan Trachsel. All rights reserved.
//

import UIKit

class TabbedSecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var pageIndex: Int = 1

    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("2ndview")

        // Do any additional setup after loading the view.
       self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
       self.table.dataSource = self
       self.table.delegate = self
       self.table.tableFooterView = UIView()
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
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserFields.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.table.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = Array(UserFields.keys)[indexPath.row] + " : " + Array(UserFields.values)[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
