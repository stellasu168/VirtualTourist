//
//  Photos.swift
//  VirtualTourist
//
//  Created by Stella Su on 2/20/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit


@objc(Photos)
class Photos: NSManagedObject {
    
    var image: UIImage? {
        
        if let filePath = filePath {
            
            // Check to see if there's an error downloading the images for each Pin
            if filePath == "error" {
                return UIImage(named: "404.jpg")
            }
            
            // Get the file path
            let fileName = (filePath as NSString).lastPathComponent
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let pathArray = [dirPath, fileName]
            let fileURL = NSURL.fileURL(withPathComponents: pathArray)
            
            return UIImage(contentsOfFile: fileURL!.path)
        }
        return nil
        
    }

    // MARK: - Init model
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(photoURL: String, pin: Pin, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: context)!
        super.init(entity: entity, insertInto: context)
        self.url = photoURL
        self.pin = pin
        print("init from Photos.swift\(url)")
        
    }
    
    //MARK: - Delete file when deleting a managed object
    
    // Explicitely deletes the underlying files
    override func prepareForDeletion(){
        super.prepareForDeletion()
        
        if filePath != nil{
        // Delete the associated image file when the Photos managed object is deleted.
        let fileName = (filePath! as NSString).lastPathComponent
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pathArray = [dirPath, fileName]
        let fileURL = NSURL.fileURL(withPathComponents: pathArray)!
        
        do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch let error as NSError {
                    print("Error from prepareForDeletion - \(error)")
                }
        } else { print("filepath is empty")}
    }
    

}
