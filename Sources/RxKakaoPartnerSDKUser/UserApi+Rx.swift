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
import Alamofire
import RxAlamofire

import KakaoPartnerSDKCommon
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

import KakaoPartnerSDKAuth
import RxKakaoPartnerSDKAuth
import KakaoPartnerSDKUser


/// 사용자관리 API 호출을 담당하는 클래스입니다.
extension Reactive where Base: UserApi {
    
    // MARK: Login with Kakao Account
    
#if swift(>=5.8)
    @_documentation(visibility: private)
#endif
    public func loginWithKakaoAccount(accountParameters: [String:String]) -> Observable<OAuthToken> {
        return AuthController.shared.rx._authorizeWithAuthenticationSession(accountParameters:accountParameters)
    }
    
#if swift(>=5.8)
    @_documentation(visibility: private)
#endif
    public func loginWithKakaoAccount(prompts : [Prompt]? = nil,
                                      loginHint: String? = nil,
                                      nonce: String? = nil,
                                      accountsSkipIntro: Bool? = nil,
                                      accountsTalkLoginVisible: Bool? = nil) -> Observable<OAuthToken> {
        return AuthController.shared.rx._authorizeWithAuthenticationSession(prompts: prompts,
                                                                            loginHint:loginHint,
                                                                            nonce: nonce,
                                                                            accountsSkipIntro:accountsSkipIntro,
                                                                            accountsTalkLoginVisible: accountsTalkLoginVisible)
    }
    
    /// 사용자에 대한 다양한 정보를 얻을 수 있습니다.
    /// ## SeeAlso 
    /// ``PartnerUser``
    public func meForPartner(propertyKeys: [String]? = nil, secureResource: Bool = true) -> Single<PartnerUser> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userMe), parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 앱 연결 상태가 **PREREGISTER** 상태의 사용자에 대하여 앱 연결 요청을 합니다. **자동연결** 설정을 비활성화한 앱에서 사용합니다. 요청에 성공하면 회원번호가 반환됩니다.
    public func signupForPartner(properties: [String:String]? = nil) -> Single<Int64?> {
        return AUTH_API.rx.responseData(.post, Urls.compose(path:PartnerPaths.signup), parameters: ["properties": properties?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .compose(PARTNER_AUTH_API.rx.checkAgeAuthRetryComposeTransformer())
            .map({ (response, data) -> Int64? in
                if let json = (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String: Any] {
                    return json["id"] as? Int64
                }
                else {
                    return nil
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 연령인증이 필요한 시점(예를 들어, 인증후 90일 초과 시점, 결제전)에 인증여부/정보(인증 방식/제한나이 이상여부/인증날짜/CI값...)를 확인하기 위해 호출합니다.
    /// - parameters:
    ///   - ageLimit: 연령제한 (만 나이 기준)
    ///   - ageCriteria: 응답의 제한 연령 만족 여부(bypassAgeLimit) 계산 기준, ageLimit 파라미터 사용 시 필수
    ///   - propertyKeys: 추가 동의를 필요로 하는 인증 정보를 응답에 포함하고 싶은 경우, 해당 키 리스트
    public func ageAuthInfo(ageLimit: Int? = nil,
                            ageCriteria: AgeCriteria? = nil,
                            propertyKeys: [String]? = nil) -> Single<AgeAuthInfo> {
        return AUTH_API.rx.responseData(.get,
                                        Urls.compose(path:PartnerPaths.ageAuthInfo),
                                        parameters: ["age_limit":ageLimit, "age_criteria":ageCriteria?.rawValue, "property_keys": propertyKeys?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    
    /// 요청한 동의 항목(Scope)을 사용자가 동의한 동의 항목으로 추가합니다.
    /// 사용자로부터 동의를 받는 주체가 공동체이고 명시적인 제3자 제공 동의 화면을 제공하지 않을 경우, 동의 항목 추가하기 API가 아닌 추가 항목 동의 받기 API를 사용할 것을 권장합니다.
    /// 이 API는 권한이 필요하므로 권한: 인하우스 앱 또는 권한: 공동체 앱을 참고합니다.
    /// - parameters:
    ///   - scopes: 추가할 동의 항목 ID 목록
    ///   - guardianToken: 14세 미만 사용자인 경우 필수. 14세 미만 사용자의 동의 항목을 추가하기 위해 필요한 보호자인증 토큰
    public func upgradeScopes(scopes:[String], guardianToken: String? = nil) -> Single<ScopeInfo> {
        return AUTH_API.rx.responseData(.post,
                                    Urls.compose(path:PartnerPaths.userUpgradeScopes),
                                    parameters: ["scopes":scopes.toJsonString(), "guardian_token":guardianToken].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    
    
    ///연령인증을 요청합니다.
    /// ## SeeAlso 
    /// ``signup``
    /// - parameters:
    ///   - authLevel: 연령인증 레벨 (1차 인증 : 실명/생년월일 인증, 2차 인증 : 휴대폰 본인 인증을 통한 통신사 명의자 인증)
    ///   - ageLimit: 연령제한 (만 나이 기준)
    ///   - skipTerms:  동의 화면 출력 여부
    ///   - adultsOnly: 서비스에서 청소년유해매체물 인증 필요 여부
    ///   - authFrom:  요청 서비스 구분
    ///   - underAge:  연령인증 페이지 구분
    public func verifyAge(authLevel: AuthLevel? = nil,
                              ageLimit: Int? = nil,
                              skipTerms: Bool? = false,
                              adultsOnly: Bool? = false,
                              underAge: Bool? = false) -> Completable {
        return AuthController.shared.rx.verifyAgeWithAuthenticationSession(authLevel: authLevel,
                                                                           ageLimit: ageLimit,
                                                                           skipTerms: skipTerms,
                                                                           adultsOnly: adultsOnly,
                                                                           underAge: underAge)
            .ignoreElements()
            .asCompletable()
    }
    
    /// 배송지 추가하기
    public func createShippingAddress() -> Single<Int64> {
        return Observable<Int64>.create { observer in
            UserApi.shared.createShippingAddress() { (addressId, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let addressId = addressId {
                        observer.onNext(addressId)
                        observer.onCompleted()
                    } else {
                        observer.onError(SdkError(reason: .IllegalState))
                    }
                }
            }
            
            return Disposables.create()
        }
        .asSingle()
    }
    
    /// 배송지 수정하기
    /// - parameters:
    ///   - addressId: 배송지 ID
    public func updateShippingAddress(addressId: Int64) -> Single<Int64> {
        return Observable<Int64>.create { observer in
            UserApi.shared.updateShippingAddress(addressId: addressId) { (_addressId, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let _addressId = _addressId {
                        observer.onNext(_addressId)
                        observer.onCompleted()
                    } else {
                        observer.onError(SdkError(reason: .IllegalState))
                    }
                }
            }
            
            return Disposables.create()
        }
        .asSingle()
    }
}
