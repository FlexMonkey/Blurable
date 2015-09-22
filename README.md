# Blurable
###Apply a Gaussian Blur to any UIView with Swift Protocol Extensions

##### _Work in progress: adds `blur()` and `unBlur()` methods to `UIView` components which applies a Core Image Gaussian blur filter to the contents._

######_Companion project to this blog post: http://flexmonkey.blogspot.co.uk/2015/09/applying-gaussian-blur-to-uiviews-with.html_

Here's a fun little experiment showing the power of Swift's Protocol Extensions to apply a CIGaussianBlur Core Image filter to any UIView with no developer overhead. The code could be extended to apply any Core Image filter such as a half tone screen or colour adjustment.

Blurable is a simple protocol that borrows some of the methods and variables from a UIView:

    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    
    func addSubview(view: UIView)

    func bringSubviewToFront(view: UIView)

...and adds a few of its own:

    func blur(blurRadius blurRadius: CGFloat)
    func unBlur()
    
    var isBlurred: Bool { get }

Obviously, just being a protocol, it doesn't do much on its own. However, by adding an extension, I can introduce default functionality. Furthermore, by extending UIView to implement Blurable, every component from a segmented control to a horizontal slider can be blurred:

    extension UIView: Blurable
    {

    }
    
##The Mechanics of Blurable

Getting a blurred representation of a UIView is pretty simple: I need to begin an image context, use the view's layer's renderInContext method to render into the context and then get a UIImage from the context:

    UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
    
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext();

Once I have the image populated, it's a fairly standard workflow to apply a Gaussian blur to it:

    guard let blur = CIFilter(name: "CIGaussianBlur") else
    {
        return
    }

    blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
    blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
    
    let ciContext  = CIContext(options: nil)
    
    let result = blur.valueForKey(kCIOutputImageKey) as! CIImage!
    
    let boundingRect = CGRect(x: -blurRadius * 4,
        y: -blurRadius * 4,
        width: frame.width + (blurRadius * 8),
        height: frame.height + (blurRadius * 8))
    
    let cgImage = ciContext.createCGImage(result, fromRect: boundingRect)

    let filteredImage = UIImage(CGImage: cgImage)

A blurred image will be larger than its input image, so I need to be explicit about the size I require in createCGImage.

The next step is to add a UIImageView to my view and hide all the other views. I've subclassed UIImageView to BlurOverlay so that when it comes to removing it, I can be sure I'm not removing an existing UIImageView: 

    let blurOverlay = BlurOverlay()
    blurOverlay.frame = boundingRect
    
    blurOverlay.image = filteredImage
    
    subviews.forEach{ $0.hidden = true }
    

    addSubview(blurOverlay)

When it comes to de-blurring, I want to ensure the last subview is one of my BlurOverlay  remove it and unhide the existing views:

    func unBlur()
    {
        if let blurOverlay = subviews.last as? BlurOverlay
        {
            blurOverlay.removeFromSuperview()
            
            subviews.forEach{ $0.hidden = false }
        }

    }

Finally, to see if a UIView is currently blurred, I just need to see if its last subview is a BlurOverlay:

    var isBlurred: Bool
    {
        return subviews.last is BlurOverlay
    }
    
##Blurring a UIView

To blur and de-blur, just invoke blur() and unBlur() on an UIView:

    segmentedControl.unBlur()
    segmentedControl.blur(blurRadius: 2)

##Source Code

As always, the source code for this project is available at my GitHub repository here. Enjoy!
