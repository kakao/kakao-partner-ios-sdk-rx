//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import AuthenticationServices

import KakaoSDKCommon
import KakaoPartnerSDKCommon
import KakaoSDKAuth
import KakaoPartnerSDKAuth

import RxKakaoSDKCommon

let AUTH_CONTROLLER = AuthController.shared

extension Reactive where Base: AuthController {
    
    /// :nodoc:
    public func verifyAgeWithAuthenticationSession(authLevel: AuthLevel? = nil,
                                                   ageLimit: Int? = nil,
                                                   skipTerms: Bool? = false,
                                                   adultsOnly: Bool? = false,
                                                   underAge: Bool? = false) -> Observable<Void> {
        return Observable.create { observable in
            let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
                (callbackUrl:URL?, error:Error?) in
                
                guard let callbackUrl = callbackUrl else {
                    if #available(iOS 12.0, *), let error = error as? ASWebAuthenticationSessionError {
                        if error.code == ASWebAuthenticationSessionError.canceledLogin {
                            SdkLog.e("The authentication session has been canceled by user.")
                            observable.onError(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        } else {
                            SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                            observable.onError(SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        }
                    } else if let error = error as? SFAuthenticationError, error.code == SFAuthenticationError.canceledLogin {
                        SdkLog.e("The authentication session has been canceled by user.")
                        observable.onError(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                    } else {
                        SdkLog.e("An unknown authentication session error occurred.")
                        observable.onError(SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    }
                    return
                }
                
                SdkLog.d("callback url: \(callbackUrl)")
                
                if let parseResultError = callbackUrl.ageOauthResult() {
                    SdkLog.d("parseResult: \(String(describing: parseResultError))")
                    //error
                    observable.onError(parseResultError)
                }
                else {
                    observable.onNext(Void())
                    observable.onCompleted() // Completable 때문에 onComplted()를 호출해줘야한다.
                }
                return                
            }
            
            var parameters = [String:Any]()
            parameters["token_type"] = "api"
            
            if let accessToken = AUTH.tokenManager.getToken()?.accessToken {
                parameters["access_token"] = accessToken
            }
            parameters["return_url"] = "\(try! KakaoSDK.shared.scheme())://ageauth"
            
            if let authLevel = authLevel {
                parameters["auth_level"] = authLevel.parameterValue
            }
                        
            parameters["auth_from"] = try! KakaoSDK.shared.appKey()
            
            if let ageLimit = ageLimit {
                parameters["age_limit"] = ageLimit
            }
            
            if let skipTerms = skipTerms {
                parameters["skip_term"] = skipTerms
            }
            
            if let adultsOnly = adultsOnly {
                parameters["adults_only"] = adultsOnly
            }
            
            if let underAge = underAge {
                parameters["under_age"] = underAge
            }
            
            let url = SdkUtils.makeUrlWithParameters(Urls.compose(.Auth, path:PartnerPaths.ageAuth), parameters:parameters)

            if let url = url {
                SdkLog.d("\n===================================================================================================")
                SdkLog.d("request: \n url:\(url)\n parameters: \(parameters) \n")
                
                if #available(iOS 12.0, *) {
                    let authenticationSession = ASWebAuthenticationSession.init(url: url,
                                                                                 callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                                 completionHandler:authenticationSessionCompletionHandler)
                    if #available(iOS 13.0, *) {
                        authenticationSession.presentationContextProvider = AUTH_CONTROLLER.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                    }
                    AUTH_CONTROLLER.authenticationSession = authenticationSession
                    (AUTH_CONTROLLER.authenticationSession as? ASWebAuthenticationSession)?.start()
                    
                }
                else {
                    AUTH_CONTROLLER.authenticationSession = SFAuthenticationSession.init(url: url,
                                                                              callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                              completionHandler:authenticationSessionCompletionHandler)
                    (AUTH_CONTROLLER.authenticationSession as? SFAuthenticationSession)?.start()
                }
            }
            return Disposables.create()
        }
    }
}
