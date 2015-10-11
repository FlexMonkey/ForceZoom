//
//  ViewController.swift
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

class ViewController: UIViewController
{
    let images = [UIImage(named: "forest.jpg")!, UIImage(named: "pharmacy.jpg")!, UIImage(named: "petronas.jpg")!]
    let segmentedControl = UISegmentedControl(items: ["Forest", "Pharmacy", "Petronas"])
    
    var imageView: ForceZoomWidget!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
   
        imageView = ForceZoomWidget(image: images.first, viewController: self)
        segmentedControl.selectedSegmentIndex = 0
        
        view.addSubview(imageView)
        view.addSubview(segmentedControl)
        
        segmentedControl.addTarget(self, action: "segmentedControlChangeHandler", forControlEvents: UIControlEvents.ValueChanged)
    }

    func segmentedControlChangeHandler()
    {
        imageView.image = images[segmentedControl.selectedSegmentIndex]
    }
    
    override func viewDidLayoutSubviews()
    {
        imageView.frame = CGRect(x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length - segmentedControl.intrinsicContentSize().height).insetBy(dx: 10, dy: 10)
        
        segmentedControl.frame = CGRect(x: 0,
            y: view.frame.height - segmentedControl.intrinsicContentSize().height,
            width: view.frame.width,
            height: segmentedControl.intrinsicContentSize().height)
    }

}

