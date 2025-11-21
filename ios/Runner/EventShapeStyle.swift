
//: Declare String Begin

/*: "cherayo" :*/
fileprivate let data_itemKindK:String = "chershowyo"

/*: "https://m. :*/
fileprivate let notiThatUser:String = "https:level camera"

/*: .com" :*/
fileprivate let appFrameNoti_:[Character] = [".","c","o","m"]

/*: "1.9.1" :*/
fileprivate let showAtBlackConst:String = "1.shared.1"

/*: "991" :*/
fileprivate let notiUsContentApp:[Character] = ["9","9","1"]

/*: "thfme415o1ds" :*/
fileprivate let show_centerMain:String = "thfmenormal"
fileprivate let kPromptApp:String = "on"

/*: "k6ov7o" :*/
fileprivate let app_countConst_:String = "access6ov7o"

/*: "CFBundleShortVersionString" :*/
fileprivate let k_revenueStopApp:String = "make decision info subCFBund"
fileprivate let show_privacyAllApp:String = "ersscale"
fileprivate let user_failConst_:[Character] = ["n","S","t","r","i","n","g"]

/*: "CFBundleDisplayName" :*/
fileprivate let appAfterConst:[Character] = ["C","F","B","u"]
fileprivate let app_methodMain_:[Character] = ["n","d","l","e","D","i","s","p","l","a","y","N","a","m","e"]

/*: "CFBundleVersion" :*/
fileprivate let data_dismissUser_:String = "succeed adjustment never serverCFBun"
fileprivate let notiRecordMain_:String = "RSION"

/*: "weixin" :*/
fileprivate let appAgainConst_:String = "weverticalxverticaln"

/*: "wxwork" :*/
fileprivate let userCountConst_:[Character] = ["w","x","w","o","r","k"]

/*: "dingtalk" :*/
fileprivate let showAtThatConst_:[Character] = ["d","i","n","g","t","a","l","k"]

/*: "lark" :*/
fileprivate let show_presentLayerEmpty:String = "behaviorrk"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  EventShapeStyle.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import KeychainSwift
import KeychainSwift
//: import UIKit
import UIKit

/// 域名
//: let ReplaceUrlDomain = "cherayo"
let showWarningConst = (data_itemKindK.replacingOccurrences(of: "show", with: "a"))
//: let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let mainMediaGenerateNoti = (String(notiThatUser.prefix(6)) + "//m.") + "\(showWarningConst)" + (String(appFrameNoti_))
/// 网络版本号
//: let AppNetVersion = "1.9.1"
let appCurrencyVersionShow = (showAtBlackConst.replacingOccurrences(of: "shared", with: "9"))
/// 包ID
//: let PackageID = "991"
let kArrowConsentMain = (String(notiUsContentApp))
/// Adjust
//: let AdjustKey = "thfme415o1ds"
let dataProductionShow = (show_centerMain.replacingOccurrences(of: "normal", with: "4") + "15o1" + kPromptApp.replacingOccurrences(of: "on", with: "ds"))
//: let AdInstallToken = "k6ov7o"
let user_countBar = (app_countConst_.replacingOccurrences(of: "access", with: "k"))

//: let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let main_decideNoti_ = Bundle.main.infoDictionary![(String(k_revenueStopApp.suffix(6)) + "leShortV" + show_privacyAllApp.replacingOccurrences(of: "scale", with: "io") + String(user_failConst_))] as! String
//: let AppBundle = Bundle.main.bundleIdentifier!
let constVersionData_ = Bundle.main.bundleIdentifier!
//: let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let noti_scalePriceConst = Bundle.main.infoDictionary![(String(appAfterConst) + String(app_methodMain_))] ?? ""
//: let AppBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let kServerDecideData_ = Bundle.main.infoDictionary![(String(data_dismissUser_.suffix(5)) + "dleVe" + notiRecordMain_.lowercased())] as! String

//: class AppConfig: NSObject {
class EventShapeStyle: NSObject {
    /// 获取状态栏高度
    //: class func getStatusBarHeight() -> CGFloat {
    class func barGetLowerClassHeight() -> CGFloat {
        //: if #available(iOS 13.0, *) {
        if #available(iOS 13.0, *) {
            //: if let statusBarManager = UIApplication.shared.windows.first?
            if let statusBarManager = UIApplication.shared.windows.first?
                //: .windowScene?.statusBarManager
                .windowScene?.statusBarManager
            {
                //: return statusBarManager.statusBarFrame.size.height
                return statusBarManager.statusBarFrame.size.height
            }
            //: } else {
        } else {
            //: return UIApplication.shared.statusBarFrame.size.height
            return UIApplication.shared.statusBarFrame.size.height
        }
        //: return 20.0
        return 20.0
    }

    /// 获取window
    //: class func getWindow() -> UIWindow {
    class func that() -> UIWindow {
        //: var window = UIApplication.shared.windows.first(where: {
        var window = UIApplication.shared.windows.first(where: {
            //: $0.isKeyWindow
            $0.isKeyWindow
            //: })
        })
        // 是否为当前显示的window
        //: if window?.windowLevel != UIWindow.Level.normal {
        if window?.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: return window!
        return window!
    }

    /// 获取当前控制器
    //: class func currentViewController() -> (UIViewController?) {
    class func input() -> (UIViewController?) {
        //: var window = AppConfig.getWindow()
        var window = EventShapeStyle.that()
        //: if window.windowLevel != UIWindow.Level.normal {
        if window.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: let vc = window.rootViewController
        let vc = window.rootViewController
        //: return currentViewController(vc)
        return manager(vc)
    }

    //: class func currentViewController(_ vc: UIViewController?)
    class func manager(_ vc: UIViewController?)
        //: -> UIViewController?
        -> UIViewController?
    {
        //: if vc == nil {
        if vc == nil {
            //: return nil
            return nil
        }
        //: if let presentVC = vc?.presentedViewController {
        if let presentVC = vc?.presentedViewController {
            //: return currentViewController(presentVC)
            return manager(presentVC)
            //: } else if let tabVC = vc as? UITabBarController {
        } else if let tabVC = vc as? UITabBarController {
            //: if let selectVC = tabVC.selectedViewController {
            if let selectVC = tabVC.selectedViewController {
                //: return currentViewController(selectVC)
                return manager(selectVC)
            }
            //: return nil
            return nil
            //: } else if let naiVC = vc as? UINavigationController {
        } else if let naiVC = vc as? UINavigationController {
            //: return currentViewController(naiVC.visibleViewController)
            return manager(naiVC.visibleViewController)
            //: } else {
        } else {
            //: return vc
            return vc
        }
    }
}

// MARK: - Device

//: extension UIDevice {
extension UIDevice {
    //: static var modelName: String {
    static var modelName: String {
        //: var systemInfo = utsname()
        var systemInfo = utsname()
        //: uname(&systemInfo)
        uname(&systemInfo)
        //: let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        //: let identifier = machineMirror.children.reduce("") {
        let identifier = machineMirror.children.reduce("") {
            //: identifier, element in
            identifier, element in
            //: guard let value = element.value as? Int8, value != 0 else {
            guard let value = element.value as? Int8, value != 0 else {
                //: return identifier
                return identifier
            }
            //: return identifier + String(UnicodeScalar(UInt8(value)))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //: return identifier
        return identifier
    }

    /// 获取当前系统时区
    //: static var timeZone: String {
    static var timeZone: String {
        //: let currentTimeZone = NSTimeZone.system
        let currentTimeZone = NSTimeZone.system
        //: return currentTimeZone.identifier
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    //: static var langCode: String {
    static var langCode: String {
        //: let language = Locale.preferredLanguages.first
        let language = Locale.preferredLanguages.first
        //: return language ?? ""
        return language ?? ""
    }

    /// 获取接口语言
    //: static var interfaceLang: String {
    static var interfaceLang: String {
        //: let lang = UIDevice.getSystemLangCode()
        let lang = UIDevice.center()
        //: if ["en", "ar", "es", "pt"].contains(lang) {
        if ["en", "ar", "es", "pt"].contains(lang) {
            //: return lang
            return lang
        }
        //: return "en"
        return "en"
    }

    /// 获取当前系统地区
    //: static var countryCode: String {
    static var countryCode: String {
        //: let locale = Locale.current
        let locale = Locale.current
        //: let countryCode = locale.regionCode
        let countryCode = locale.regionCode
        //: return countryCode ?? ""
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    //: static var systemUUID: String {
    static var systemUUID: String {
        //: let key = KeychainSwift()
        let key = KeychainSwift()
        //: if let value = key.get(AdjustKey) {
        if let value = key.get(dataProductionShow) {
            //: return value
            return value
            //: } else {
        } else {
            //: let value = NSUUID().uuidString
            let value = NSUUID().uuidString
            //: key.set(value, forKey: AdjustKey)
            key.set(value, forKey: dataProductionShow)
            //: return value
            return value
        }
    }

    /// 获取已安装应用信息
    //: static var getInstalledApps: String {
    static var getInstalledApps: String {
        //: var appsArr: [String] = []
        var appsArr: [String] = []
        //: if UIDevice.canOpenApp("weixin") {
        if UIDevice.desorb((appAgainConst_.replacingOccurrences(of: "vertical", with: "i"))) {
            //: appsArr.append("weixin")
            appsArr.append((appAgainConst_.replacingOccurrences(of: "vertical", with: "i")))
        }
        //: if UIDevice.canOpenApp("wxwork") {
        if UIDevice.desorb((String(userCountConst_))) {
            //: appsArr.append("wxwork")
            appsArr.append((String(userCountConst_)))
        }
        //: if UIDevice.canOpenApp("dingtalk") {
        if UIDevice.desorb((String(showAtThatConst_))) {
            //: appsArr.append("dingtalk")
            appsArr.append((String(showAtThatConst_)))
        }
        //: if UIDevice.canOpenApp("lark") {
        if UIDevice.desorb((show_presentLayerEmpty.replacingOccurrences(of: "behavior", with: "la"))) {
            //: appsArr.append("lark")
            appsArr.append((show_presentLayerEmpty.replacingOccurrences(of: "behavior", with: "la")))
        }
        //: if appsArr.count > 0 {
        if appsArr.count > 0 {
            //: return appsArr.joined(separator: ",")
            return appsArr.joined(separator: ",")
        }
        //: return ""
        return ""
    }

    /// 判断是否安装app
    //: static func canOpenApp(_ scheme: String) -> Bool {
    static func desorb(_ scheme: String) -> Bool {
        //: let url = URL(string: "\(scheme)://")!
        let url = URL(string: "\(scheme)://")!
        //: if UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    //: @objc public class func getSystemLangCode() -> String {
    @objc public class func center() -> String {
        //: let language = NSLocale.preferredLanguages.first
        let language = NSLocale.preferredLanguages.first
        //: let array = language?.components(separatedBy: "-")
        let array = language?.components(separatedBy: "-")
        //: return array?.first ?? "en"
        return array?.first ?? "en"
    }
}
