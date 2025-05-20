import UIKit

protocol ImageCropperDelegate {
    func didCropImage(originalImage: UIImage, cropImage: UIImage)
    func didCancel()
}

class ImageCropper: UIViewController , UIScrollViewDelegate {
    
    static var storyboardInstance: ImageCropper {
        return StoryBoard.imageCropper.instantiateViewController(withIdentifier: identifier) as! ImageCropper
    }
    
    @IBOutlet var cropContainer: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageViewWidth: NSLayoutConstraint!
    @IBOutlet var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    
    var image : UIImage?
    var cropWidth = UIScreen.main.bounds.width
    var cropHeight = UIScreen.main.bounds.width
    
    var delegate : ImageCropperDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.layer.borderColor = UIColor.white.cgColor
        self.scrollView.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cropSize = self.setCropAspectRect(cropSize: CGSize(width: cropWidth, height: cropHeight), maxSize: self.cropContainer.bounds.size, image: self.image!)
        self.scrollViewWidth.constant = cropSize.width
        self.scrollViewHeight.constant = cropSize.height
        self.scrollView.frame.size.width = cropSize.width
        self.scrollView.frame.size.height = cropSize.height
        
        setImageToCrop(image: self.image!)
    }

    @IBAction func backAction(_ sender: Any) {
        if(delegate != nil) {
            delegate?.didCancel()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cropDone(_ sender: Any) {
        let scale:CGFloat = 1/scrollView.zoomScale
        let x:CGFloat = scrollView.contentOffset.x * scale
        let y:CGFloat = scrollView.contentOffset.y * scale
        let width:CGFloat = scrollView.frame.size.width * scale
        let height:CGFloat = scrollView.frame.size.height * scale
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        if(delegate != nil) {
            delegate?.didCropImage(originalImage: imageView.image!, cropImage: croppedImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func setImageToCrop(image:UIImage){
        imageView.image = image
        imageViewWidth.constant = image.size.width
        imageViewHeight.constant = image.size.height
        let scaleHeight = scrollView.frame.size.width/image.size.width
        let scaleWidth = scrollView.frame.size.height/image.size.height
        scrollView.minimumZoomScale = max(scaleWidth, scaleHeight)
        scrollView.zoomScale = max(scaleWidth, scaleHeight)
    }
    
    func setCropAspectRect(cropSize: CGSize, maxSize: CGSize, image: UIImage) -> CGSize {
        let aspectRatioWidth = cropSize.width
        let aspectRatioHeight = cropSize.height
        
        var size = maxSize
        let mW = size.width / aspectRatioWidth
        let mH = size.height / aspectRatioHeight
        
        if (mH < mW) {
            size.width = size.height / aspectRatioHeight * aspectRatioWidth
        }
        else if(mW < mH) {
            size.height = size.width / aspectRatioWidth * aspectRatioHeight
        }
        
        //image small size is less than screen size
        var newRatio : CGFloat = 1.0
        if(image.size.width < size.width) {
            newRatio = image.size.width / size.width
        } else if(image.size.height < size.height) {
            newRatio = image.size.height / size.height
        }
        
        size.width = size.width * newRatio
        size.height = size.height * newRatio
        
        return size
    }

}
