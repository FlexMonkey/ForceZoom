# ForceZoom
Zoom Into Image Details using 3D Touch Peek

![screenshot](/ForceZoom/forceZoom.gif)

Companion project to http://flexmonkey.blogspot.co.uk/2015/10/forcezoom-popup-image-detail-view-using.html

My experiments with 3D Touch on the iPhone 6s continue with _ForceZoom_, an extended `UIImageView` that displays a 1:1 peek detail view of a touched point on a large image.

The demo (above) contains three large images, _forest_ (1600 x 1200), _pharmacy_ (4535 x 1823) and _petronas_ (3264 x 4896). An initial touch on the image displays the preview frame around the touch location and a deep press pops up a square preview of the image at that point at full resolution. The higher the resolution, the smaller the preview frame will be.

##Installation & Implementation

_ForceZoom_ consists of two files that need to be copied into a host application project:

* ForceZoomWidget.swift
* ForceZoomPreview.swift

To implement a _ForceZoom_ component in an application, instantiate with a default image and view controller and add to a view:

```swift
    class ViewController: UIViewController
    {
        var imageView: ForceZoomWidget!
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            imageView = ForceZoomWidget(image: UIImage(named: "forest.jpg")!,
                viewController: self)
            
            view.addSubview(imageView)
        }
    }
    ```

##Displaying Preview Frame

Since the popup preview will be the largest square that can fit on the screen:

```swift
    var peekPreviewSize: CGFloat
    {
        return min(UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height)
    }
    ```

The white preview box, which is a `CAShapeLayer`, needs to be that size at the same scale as the image has been scaled on the screen. The maths to do this is in the `displayPreviewFrame()` method which is invoked by `touchesBegan`:

```swift
    let previewFrameSize = peekPreviewSize * imageScale
```

Where `imageScale` is simply the component's width or height divided by the image's width or height:

```swift
    var imageScale: CGFloat
    {
        return min(bounds.size.width / image!.size.width, bounds.size.height / image!.size.height)

    }
    ```

##Launching the Peek Preview

When `previewingContext(viewControllerForLocation)` is invoked in response to the user's deep press, _ForceZoom_ needs to pass to the previewing component the normalised position of the touch. This is because I use the pop up image view's layer's `contentsRect` to position and clip the full resolution image and `contentsRect` uses normalised image coordinates.

There are a few steps in `previewingContext(viewControllerForLocation)` to do this. First off, I calculate the size of the preview frame as a normalised value. This will be used as an offset from the touch origin to form the clip rectangle's origin:

```swift
    let offset = ((peekPreviewSize * imageScale) / (imageWidth * imageScale)) / 2
```

Next, I calculate the distance between the edge of the component and the edge of the image it contains:

```swift
    let leftBorder = (bounds.width - (imageWidth * imageScale)) / 2
```

Then, with the location of the touch point and these two new values, I can create the normalised _x_ origin of the clip rectangle:

```swift
    let normalisedXPosition = ((location.x - leftBorder) / (imageWidth * imageScale)) - offset
```

I do the same for _y_ and with those two normalised values create a preview point:

```swift
    let topBorder = (bounds.height - (imageHeight * imageScale)) / 2
    let normalisedYPosition = ((location.y - topBorder) / (imageHeight * imageScale)) - offset

    let normalisedPreviewPoint = CGPoint(x: normalisedXPosition, y: normalisedYPosition)
```

...which is passed to my _ForceZoomPreview_:

```swift
    let peek = ForceZoomPreview(normalisedPreviewPoint: normalisedPreviewPoint, image: image!)
```

##The Peek Preview

The previewing component now has very little work to do. It's passed the normalised origin in its constructor (above), so all it needs to do is use those values to set the `contentsRect` of an image view:

```swift
    imageView.layer.contentsRect = CGRect(
        x: max(min(normalisedPreviewPoint.x, 1), 0),
        y: max(min(normalisedPreviewPoint.y, 1), 0),
        width: view.frame.width / image.size.width,

        height: view.frame.height / image.size.height)
```

##Source Code

As always, the full source code for this project is available in my GitHub repository here. Enjoy!
