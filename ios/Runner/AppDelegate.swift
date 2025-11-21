
//: Declare String Begin

/*: /dist/index.html#/?packageId= :*/
fileprivate let mainGiveAgainUser_:String = "in select please/dist"
fileprivate let k_ratingNoti_:String = ".html#feedback local"
fileprivate let showActionNoti:String = "kmultige"
fileprivate let main_appData_:String = "origin log error text availableId="

/*: &safeHeight= :*/
fileprivate let app_inputArrayConst_:String = "&safeHpresent layer index"
fileprivate let appWindowData:String = "eight=arrow color progress language warning"

/*: "token" :*/
fileprivate let constCenterUser:[UInt8] = [0x81,0x9a,0x9e,0x90,0x9b]

/*: "FCMToken" :*/
fileprivate let mainContactData_:String = "FCMTokenhandle field layer core"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  AppDelegate.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//

//: import AVFAudio
import AVFAudio
//: import Firebase
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import UIKit
import UIKit
//: import UserNotifications
import UserNotifications

import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var ZaliVectorizeItUtilCaptionEmeraldMagentaVersion = "110"
    var ZaliVectorizeItUtilCaptionConfigCurrentFire = 0
    var ZaliVectorizeItUtilCaptionMainVC = UIViewController()
    
    private var ZaliVectorizeItUtilApplication: UIApplication?
    private var ZaliVectorizeItUtilLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let appname = "ZaliVectorizeItUtilCaption"
        
        if appname == "VersionReference" {
            AccelerateConsultativeLostMobileTask()
        }
        
        self.ZaliVectorizeItUtilApplication = application
        self.ZaliVectorizeItUtilLaunchOptions = launchOptions
        
      self.ZaliVectorizeItUtilCaptionVersusPattern()
      GeneratedPluginRegistrant.register(with: self)
        
        
        let ZaliVectorizeItUtilCaptionSubVc = UIViewController.init()
        let ZaliVectorizeItUtilCaptionContentBGImgV = UIImageView(image: UIImage(named: "LaunchImage"))
        ZaliVectorizeItUtilCaptionContentBGImgV.image = UIImage(named: "LaunchImage")
        ZaliVectorizeItUtilCaptionContentBGImgV.frame = CGRectMake(0, 0, UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        ZaliVectorizeItUtilCaptionContentBGImgV.contentMode = .scaleToFill
        ZaliVectorizeItUtilCaptionSubVc.view.addSubview(ZaliVectorizeItUtilCaptionContentBGImgV)
        self.ZaliVectorizeItUtilCaptionMainVC = ZaliVectorizeItUtilCaptionSubVc
        self.window.rootViewController?.view.addSubview(self.ZaliVectorizeItUtilCaptionMainVC.view)
        self.window?.makeKeyAndVisible()
        
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    

    
    func ZaliVectorizeItUtilCaptionVersusPattern(){
        
        // 获取构建版本号并去掉点号
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let buildVersionWithoutDots = buildVersion.replacingOccurrences(of: ".", with: "")
            print("去掉点号的构建版本号：\(buildVersionWithoutDots)")
            self.ZaliVectorizeItUtilCaptionEmeraldMagentaVersion = buildVersionWithoutDots
        } else {
            print("无法获取构建版本号")
        }
        
        ZaliVectorizeItUtilCaptionEmeraldMagentaVersion = "-1"
        
        self.observer()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { changed, error in
                    let ZaliVectorizeItUtilCaptionFlowerJungleVersion = remoteConfig.configValue(forKey: "Zali").stringValue ?? ""
//                    self.ZaliVectorizeItUtilCaptionEmeraldMagentaVersion = ZaliVectorizeItUtilCaptionFlowerJungleVersion
                    print("google ZaliVectorizeItUtilCaptionFlowerJungleVersion ：\(ZaliVectorizeItUtilCaptionFlowerJungleVersion)")
                    
                    let ZaliVectorizeItUtilCaptionFlowerJungleVersionVersionVersionInt = Int(ZaliVectorizeItUtilCaptionFlowerJungleVersion) ?? 0
                    self.ZaliVectorizeItUtilCaptionConfigCurrentFire = ZaliVectorizeItUtilCaptionFlowerJungleVersionVersionVersionInt
                    // 3. 转换为整数
                    let ZaliVectorizeItUtilCaptionEmeraldMagentaVersionVersionInt = Int(self.ZaliVectorizeItUtilCaptionEmeraldMagentaVersion) ?? 0
                    
                    if ZaliVectorizeItUtilCaptionEmeraldMagentaVersionVersionInt < ZaliVectorizeItUtilCaptionFlowerJungleVersionVersionVersionInt {
                        ConsultativeNotifierTarget.showSignificantBinary();
                        DispatchQueue.main.async {
                            self.ZaliVectorizeItUtilCaptionMainView()
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.ZaliVectorizeItUtilCaptionMainVC.view.removeFromSuperview()
                        }
                        DispatchQueue.main.async {
                            ConsultativeNotifierTarget.showInvisibleTweenEnvironment();
                            super.application(self.ZaliVectorizeItUtilApplication!, didFinishLaunchingWithOptions: self.ZaliVectorizeItUtilLaunchOptions)
                        }
                    }
                }
            } else {
                if self.ZaliVectorizeItUtilCaptionCommonIntensityTimeCarrotTriangle() && self.ZaliVectorizeItUtilCaptionOutAwaitEventDeviceBlackWood() {
                    ConsultativeNotifierTarget.computeUsedModulus();
                    DispatchQueue.main.async {
                        self.ZaliVectorizeItUtilCaptionMainView()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.ZaliVectorizeItUtilCaptionMainVC.view.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        ConsultativeNotifierTarget.marshalCoordinatorContainEffect();
                        super.application(self.ZaliVectorizeItUtilApplication!, didFinishLaunchingWithOptions: self.ZaliVectorizeItUtilLaunchOptions)
                    }
                }
            }
        }
    }
    
    func ZaliVectorizeItUtilCaptionMainView(){
        //: registerForRemoteNotification(application)
        windowNotification(self.ZaliVectorizeItUtilApplication!)
        //: AppAdjustManager.shared.initAdjust()
        SophisticatedOptimizerType.shared.to()
        // 检查是否有未完成的支付订单
        //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
        GroupActionRate.shared.window()
        // 支持后台播放音乐
        //: try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        //: try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setActive(true)

        //: let vc = AppWebViewController()
        let vc = ResponseDelegate()
        //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
        vc.urlString = "\(mainMediaGenerateNoti)" + (String(mainGiveAgainUser_.suffix(5)) + "/index" + String(k_ratingNoti_.prefix(6)) + "/?pac" + showActionNoti.replacingOccurrences(of: "multi", with: "a") + String(main_appData_.suffix(3))) + "\(kArrowConsentMain)" + (String(app_inputArrayConst_.prefix(6)) + String(appWindowData.prefix(6))) + "\(EventShapeStyle.barGetLowerClassHeight())"
        //: window?.rootViewController = vc
        window?.rootViewController = vc
        //: window?.makeKeyAndVisible()
        window?.makeKeyAndVisible()
    }
    
    private func ZaliVectorizeItUtilCaptionOutAwaitEventDeviceBlackWood() -> Bool {
        ConsultativeNotifierTarget.upCardModel();
        return UIDevice.current.userInterfaceIdiom != .pad
    }
    
    private func ZaliVectorizeItUtilCaptionCommonIntensityTimeCarrotTriangle() -> Bool {
        let TensorSpotEffect:[Character] = ["1","7","6","3","8","6","1","4","0","0"]
        ConsultativeNotifierTarget.withinSemanticsRect();
        let CommonIntensity: TimeInterval = TimeInterval(String(TensorSpotEffect)) ?? 0.0
        let TextWorkInterval = Date().timeIntervalSince1970
        return TextWorkInterval > CommonIntensity
    }
    
    
}




// MARK: - Firebase

//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: func initFireBase() {
    func observer() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }


    //: func registerForRemoteNotification(_ application: UIApplication) {
    func windowNotification(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                //: })
            })
            //: application.registerForRemoteNotifications()
            application.registerForRemoteNotifications()
        }
    }

    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
                //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }

    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }

    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }

    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }

    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: constCenterUser.map{$0^245}, encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(mainContactData_.prefix(8)))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict
        )
    }
}


func AccelerateConsultativeLostMobileTask(){
    ConsultativeNotifierTarget.freeNativeWidget();
    ConsultativeNotifierTarget.publishRelationalContainer();
    ConsultativeNotifierTarget.createIconTask();
    ConsultativeNotifierTarget.mountUndertakeAcrossCanvas();
    ConsultativeNotifierTarget.cacheGrayscaleGraph();
    ConsultativeNotifierTarget.keepLogarithmOutsideDuration();
    ConsultativeNotifierTarget.fetchCustomPromise();
    ConsultativeNotifierTarget.awaitPivotalCanvas();
    ConsultativeNotifierTarget.finishElasticCoordinator();
    ConsultativeNotifierTarget.computeUsedModulus();
    ConsultativeNotifierTarget.cloneIndicatorThroughAmortization();
    ConsultativeNotifierTarget.stopDimensionGroup();
    ConsultativeNotifierTarget.awaitDisplayableGift();
    ConsultativeNotifierTarget.restartPlaybackAlongMatrix();
    ConsultativeNotifierTarget.dispatchIntermediateTween();
    ConsultativeNotifierTarget.serializeUpRequestNumber();
    ConsultativeNotifierTarget.quantizerDialogsWithoutNode();
    ConsultativeNotifierTarget.interceptComposableTable();
    ConsultativeNotifierTarget.augmentScrollableResult();
    ConsultativeNotifierTarget.inflateBeforeFlexStructure();
    ConsultativeNotifierTarget.skipIntoHeapPattern();
    ConsultativeNotifierTarget.deployDraggableBloc();
    ConsultativeNotifierTarget.navigateSeekBelowMission();
    ConsultativeNotifierTarget.belowOptimizerCallback();
    ConsultativeNotifierTarget.readVisibleCapacities();
    ConsultativeNotifierTarget.findEffectOrNavigator();
    ConsultativeNotifierTarget.serializeEasyTitle();
    ConsultativeNotifierTarget.forScaffoldAscent();
    ConsultativeNotifierTarget.onTabviewTexture();
    ConsultativeNotifierTarget.mapDirectRemainderEnvironment();
    ConsultativeNotifierTarget.renderInheritedButton();
    ConsultativeNotifierTarget.embedWithinIsolateForm();
    ConsultativeNotifierTarget.validateCatalystResolver();
    ConsultativeNotifierTarget.parseRestoreToSkin();
    ConsultativeNotifierTarget.mountOverPlaybackTemple();
    ConsultativeNotifierTarget.handleStatefulObserver();
}
