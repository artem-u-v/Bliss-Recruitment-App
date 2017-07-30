//
//  DynamicModal.swift
//

import UIKit

var _privateDynamicModal: DynamicModal?

class DynamicModal: NSObject, UIGestureRecognizerDelegate {
    
    class var shared: DynamicModal{
        if _privateDynamicModal == nil{
            _privateDynamicModal = DynamicModal()
        }
        return _privateDynamicModal!
    }
    
    /* internal properties */
    var backgroundColor: UIColor = UIColor.black {
        didSet {
            self.backgroundView.backgroundColor = backgroundColor.withAlphaComponent(self.backgroundAlpha)
        }
    }
    var backgroundAlpha: CGFloat = 0.7 {
        didSet {
            self.backgroundView.backgroundColor = self.backgroundColor.withAlphaComponent(backgroundAlpha)
        }
    }
    
    /* private properties */
    fileprivate weak var view: UIView!
    fileprivate var backgroundView: ModalRetainView! = ModalRetainView()
    
    /* internal functions */
    class func show(modalView view: UIView) -> DynamicModal {
        let modal = DynamicModal()
        modal.show(modalView: view)
        
        return modal
    }
    
    func show(modalView view: UIView) {
        let inView = UIApplication.shared.delegate?.window! as UIView!
        self.view = view
        self.backgroundView.modal = self
        
        inView?.addSubview(self.backgroundView)
        
        self.backgroundView.addSubview(view)
        let constraint1 = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
                                             toItem: self.backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
                                             toItem: self.backgroundView, attribute: .centerY, multiplier: 1, constant: 0)
        self.backgroundView.addConstraint(constraint1)
        self.backgroundView.addConstraint(constraint2)
        view.transform = CGAffineTransform.identity.scaledBy(x: 0.00001, y: 0.00001)
        
        self.fadeInBackgroundView(nil)
    }
    
    func isCurrentView(view:UIView) -> Bool {
        if self.view != nil && self.view == view{
            return true
        }
        return false
    }
    
    func close(_ completion: ((Void) -> ())? = nil) {
        _privateDynamicModal = nil
        self.fadeOutBackgroundView { () in
            self.backgroundView.removeFromSuperview()
            self.backgroundView.modal = nil
            self.view = nil
            completion?()
        }
    }
    
    override init() {
        super.init()
        self.backgroundView.frame = UIScreen.main.bounds
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    /* private functions */
    fileprivate func fadeInBackgroundView(_ completion: ((Void) -> ())?) {
        let view = self.backgroundView.subviews.first!
        UIView.animate(withDuration: 0.4, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.backgroundView.backgroundColor = self.backgroundColor.withAlphaComponent(self.backgroundAlpha * 0.0)
            self.backgroundView.backgroundColor = self.backgroundColor.withAlphaComponent(self.backgroundAlpha * 1.0)
            view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }) { (flag) -> Void in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                        }, completion: { (finished) in
                            completion?()
                    })
            })
        }
    }
    
    fileprivate func fadeOutBackgroundView(_ completion: ((Void) -> ())?) {
        let view = self.backgroundView.subviews.first
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            view?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }) { (flag) -> Void in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                view?.transform = CGAffineTransform.identity.scaledBy(x: 0.00001, y: 0.00001)
                self.backgroundView.backgroundColor = self.backgroundColor.withAlphaComponent(self.backgroundAlpha * 1.0)
                self.backgroundView.backgroundColor = self.backgroundColor.withAlphaComponent(self.backgroundAlpha * 0.0)
                }, completion: { (finished) in
                    completion?()
            })
        }
    }
}

private class ModalRetainView: UIView {
    fileprivate var modal: DynamicModal?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.center = self.superview!.center
    }
}
