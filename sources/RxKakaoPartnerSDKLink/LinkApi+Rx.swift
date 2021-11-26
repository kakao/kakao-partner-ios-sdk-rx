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

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire
import KakaoPartnerSDKCommon
import KakaoSDKCommon
import KakaoSDKLink
import KakaoSDKTemplate
import RxKakaoSDKLink

/// 카카오링크 호출을 담당하는 클래스입니다.
extension Reactive where Base: LinkApi  {
    
    func defaultLink(targetAppKey:String,
                     templateObjectJsonString:String?,
                     serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.defalutLink),
                                parameters: ["link_ver":"4.0",
                                             "template_object":templateObjectJsonString,
                                             "target_app_key":targetAppKey].filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createLinkResultComposeTransformer(targetAppKey: targetAppKey))
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// - seealso: [Template](../../KakaoSDKTemplate/Protocols/Templatable.html) <br> `LinkResult`
    public func defaultLink(targetAppKey:String,
                            templatable: Templatable,
                            serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return self.defaultLink(targetAppKey:targetAppKey,
                                templateObjectJsonString: templatable.toJsonObject()?.toJsonString(),
                                serverCallbackArgs:serverCallbackArgs)
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// - seealso: `LinkResult`
    public func defaultLink(targetAppKey:String,
                            templateObject:[String:Any],
                            serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return self.defaultLink(targetAppKey:targetAppKey,
                                templateObjectJsonString: templateObject.toJsonString(),
                                serverCallbackArgs:serverCallbackArgs)
    }
    
    /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오톡으로 공유합니다.
    /// - seealso: `LinkResult`
    public func scrapLink(targetAppKey:String,
                          requestUrl:String,
                          templateId:Int64? = nil,
                          templateArgs:[String:String]? = nil,
                          serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.scrapLink),
                                parameters: ["link_ver":"4.0",
                                             "request_url":requestUrl,
                                             "template_id":templateId,
                                             "template_args":templateArgs?.toJsonString(),
                                             "target_app_key":targetAppKey].filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createLinkResultComposeTransformer(targetAppKey: targetAppKey))
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오톡으로 공유합니다. 템플릿을 생성하는 방법은 https://developers.kakao.com/docs/latest/ko/message/ios#create-message 을 참고하시기 바랍니다.
    /// - seealso: `LinkResult`
    public func customLink(targetAppKey:String,
                           templateId:Int64,
                           templateArgs:[String:String]? = nil,
                           serverCallbackArgs:[String:String]? = nil) -> Single<LinkResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.validateLink),
                                parameters: ["link_ver":"4.0",
                                             "template_id":templateId,
                                             "template_args":templateArgs?.toJsonString(),
                                             "target_app_key":targetAppKey].filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createLinkResultComposeTransformer(targetAppKey: targetAppKey))
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
}
