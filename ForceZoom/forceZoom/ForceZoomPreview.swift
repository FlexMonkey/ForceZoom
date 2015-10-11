//
//  ForceZoomPreview.swift
//  ForceZoom
//
//  Created by SIMON_NON_ADMIN on 11/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import UIKit

class ForceZoomPreview: UIViewController
{
    let imageView = UIImageView()
    
    required init(normalisedPreviewPoint: CGPoint, image: UIImage)
    {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.redColor()
        
        view.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.TopLeft
        imageView.frame = view.frame
    
        imageView.layer.contentsRect = CGRect(
            x: max(min(normalisedPreviewPoint.x, 1), 0),
            y: max(min(normalisedPreviewPoint.y, 1), 0),
            width: view.frame.width / image.size.width,
            height: view.frame.height / image.size.height)
        
        imageView.image = image
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
