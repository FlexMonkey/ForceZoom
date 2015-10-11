//
//  ForceZoomWidget.swift
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

class ForceZoomWidget: UIImageView
{
    let previewFrameLayer = CAShapeLayer()
   
    required init(image: UIImage?, viewController: UIViewController)
    {
        super.init(image: image)
        
        contentMode = UIViewContentMode.ScaleAspectFit
        
        previewFrameLayer.strokeColor = UIColor.whiteColor().CGColor
        previewFrameLayer.lineWidth = 4
        previewFrameLayer.fillColor = nil
        
        previewFrameLayer.shadowColor = UIColor.blackColor().CGColor
        previewFrameLayer.shadowOffset = CGSize(width: 0, height: 0)
        previewFrameLayer.shadowRadius = 5
        previewFrameLayer.shadowOpacity = 0.75
        
        layer.addSublayer(previewFrameLayer)
        
        userInteractionEnabled = true
        
        viewController.registerForPreviewingWithDelegate(self, sourceView: self)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        
        guard let location = touches.first?.locationInView(self) else
        {
            return
        }
        
        displayPreviewFrame(location)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)
        
        previewFrameLayer.path = nil
    }
    
    func displayPreviewFrame(location: CGPoint)
    {
        let previewFrameSize = peekPreviewSize * imageScale
        
        let previewFramePath = UIBezierPath(rect: CGRect(
            origin: CGPoint(x: location.x - previewFrameSize / 2, y: location.y - previewFrameSize / 2),
            size: CGSize(width: previewFrameSize, height: previewFrameSize)))
        
        previewFrameLayer.path = previewFramePath.CGPath
    }
    
    var imageScale: CGFloat
    {
        return min(bounds.size.width / image!.size.width, bounds.size.height / image!.size.height)
    }
    
    var peekPreviewSize: CGFloat
    {
        return min(UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height)
    }
    
    override func layoutSubviews()
    {
    }
}

extension ForceZoomWidget: UIViewControllerPreviewingDelegate
{
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        guard let imageWidth = image?.size.width,
            imageHeight = image?.size.height else
        {
            return nil
        }

        let offset = ((peekPreviewSize * imageScale) / (imageWidth * imageScale)) / 2
        
        let leftBorder = (bounds.width - (imageWidth * imageScale)) / 2
        let normalisedXPosition = ((location.x - leftBorder) / (imageWidth * imageScale)) - offset
        
        let topBorder = (bounds.height - (imageHeight * imageScale)) / 2
        let normalisedYPosition = ((location.y - topBorder) / (imageHeight * imageScale)) - offset
      
        let normalisedPreviewPoint = CGPoint(x: normalisedXPosition, y: normalisedYPosition)
     
        let peek = ForceZoomPreview(normalisedPreviewPoint: normalisedPreviewPoint, image: image!)
        
        peek.preferredContentSize = CGSize(width: peekPreviewSize, height: peekPreviewSize)
        
        previewFrameLayer.path = nil
        
        return peek
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        commitViewController viewControllerToCommit: UIViewController)
    {
        
    }
}
