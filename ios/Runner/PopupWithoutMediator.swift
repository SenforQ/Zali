
//: Declare String Begin

/*: "init(coder:) has not been implemented" :*/
fileprivate let userOriginApp:[UInt8] = [0x60,0x67,0x60,0x7d,0x21,0x6a,0x66,0x6d,0x6c,0x7b,0x33,0x20,0x29,0x61,0x68,0x7a,0x29,0x67,0x66,0x7d,0x29,0x6b,0x6c,0x6c,0x67,0x29,0x60,0x64,0x79,0x65,0x6c,0x64,0x6c,0x67,0x7d,0x6c,0x6d]

private func spaceGlobal(always num: UInt8) -> UInt8 {
    return num ^ 9
}

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  PopupWithoutMediator.swift
//  AbroadTalking
//
//  Created by Joeyoung on 2022/9/1.
//

//: import UIKit
import UIKit

//: let kProgressHUD_W            = 80.0
let showMultiData = 80.0
//: let kProgressHUD_cornerRadius = 14.0
let const_dismissMain = 14.0
//: let kProgressHUD_alpha        = 0.9
let k_trustNoti = 0.9
//: let kBackgroundView_alpha     = 0.6
let dataPriorityConst_ = 0.6
//: let kAnimationInterval        = 0.2
let notiExistK = 0.2
//: let kTransformScale           = 0.9
let k_writingData = 0.9

//: open class ProgressHUD: UIView {
open class PopupWithoutMediator: UIView {
    //: required public init?(coder: NSCoder) {
    public required init?(coder _: NSCoder) {
        //: fatalError("init(coder:) has not been implemented")
        fatalError(String(bytes: userOriginApp.map{spaceGlobal(always: $0)}, encoding: .utf8)!)
    }

    //: static var shared = ProgressHUD()
    static var shared = PopupWithoutMediator()
    //: private override init(frame: CGRect) {
    override private init(frame: CGRect) {
        //: super.init(frame: frame)
        super.init(frame: frame)
        //: self.frame = UIScreen.main.bounds
        self.frame = UIScreen.main.bounds
        //: self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //: self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        //: self.addSubview(activityIndicator)
        self.addSubview(activityIndicator)
    }

    //: open override func copy() -> Any { return self }
    override open func copy() -> Any { return self }
    //: open override func mutableCopy() -> Any { return self }
    override open func mutableCopy() -> Any { return self }

    //: class func show() {
    class func indicator() {
        //: show(superView: nil)
        achromaticColorPush(superView: nil)
    }

    //: class func show(superView: UIView?) {
    class func achromaticColorPush(superView: UIView?) {
        //: if superView != nil {
        if superView != nil {
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: ProgressHUD.shared.frame = superView!.bounds
                PopupWithoutMediator.shared.frame = superView!.bounds
                //: ProgressHUD.shared.activityIndicator.center = ProgressHUD.shared.center
                PopupWithoutMediator.shared.activityIndicator.center = PopupWithoutMediator.shared.center
                //: superView!.addSubview(ProgressHUD.shared)
                superView!.addSubview(PopupWithoutMediator.shared)
            }
            //: } else {
        } else {
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: ProgressHUD.shared.frame = UIScreen.main.bounds
                PopupWithoutMediator.shared.frame = UIScreen.main.bounds
                //: ProgressHUD.shared.activityIndicator.center = ProgressHUD.shared.center
                PopupWithoutMediator.shared.activityIndicator.center = PopupWithoutMediator.shared.center
                //: AppConfig.getWindow().addSubview(ProgressHUD.shared)
                EventShapeStyle.that().addSubview(PopupWithoutMediator.shared)
            }
        }
        //: ProgressHUD.shared.hud_startAnimating()
        PopupWithoutMediator.shared.lacuna()
    }

    //: class func dismiss() {
    class func purchaseRequest() {
        //: ProgressHUD.shared.hud_stopAnimating()
        PopupWithoutMediator.shared.pic()
    }

    //: private func hud_startAnimating() {
    private func lacuna() {
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            //: self.activityIndicator.transform = CGAffineTransform(scaleX: kTransformScale, y: kTransformScale)
            self.activityIndicator.transform = CGAffineTransform(scaleX: k_writingData, y: k_writingData)
            //: self.activityIndicator.alpha = 0
            self.activityIndicator.alpha = 0
            //: UIView.animate(withDuration: kAnimationInterval) {
            UIView.animate(withDuration: notiExistK) {
                //: self.backgroundColor = UIColor(white: 0, alpha: kBackgroundView_alpha)
                self.backgroundColor = UIColor(white: 0, alpha: dataPriorityConst_)
                //: self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                //: self.activityIndicator.alpha = kProgressHUD_alpha
                self.activityIndicator.alpha = k_trustNoti
                //: self.activityIndicator.startAnimating()
                self.activityIndicator.startAnimating()
            }
        }
    }

    //: private func hud_stopAnimating() {
    private func pic() {
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: UIView.animate(withDuration: kAnimationInterval) {
            UIView.animate(withDuration: notiExistK) {
                //: self.backgroundColor = UIColor(white: 0, alpha: 0)
                self.backgroundColor = UIColor(white: 0, alpha: 0)
                //: self.activityIndicator.transform = CGAffineTransform(scaleX: kTransformScale, y: kTransformScale)
                self.activityIndicator.transform = CGAffineTransform(scaleX: k_writingData, y: k_writingData)
                //: self.activityIndicator.alpha = 0
                self.activityIndicator.alpha = 0
                //: } completion: { finished in
            } completion: { _ in
                //: self.activityIndicator.stopAnimating()
                self.activityIndicator.stopAnimating()
                //: ProgressHUD.shared.removeFromSuperview()
                PopupWithoutMediator.shared.removeFromSuperview()
            }
        }
    }

    // MARK: - Lazy load

    //: private lazy var activityIndicator: UIActivityIndicatorView = {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        //: let indicator = UIActivityIndicatorView(style: .whiteLarge)
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        //: indicator.bounds = CGRect(x: 0, y: 0, width: kProgressHUD_W, height: kProgressHUD_W)
        indicator.bounds = CGRect(x: 0, y: 0, width: showMultiData, height: showMultiData)
        //: indicator.center = self.center
        indicator.center = self.center
        //: indicator.backgroundColor = .black
        indicator.backgroundColor = .black
        //: indicator.layer.cornerRadius = kProgressHUD_cornerRadius
        indicator.layer.cornerRadius = const_dismissMain
        //: indicator.layer.masksToBounds = true
        indicator.layer.masksToBounds = true
        //: return indicator
        return indicator
        //: }()
    }()
}

//: extension ProgressHUD {
extension PopupWithoutMediator {
    //: class func toast(_ str: String?) {
    class func aggregationToast(_ str: String?) {
        //: toast(str, showTime: 1)
        toastOrCut(str, showTime: 1)
    }

    //: class func toast(_ str: String?, showTime: CGFloat) {
    class func toastOrCut(_ str: String?, showTime: CGFloat) {
        //: guard str != nil else { return }
        guard str != nil else { return }

        //: let titleLab = UILabel()
        let titleLab = UILabel()
        //: titleLab.backgroundColor = UIColor(white: 0, alpha: 0.8)
        titleLab.backgroundColor = UIColor(white: 0, alpha: 0.8)
        //: titleLab.layer.cornerRadius = 5
        titleLab.layer.cornerRadius = 5
        //: titleLab.layer.masksToBounds = true
        titleLab.layer.masksToBounds = true
        //: titleLab.text = str
        titleLab.text = str
        //: titleLab.font = .systemFont(ofSize: 16)
        titleLab.font = .systemFont(ofSize: 16)
        //: titleLab.textAlignment = .center
        titleLab.textAlignment = .center
        //: titleLab.numberOfLines = 0
        titleLab.numberOfLines = 0
        //: titleLab.textColor = .white
        titleLab.textColor = .white
        //: AppConfig.getWindow().addSubview(titleLab)
        EventShapeStyle.that().addSubview(titleLab)
        //: let size = titleLab.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)))
        let size = titleLab.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat(MAXFLOAT)))
        //: titleLab.center = AppConfig.getWindow().center
        titleLab.center = EventShapeStyle.that().center
        //: titleLab.bounds = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 30)
        titleLab.bounds = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 30)
        //: titleLab.alpha = 0
        titleLab.alpha = 0

        //: UIView.animate(withDuration: 0.2) {
        UIView.animate(withDuration: 0.2) {
            //: titleLab.alpha = 1
            titleLab.alpha = 1
            //: } completion: { finished in
        } completion: { _ in
            //: DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime) {
                //: UIView.animate(withDuration: 0.2) {
                UIView.animate(withDuration: 0.2) {
                    //: titleLab.alpha = 1
                    titleLab.alpha = 1
                    //: } completion: { finished in
                } completion: { _ in
                    //: titleLab.removeFromSuperview()
                    titleLab.removeFromSuperview()
                }
            }
        }
    }
}
