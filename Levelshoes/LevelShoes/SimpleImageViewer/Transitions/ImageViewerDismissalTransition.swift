import UIKit

final class ImageViewerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    
    fileprivate let fromImageView: UIImageView
    fileprivate var toImageView: UIImageView
    
    fileprivate var animatableImageview = AnimatableImageView()
    fileprivate var fromView: UIView?
    fileprivate var fadeView = UIView()
    
    enum TransitionState {
        case start
        case end
    }
    
    fileprivate var translationTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    fileprivate var scaleTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    init(fromImageView: UIImageView, toImageView: UIImageView) {
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        super.init()
    }
    
    func update(transform: CGAffineTransform) {
        translationTransform = transform
    }
    
    func update(percentage: CGFloat) {
        var invertedPercentage = 1.0 - percentage
        if invertedPercentage > 1 {
            invertedPercentage = min(invertedPercentage, 4)
        }
        
        fadeView.alpha = 1
        scaleTransform = CGAffineTransform(scaleX: invertedPercentage, y: invertedPercentage)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        start(transitionContext)
        finish()
    }

    func start(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let containerView = transitionContext.containerView
        let fromSuperView = fromImageView.superview!
        let image = fromImageView.image ?? toImageView.image
        
        animatableImageview.image = image
        animatableImageview.frame = fromSuperView.convert(fromImageView.frame, to: nil)
        animatableImageview.contentMode = .scaleAspectFit
        
        fromView?.isHidden = true
        fadeView.frame = containerView.bounds
        fadeView.backgroundColor = .white
        
        containerView.addSubview(fadeView)
        containerView.addSubview(animatableImageview)
    }
    
    func reset() {
        transitionContext?.cancelInteractiveTransition()
        self.fromView?.isHidden = false
        self.animatableImageview.removeFromSuperview()
        self.fadeView.removeFromSuperview()
        self.transitionContext?.completeTransition(false)
    }
    
    func cancel() {
        transitionContext?.cancelInteractiveTransition()

        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: apply(state: .start),
                       completion: { _ in
                        self.fromView?.isHidden = false
                        self.animatableImageview.removeFromSuperview()
                        self.fadeView.removeFromSuperview()
                        self.transitionContext?.completeTransition(false)
        })
    }
    
    func finish() {
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: apply(state: .end),
                       completion: { _ in
                        self.toImageView.isHidden = false
                        self.fadeView.removeFromSuperview()
                        self.animatableImageview.removeFromSuperview()
                        self.fromView?.removeFromSuperview()
                        self.transitionContext?.completeTransition(true)
        })
    }
}

private extension ImageViewerDismissalTransition {
    func updateTransform() {
        animatableImageview.transform = scaleTransform.concatenating(translationTransform)
    }
    
    func apply(state: TransitionState) -> () -> Void  {
        return {
            switch state {
            case .start:
                self.animatableImageview.contentMode = .scaleAspectFit
                self.animatableImageview.transform = .identity
                self.animatableImageview.frame = self.fromImageView.frame
                self.fadeView.alpha = 1.0
            case .end:
                self.animatableImageview.contentMode = self.toImageView.contentMode
                self.animatableImageview.transform = .identity
                //@@narayan
                   if self.toImageView.superview != nil
                   {
                   self.animatableImageview.frame = self.toImageView.superview!.convert(self.toImageView.frame, to: nil)
                   self.fadeView.alpha = 0.0
                   }
            }
        }
    }
}
