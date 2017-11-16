//
//  Scroll View Helper
// ___PROJECTNAME___

import UIKit

class ScrollViewHelper {
    
    var keyboardWillAppearAction: (KeyboardNotification) -> () = { _ in }
    var keyboardWillHideAction: (KeyboardNotification) -> () = { _ in }
    
    private(set) weak var view : UIView?
    private(set) weak var scrollView : UIScrollView?
    private(set) var keyboardIsVisible = false
    private(set) var isTablet: Bool
    
    required init(view : UIView, scrollView: UIScrollView, isTablet: Bool) {
        self.view = view
        self.scrollView = scrollView
        self.isTablet = isTablet
    }
    
    func viewWillAppear() {
        guard !isTablet else {
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Notifications
    
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        keyboardIsVisible = true
        
        guard let keybNotification = try? KeyboardNotification(notification: notification),
            let scrollView = scrollView,
            let view = view else {
                return
        }
        
        keyboardWillAppearAction(keybNotification)
        
        let overlapHeight = scrollView.frame.maxY - keybNotification.convertedKeyboardEndFrame(view: view).minY
        scrollView.contentInset.bottom = overlapHeight
        scrollView.scrollIndicatorInsets.bottom = overlapHeight
    }
    
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        keyboardIsVisible = false
        
        scrollView?.contentInset.bottom = 0
        scrollView?.scrollIndicatorInsets.bottom = 0
        
        if let keybNotification = try? KeyboardNotification(notification: notification) {
            keyboardWillHideAction(keybNotification)
        }
    }
}

enum KeyboardNotificationError : Error {
    case InfoDictionaryMissing
    case animationDurationMissing
    case keyboardEndFrameMissing
}

struct KeyboardNotification {
    let animationDuration : Double
    let keyboardEndFrame : CGRect
    let rawAnimationCurve : UInt32
    let animationCurve : UIViewAnimationOptions
    
    init(notification: NSNotification) throws {
        
        guard let userInfo = notification.userInfo else {
            throw KeyboardNotificationError.InfoDictionaryMissing
        }
        
        guard let keyboardEndFrameVal = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            throw KeyboardNotificationError.keyboardEndFrameMissing
        }
        guard let animationDurationVal = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            throw KeyboardNotificationError.animationDurationMissing
            
        }
        guard let rawAnimationCurveVal = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            throw KeyboardNotificationError.animationDurationMissing
        }
        
        keyboardEndFrame = keyboardEndFrameVal.cgRectValue
        animationDuration = animationDurationVal.doubleValue
        rawAnimationCurve = rawAnimationCurveVal.uint32Value << 16
        animationCurve = UIViewAnimationOptions.init(rawValue: UInt(rawAnimationCurve))
    }
    
    func convertedKeyboardEndFrame(view: UIView) -> CGRect {
        return view.convert(keyboardEndFrame, from: view.window)
    }
}

