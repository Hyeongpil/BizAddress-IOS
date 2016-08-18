//
//  DataAccessManager.swift
//  IBKBizcard
//
//  Created by Ann on 6/7/16.
//  Copyright © 2016 webcash. All rights reserved.
//

import UIKit

struct EmplParamater {
    
    var apiId: String
    var apiKey: String
    
    private func toDic() -> [String:AnyObject] {
        return ["SVC_CD": apiId, "SECR_KEY": apiKey, "PTL_STS" : "C"]
    }
    
}

final class GetEmplDataManager: NSObject {
    
    var empl_info_URL : String?
    var empl_apiKey : String?
    var empl_ptlID : String?
    var empl_apiId = EmplApikey.mEmplInfoSchUserApiId // 직원 데이터 목록
    
    func setURL(){ // 1이면 개발 2는 운영
        let branch = Constant.branch
        if branch == 1{
            empl_info_URL = EmplApikey.emplURL_develop
            empl_apiKey = EmplApikey.emplApiKey_develop
            empl_ptlID = EmplApikey.emplPtlId_develop
        }else{
            empl_info_URL = EmplApikey.emplURL_release
            empl_apiKey = EmplApikey.emplApiKey_release
            empl_ptlID = EmplApikey.emplPtlId_release
        }
    }
    
    
    //MARK:- properties
    
    //shareInstance
    static let emplManager = GetEmplDataManager()
    var reach:Reachability?
    
    //ensure nobody allocs this class
    private override init() {}
    
    var useLoadingView: Bool = true
    private var dataTask: NSURLSessionTask?
    private var apiMember: String!

    
    //MARK: - Methods
    
    //default HTTP POST
    func fetchDataForAPI(apiKey: String, apiId: String,suffixDic: [String: AnyObject],completion:(result: NSDictionary?, error: NSError?) -> Void) {
        if self.canConnectNetwork() == false{
            
            CommonClass.getAlertController(Constant.NO_CONNECTION)
        }else{
            self.fetchDataForAPI(apiKey, apiId:apiId, suffixDic: suffixDic, method: HTTPMethod.Post, completion: { result, error in
                dispatch_async(dispatch_get_main_queue(), {
                    print("dispatch_async 진입")
                    
                    completion(result: result,error: error)
                    if apiKey == self.empl_apiKey {
                        LoadingView.delayBeforeHide(seconds: 7)
                    }else {
                        LoadingView.hide()
                    }
                    
                });
            })
            
        }
        
    }
    
    func canConnectNetwork() -> Bool {
        reach = Reachability.reachabilityForInternetConnection()
        if reach!.currentReachabilityStatus() == NetworkStatus.NotReachable{
            return false
        }else{
            return true
        }
    }
    
    
    
    func fetchDataForAPI(apiKey: String,apiId: String,suffixDic: [String: AnyObject],method: HTTPMethod, completion:(result: NSDictionary?, error: NSError?) -> Void) {
        do {
            try self.connectServer(apiKey, apiId: apiId, suffixDic: suffixDic,method: method, completion: { result, error in
                if error != nil {
                    assert(error != nil,"fetch data error")
                    //Modified by SAMBO
                    if apiId == self.empl_apiId {
                        LoadingView.hide()
                    }
                    //-----------------
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(result: nil,error: error)
                    });
                    return
                }else{ // sucess result
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(result: result,error: nil)
                    });
                }
            })
        }catch URLError.InvalidURL{
            let error = NSError(domain: "URL", code: 10000, userInfo: [NSLocalizedDescriptionKey : "InvalidURL"])
            completion(result: nil,error: error)
        }catch JSONError.SerializedJSONError {
            let error = NSError(domain: "JSON", code: 20000, userInfo: [NSLocalizedDescriptionKey : "SerializedJSONError"])
            completion(result: nil,error: error)
        }catch JSONError.DeserializedJSONError{
            let error = NSError(domain: "JSON", code: 20001, userInfo: [NSLocalizedDescriptionKey : "DeserializedJSONError"])
            completion(result: nil,error: error)
        }catch DataError.InvalidEncodingData{
            let error = NSError(domain: "Data", code: 30001, userInfo: [NSLocalizedDescriptionKey : "InvalidEncodingData"])
            completion(result: nil,error: error)
        }catch let error as NSError{ // all NSErrors go to this block
            completion(result: nil,error: error)
        }
    }
    
    private func getURLSession()-> NSURLSession {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 40.0
        configuration.timeoutIntervalForResource = 60.0
        let session = NSURLSession(configuration: configuration)
        
        return session
    }
    
    private func storeCookie(response: NSHTTPURLResponse) {
        
        let httpCookie = NSHTTPCookie.cookiesWithResponseHeaderFields(response.allHeaderFields as! [String : String], forURL: response.URL!)
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in httpCookie {
            cookieStorage.setCookie(cookie)
        }
    }
    
    private func connectServer(apiKey: String,  apiId: String, suffixDic: [String:AnyObject],method: HTTPMethod,completion:(result:NSDictionary?, error: NSError?) -> Void) throws {
        //check api
        print("connectServer 진입")
        
        var rootDic = EmplParamater(apiId: apiId, apiKey: apiKey).toDic()
        rootDic["REQ_DATA"] = suffixDic
        
        let url: NSMutableURLRequest = try urlForQuery(whatToQuery:rootDic,forMethod: method)
        
        
        print("store cookiet \(NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies)")
        
        
        #if DEBUG
            print("Req \(rootDic)")
            print("URL request \(url.URL?.absoluteString)")
        #endif
        
        let urlSession = getURLSession()
        
        dataTask = urlSession.dataTaskWithRequest(url, completionHandler: { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error != nil {
                
                print("Conenectin server error")
                
                switch error!.code {
                    
                case -1001 : // request timed out
                    let error = NSError(domain: "NSURLErrorDomain", code: -1001, userInfo: [NSLocalizedDescriptionKey : "통신오류 타임아웃"])
                    completion(result: nil,error: error)
                case -1004 : // Can't connect to host
                    let error = NSError(domain: "NSURLErrorDomain", code: -1001, userInfo: [NSLocalizedDescriptionKey : "통신오류 타임아웃"])
                    completion(result: nil,error: error)
                case -1005 : // Network connection lost
                    let error = NSError(domain: "NSURLErrorDomain", code: -1005, userInfo: [NSLocalizedDescriptionKey : "통신오류 타임아웃"])
                    completion(result: nil,error: error)
                case -1009 : // No internet connection
                    let error = NSError(domain: "NSURLErrorDomain", code: -1009, userInfo: [NSLocalizedDescriptionKey : "통신오류 타임아웃"])
                    completion(result: nil,error: error)
                default :
                    completion(result: nil,error: error)
                }
                
                return
            }else{
                
                guard let urlResponse = response as? NSHTTPURLResponse else{
                    let error = NSError(domain: "ClientError", code: 40000, userInfo: [NSLocalizedDescriptionKey : "UnKnown"])
                    completion(result: nil,error: error)
                    return
                }
                
                print("url 응답코드 :\(urlResponse.statusCode)")
                switch(urlResponse.statusCode) {
                case 200: // 200 is OK
                    guard let jsonData = data else{
                        assert(data == nil ,"response data is nil")
                        completion(result: nil, error: error!)
                        return
                    }
                    
                    guard let data = UTF8.decodeForData(jsonData) else{
                        let error = NSError(domain: "ClientError", code: 40000, userInfo: [NSLocalizedDescriptionKey : "Parse JSON Error"])
                        completion(result: nil, error: error)
                        return
                    }
                    
                    guard let resultDic = try? JSON.jsonToDic(data) else{
                        print("parse to Dic \(jsonData)")
                        completion(result: nil, error: error)
                        return
                    }
                    
                    #if DEBUG
                        print("Response \(resultDic)")
                    #endif
                    
                    
                    if urlResponse.URL?.absoluteURL.absoluteString == ("\(self.empl_info_URL)/gw/ApiGate?") {
                        completion(result: resultDic, error: nil)
                        return
                    }
                    
                    guard let resultCode: String = resultDic["RSLT_CD"] as? String where resultCode == "0000" else{
                        let error = NSError(domain: "Webcash", code: 99999, userInfo: resultDic as? [NSObject : AnyObject])
                        completion(result: nil, error: error)
                        print("Webcash error \(resultDic)")
                        return
                    }
                    //success result
                    completion(result: resultDic, error: nil)
                case 408: //request time out
                    let error = NSError(domain: "ClientError", code: 40000, userInfo: [NSLocalizedDescriptionKey : "통신오류 타임아웃"])
                    completion(result: nil,error: error)
                case 404: // page not found
                    let error = NSError(domain: "ClientError", code: 40001, userInfo: [NSLocalizedDescriptionKey : "PageNotFound"])
                    completion(result: nil,error: error)
                case 502: // bad gateway
                    let error = NSError(domain: "ServerError", code: 50000, userInfo: [NSLocalizedDescriptionKey : "BadGateway"])
                    completion(result: nil,error: error)
                case 504: // gateway time out
                    let error = NSError(domain: "ServerError", code: 50001, userInfo: [NSLocalizedDescriptionKey : "GateWayTimeout"])
                    completion(result: nil,error: error)
                default:
                    let error = NSError(domain: "ClientError", code: 40000, userInfo: [NSLocalizedDescriptionKey : "통신 상태가 불안정합니다.\n잠시 후 이용하시기 바랍니다."])
                    completion(result: nil,error: error)
                }
            }
            
        })
        dataTask?.resume()
        
    }
    
    private func baseURL(baseUrlString: String) throws -> NSURL{
        guard let baseURL = NSURL(string: baseUrlString) else{
            throw URLError.InvalidURL
        }
        return baseURL
    }
    
    private func urlForQuery(whatToQuery whatToQuery: [String:AnyObject],forMethod method: HTTPMethod) throws -> NSMutableURLRequest {
        
        let jsonString = try JSON.dicToJSONString(whatToQuery)
        let encodeString = UTF8.encode(jsonString)
        
        guard let url = NSURL(string: "gw/ApiGate?JSONData=\(encodeString)", relativeToURL: try self.baseURL(self.empl_info_URL!)) else{
            throw URLError.InvalidURL
        }
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.getMethod()
        return request
    }
}
