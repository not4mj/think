//
//  BaseService.swift
//  AppleMocks
//
//  Created by Mohsin Jamadar on 7/15/15.
//  Copyright (c) 2015 Mohsin Jamadar. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import AFNetworking

enum RequestStatus : Int {
    case loginFailed
    case invalidCredential = 400
    case notAuthorized
}

open class BaseService {
    
    let baseUrlScheme = ConfigurationManager.sharedInstance.baseUrlComponents()[ConfigurationManager.schemePlistKey]!
    let baseUrl = ConfigurationManager.sharedInstance.baseUrlComponents()[ConfigurationManager.baseUrlPlistKey]!
    var logoutBlock: BasicBlock?
    static let timeOut = 200.0
    typealias SuccessBlock = (AnyObject?) -> (Void)
    typealias FailureBlock = (Int) -> (Void)

    func submitRequest(_ urlRequest: NSMutableURLRequest, headers: Dictionary<String, String>, queryStringParams: Dictionary<String, String>?, body: Data?, method: String, success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        self.addHeaders(headers, request: urlRequest)

        urlRequest.httpBody = body
        urlRequest.httpMethod = method
        urlRequest.timeoutInterval = 20
        
        self.logRequest(urlRequest as URLRequest)

        let operation = AFHTTPRequestOperation(request: urlRequest as URLRequest)
        
        operation.setCompletionBlockWithSuccess(
            { (operation:AFHTTPRequestOperation?, responseData: Any) -> Void in
                success(responseData as AnyObject?)
            },
            failure: { (op, error) -> Void in
                let httpResponse = operation.response! as HTTPURLResponse
                if httpResponse.statusCode == 401 {
                    print("----->LOG OUT")
                    self.LogOffFromApp()
                }
                else if httpResponse.statusCode > 204 {
                    failure((httpResponse.statusCode))
                }

            }
        )
        operation.start()   
    }
    // MARK: Log-Off - Remove: Token, user_guid
    func LogOffFromApp()
    {
        if let l = self.logoutBlock {
            l()
        }
        
        //After Log-Off delete the user guid id and token and clear all values
        let common:CommonMethods = CommonMethods()
        common.DeleteKeyFromKeyChain("access_token")
        common.DeleteKeyFromKeyChain("user_guid")
        CredentialManager.sharedInstance.clearAuthorization()
        
        //Clear the hud if any
        SVProgressHUD.dismiss()
        
        //get the presented view controller
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        //dismisss the presented view controller to go back to Login view
        dismissModalStack(rootViewController!.presentedViewController!, animated: true, completionBlock: nil)
        
        //Display token expiry prompt
        showAlert("Attention", message: "Your session is expired. Please login again to continue.", buttonTitle: "Ok", source:rootViewController! )
    }

    func logRequest(_ urlRequest: URLRequest) {
        print("Submitting request \(urlRequest.url)")
        print("Method \(urlRequest.httpMethod)")
        if let b = urlRequest.httpBody {
            print("body: \(NSString(data: b, encoding: String.Encoding.utf8.rawValue))")
        }
    }
    
    func addHeaders(_ headers: Dictionary<String, String>, request: NSMutableURLRequest) {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func headers() -> Dictionary<String, String> {
        var headers = Dictionary<String, String>()
        headers["Content-Type"] = "application/json";
        headers["Accept"] = "application/json";
        // Optionally add authorization tokens, request nonces etc.
        
        if let h = self.authorizationHeader() {
            headers["Authorization"] = h
        }
        
        return headers;
    }
    
    func authorizationHeader() -> String? {
        let token = CommonMethods().RetriveKeyFromKeyChain("access_token")
        if let t = token {
            return "Bearer \(t)"
        }
        return nil
    }
    
    func absoluteUrl(_ scheme: String, host: String, relativeUrl: String?, queryStringParams: Dictionary<String, String>?) -> URL {
        var nsUrlComponents = URLComponents()
        nsUrlComponents.scheme = scheme
        nsUrlComponents.host = host
        
        if let r = relativeUrl {
            nsUrlComponents.path = ConfigurationManager.sharedInstance.baseUrlComponents()[ConfigurationManager.relativePathPlistKey]! + r
        }
        
        if let q = queryStringParams {
            nsUrlComponents.query = q.toEncodedQueryParamString()
        }
        
        return nsUrlComponents.url!
    }    
}
