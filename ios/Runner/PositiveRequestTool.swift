
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let constModelShow:[Character] = ["N","e","t"," ","E","r"]
fileprivate let main_allowPointData:String = "visible other post arrowror, "
fileprivate let constAppearLaterShow:String = "arrowai"

/*: "data" :*/
fileprivate let user_controlMain_:[Character] = ["d","a","t","a"]

/*: ":null" :*/
fileprivate let constToolData:[Character] = [":","n","u","l","l"]

/*: "json error" :*/
fileprivate let app_failureOfShow_:String = "protection"
fileprivate let noti_tingShow:[Character] = ["o","n"," ","e","r","r","o","r"]

/*: "platform=iphone&version= :*/
fileprivate let appSceneData_:[Character] = ["p","l","a","t","f","o","r","m","=","i","p","h","o","n","e","&","v","e","r","s","i","o","n","="]

/*: &packageId= :*/
fileprivate let show_formatMain:String = "temp photo protection s&pa"
fileprivate let showCutKindConst:String = "ckageId=current list bar extension"

/*: &bundleId= :*/
fileprivate let user_timeConst_:String = "&bunfailure first give"
fileprivate let showVisibleColor:[Character] = ["="]

/*: &lang= :*/
fileprivate let mainKitData_:String = "agent path protection dismiss search&lang="

/*: ; build: :*/
fileprivate let app_priorityShow_:[Character] = [";"," ","b","u","i"]
fileprivate let app_bounceNeverData:String = "list close source giveld:"

/*: ; iOS  :*/
fileprivate let constOriginalNetData:String = "; iOS interval tab need please"

//: Declare String End

//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit

//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: CommandErrorResponse?) -> Void

//: @objc class AppRequestTool: NSObject {
@objc class PositiveRequestTool: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func breakIn(model: PathRequestModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.request(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.runApplication(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                completionActive(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)

            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, CommandErrorResponse(errorCode: ResultPropertyProtocol.NetError.rawValue, errorMsg: (String(constModelShow) + String(main_allowPointData.suffix(5)) + "Try " + constAppearLaterShow.replacingOccurrences(of: "arrow", with: "ag") + "n later")))
            }
        }
    }

    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func completionActive(model _: PathRequestModel, response _: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (String(user_controlMain_)) + "\"" + (String(constToolData)), with: "" + "\"" + (String(user_controlMain_)) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<TimingBaseResponse>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == ResultPropertyProtocol.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
                //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, CommandErrorResponse(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case ResultPropertyProtocol.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
            //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, CommandErrorResponse(errorCode: ResultPropertyProtocol.NetError.rawValue, errorMsg: (app_failureOfShow_.replacingOccurrences(of: "protection", with: "js") + String(noti_tingShow))))
        }
    }

    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func request(model: PathRequestModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (String(appSceneData_)) + "\(appCurrencyVersionShow)" + (String(show_formatMain.suffix(3)) + String(showCutKindConst.prefix(8))) + "\(kArrowConsentMain)" + (String(user_timeConst_.prefix(4)) + "dleId" + String(showVisibleColor)) + "\(constVersionData_)" + (String(mainKitData_.suffix(6))) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")

        //: return serverUrl
        return serverUrl
    }

    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func runApplication(model _: PathRequestModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(noti_scalePriceConst)/\(main_decideNoti_) (\(constVersionData_)" + (String(app_priorityShow_) + String(app_bounceNeverData.suffix(3))) + "\(kServerDecideData_)" + (String(constOriginalNetData.prefix(6))) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
