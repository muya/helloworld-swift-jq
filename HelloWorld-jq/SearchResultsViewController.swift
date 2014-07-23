//
//  SearchResultsViewController.swift
//  HelloWorld-jq
//
//  Created by Muya on 7/22/14.
//  Copyright (c) 2014 muya. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    var api: APIController = APIController()
    var tableData: NSArray = []
    @IBOutlet var appsTableView: UITableView
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        api.searchItunesFor("JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) ->Int{
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let kCellIdentifier: String = "SearchResultCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.textLabel.text = rowData["trackName"] as String
        
        //grab artworkurl key to get an image for the app's thumbnail
        var urlString:NSString = rowData["artworkUrl60"] as NSString
        var imgURL: NSURL = NSURL(string: urlString)
        
        //Download an NSData representation of the image at the URL
        var imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.imageView.image = UIImage(data: imgData)
        
        //get formatted price string for display in the subtitle
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        cell.detailTextLabel.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        var name: String = rowData["trackName"] as String
        var formattedPrice: String = rowData["formattedPrice"] as String
        
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView.reloadData()
            })
    }
    
    

}

