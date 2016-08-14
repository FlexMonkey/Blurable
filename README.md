# Blurable
###Apply a Gaussian Blur to any UIView with Swift Protocol Extensions

##### _Adds `blur()` and `unBlur()` methods to `UIView` components which applies a Core Image Gaussian blur filter to the contents._

######_Companion project to this blog post: http://flexmonkey.blogspot.co.uk/2015/09/applying-gaussian-blur-to-uiviews-with.html_

![screengrab](/FMBlurable/assets/screenshot.jpg)

Here's a fun little experiment showing the power of Swift's Protocol Extensions to apply a `CIGaussianBlur` Core Image filter to any `UIView` with no developer overhead. Blurable components can be simple labels or buttons or more complex composite components such as `UISegmentedControl`s and they can reside as subviews of other `UIView`s including `UIStackView`s. The code could be extended to apply any Core Image filter such as a half tone screen or colour adjustment.

`Blurable` is a simple protocol that borrows some of the methods and variables from a UIView:

```swift
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    
    func addSubview(view: UIView)

    func bringSubviewToFront(view: UIView)
```

...and adds a few of its own:

```swift
    func blur(blurRadius blurRadius: CGFloat)
    func unBlur()
    
    var isBlurred: Bool { get }
```

Obviously, just being a protocol, it doesn't do much on its own. However, by adding an extension, I can introduce default functionality. Furthermore, by extending `UIView` to implement `Blurable`, every component from a label to a segmented control to a horizontal slider can be blurred:

```swift
    extension UIView: Blurable
    {

    }
```

## Installation

#### Manually
1. Download and drop ```FMBlurable.swift``` in your project.  
2. Congratulations!  

##The Mechanics of Blurable

Getting a blurred representation of a `UIView` is pretty simple: I need to begin an image context, use the view's layer's renderInContext method to render into the context and then get a UIImage from the context:

```swift
    UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
    
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext();
```

Once I have the image populated, it's a fairly standard workflow to apply a Gaussian blur to it:

```swift
    guard let blur = CIFilter(name: "CIGaussianBlur") else
    {
        return
    }

    blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
    blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
    
    let ciContext  = CIContext(options: nil)
    
    let result = blur.valueForKey(kCIOutputImageKey) as! CIImage!
    
    let boundingRect = CGRect(x: 0,
        y: 0,
        width: frame.width,
        height: frame.height)
    
    let cgImage = ciContext.createCGImage(result, fromRect: boundingRect)

    let filteredImage = UIImage(CGImage: cgImage)
```

A blurred image will be larger than its input image, so I need to be explicit about the size I require in `createCGImage`.

The next step is to swap out the blurred component from its superview for a `UIImageView` containing the blurred image. The technique for doing this differs depending on whether the superview is a `UIStackView` and the blurred component is an arranged subview or not. I've already created a constant named `this` that is a non-optional, strongly typed reference to `self` as a `UIView`, so I can go ahead and check its superview and, if it's a `UIStackView` insert the blurred view as an arranged subview:

```swift
    if let superview = superview as? UIStackView,
        index = (superview as UIStackView).arrangedSubviews.indexOf(this)
    {
        removeFromSuperview()
        superview.insertArrangedSubview(blurOverlay, atIndex: index)
    }
```

However, if the blurred component isn't an arranged subview, we can use a nice animation to cross fade between the original and the blurred view:

```swift
    else
    {
        blurOverlay.frame.origin = frame.origin

        UIView.transitionFromView(this,
            toView: blurOverlay,
            duration: 0.2,
            options: UIViewAnimationOptions.CurveEaseIn,
            completion: nil)
    }
```

Finally, we need to create a reference between the original blurred component and its blur overlay. Since protocol extensions don't allow for stored properties, I use `objc_setAssociatedObject` to effectively add a `blurOverlay` property to the component:

```swift
    objc_setAssociatedObject(this,
        &BlurableKey.blurable,
        blurOverlay,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
```

When it comes to unblurring in `unBlur()`, it's essentally the same process but in reverse. First I create the same `this` constant and ensure the component has an associated blur overlay:

```swift
    guard let this = self as? UIView,
        blurOverlay = objc_getAssociatedObject(self as? UIView, &BlurableKey.blurable) as? BlurOverlay else
    {
        return
    }
```

Then do the same checks to see if `blurOverlay`'s superview is a `UIStackView` and either insert `self` as an arranged subview if it is or do the same `transitionFromView` animation as above, but backwards, if it isn't:

```swift
    if let superview = blurOverlay.superview as? UIStackView,
        index = (blurOverlay.superview as! UIStackView).arrangedSubviews.indexOf(blurOverlay)
    {
        blurOverlay.removeFromSuperview()
        superview.insertArrangedSubview(this, atIndex: index)
    }
    else
    {
        this.frame.origin = blurOverlay.frame.origin

        UIView.transitionFromView(blurOverlay,
            toView: this,
            duration: 0.2,
            options: UIViewAnimationOptions.CurveEaseIn,
            completion: nil)
    }
```

The last step of `unBlur()` is to remove the association between the original blurred component and its blur overlay:

```swift
    objc_setAssociatedObject(this,
        &BlurableKey.blurable,
        nil,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
```

Finally, to see if a `UIView` is currently blurred, I created `isBlurred()` which just needs to check if it has an associated blur overlay:

```swift
    var isBlurred: Bool
    {
        return objc_getAssociatedObject(self as? UIView, &BlurableKey.blurable) is BlurOverlay
    }
```    
    
##Blurring a UIView

To blur and de-blur, just invoke `blur()` and `unBlur()` on an UIView:

```swift
    segmentedControl.unBlur()
    segmentedControl.blur(blurRadius: 2)
```

##Source Code

As always, the source code for this project is available at my GitHub repository here. Enjoy!
