//
//  ViewController.swift
//  HelloWorld-jq
//
//  Created by Muya on 7/22/14.
//  Copyright (c) 2014 muya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableData: NSArray = []
    @IBOutlet var appsTableView: UITableView
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor("JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) ->Int{
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "My Test Cell")
        
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
    
    func searchItunesFor(searchTerm: String){
        //itunes api wants multiple terms separated by + symbol, so replace 
        //spaces with + signs
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString("", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        //escape anything that isn't url-friendly
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        var url: NSURL = NSURL(string: urlPath)
        var session = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if error {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err? {
                println("JSON ERROR: \(err!.localizedDescription)")
            }
            var results: NSArray = jsonResult["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.appsTableView.reloadData()
                    })
            })
        task.resume()
    }


}

