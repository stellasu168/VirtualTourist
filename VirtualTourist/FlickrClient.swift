//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Stella Su on 2/9/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SystemConfiguration

class FlickrClient: NSObject {

    var numberOfPhotoDownloaded = 0

    // Shared session
    var session: URLSession
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    // MARK: - GET request
    
    func taskForGETMethodWithParameters(_ parameters: [String : AnyObject],
        completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
            
            // Build the URL and configure the request
            let urlString = Constants.BaseURL + FlickrClient.escapedParameters(parameters)
            let request = URLRequest(url: URL(string: urlString)!)
        
        // Make the request
            let task = session.dataTask(with: request, completionHandler: {
                data, response, downloadError in
                
                // Parse the received data
                if let error = downloadError {
                    let newError = FlickrClient.errorForResponse(data, response: response, error: error as NSError)
                    completionHandler(nil, newError)
                } else {
                    FlickrClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
                }
            }) 
 
            // Start the request
            task.resume()
 
    }
    
    // MARK: POST
    func taskForGETMethod(_ urlString: String,
        completionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
            
            // Create the request
            //let request = NSMutableURLRequest(url: URL(string: urlString)!) as URLRequest
        let request = URLRequest(url: URL(string: urlString)!)
        
            // Make the request
        let task = session.dataTask(with: request, completionHandler: {
                data, response, downloadError in
                
                if let error = downloadError {
                    
                    let newError = FlickrClient.errorForResponse(data, response: response, error: error as NSError)
                    completionHandler(nil, newError)
                } else {
                    
                    completionHandler(data, nil)
                }
            }) 
            
            // Start the request
            task.resume()
 
    }
    
    // MARK: - Helpers
    
    // Substitute the key for the value that is contained within the method name
    class func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Given raw JSON, return a usable Foundation object
    class func parseJSONWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsingError: NSError?
        let parsedResult: Any?
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
            print("Parse error - \(parsingError!.localizedDescription)")
            return
        }
        
        if let error = parsingError {
            completionHandler(nil, error)
        } else {
            completionHandler(parsedResult as AnyObject?, nil)
        }
        
    }
    
    
    // Given a dictionary of parameters, convert to a string for a url
    class func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            if(!key.isEmpty) {
                // Make sure that it is a string value
                let stringValue = "\(value)"
                
                // Escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                
                // Append it
                urlVars += [key + "=" + "\(escapedValue!)"]
            }
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
    // Get error for response
    class func errorForResponse(_ data: Data?, response: URLResponse?, error: NSError) -> NSError {
        
        // If network fails, app will crash here.
        if let parsedResult = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String : AnyObject] {
            
            if let status = parsedResult[JSONResponseKeys.Status]  as? String,
                let message = parsedResult[JSONResponseKeys.Message] as? String {
                    
                    if status == JSONResponseValues.Fail {
                        
                        let userInfo = [NSLocalizedDescriptionKey: message]
                        
                        return NSError(domain: "Virtual Tourist Error", code: 1, userInfo: userInfo)
                    }
            }
        }
        return error
    }
    
    // MARK: - Show error alert
    
    func showAlert(_ message: NSError, viewController: AnyObject) {
        let errMessage = message.localizedDescription
        
        let alert = UIAlertController(title: nil, message: errMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openURL(_ urlString: String) {
        let url = URL(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }


}
