//
//  APIController.swift
//  HelloWorld-jq
//
//  Created by Muya on 7/22/14.
//  Copyright (c) 2014 muya. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController: NSObject {
    var delegate: APIControllerProtocol?
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
            //send the json result to delegate object
            self.delegate?.didReceiveAPIResults(jsonResult)
            })
        task.resume()
    }

}
