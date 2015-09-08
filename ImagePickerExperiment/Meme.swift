//
//  Meme.swift
//  ImagePickerExperiment
//
//  Created by Vinicius Brito on 9/7/15.
//  Copyright (c) 2015 Vinicius. All rights reserved.
//

import Foundation
import UIKit

class Meme
{    
    var text : String!
    var image: UIImage!
    var memedImage : UIImage!
    
    init(text:String, image: UIImage, memedImage: UIImage)
    {
        self.text = text
        self.image = image
        self.memedImage = memedImage
    }
}
