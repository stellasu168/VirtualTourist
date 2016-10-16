//
//  ImageScrollView.swift
//  VirtualTourist
//
//  Created by Stella Su on 3/13/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

class ImageScrollView: UIViewController {


    @IBOutlet weak var myImageView: UIImageView!
    
    var selectedImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedImage)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
        
        // ToDo: I should probably list the title of the image
        let imageUrl = URL(string:self.selectedImage)
        let imageData = try? Data(contentsOf: imageUrl!)
        if (imageData != nil)
        {
            self.myImageView.image  = UIImage(data: imageData!)
        }
        
    }
    
    
    
 }
