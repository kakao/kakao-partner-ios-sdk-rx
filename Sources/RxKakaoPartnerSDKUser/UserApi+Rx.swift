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


/// [카카오 로그인](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common) API 클래스 \
/// Class for the [Kakao Login](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common) APIs
extension Reactive where Base: UserApi {
    
    // MARK: Login with Kakao Account
    
#if swift(>=5.8)
    @_documentation(visibility: private)
#endif
    public func loginWithKakaoAccount(accountParameters: [String:String]) -> Observable<OAuthToken> {
        return AuthController.shared.rx._authorizeWithAuthenticationSession(accountParameters:accountParameters)
    }
    
    /// 사용자 정보 조회 \
    /// Retrieve user information
    /// - parameters:
    ///   - propertyKeys: 사용자 프로퍼티 키 목록 \
    ///                   List of user property keys to retrieve
    ///   - secureResource: 이미지 URL 값 HTTPS 여부 \
    ///                     Whether to use HTTPS for the image URL
    /// ## SeeAlso 
    /// - [`PartnerUser`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKUser/documentation/kakaopartnersdkuser/partneruser)
    public func meForPartner(propertyKeys: [String]? = nil, secureResource: Bool = true) -> Single<PartnerUser> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userMe), parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 수동 연결 \
    /// Manual signup
    /// - parameters:
    ///   - properties: 사용자 프로퍼티 \
    ///                 User properties
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
    
    /// 연령인증 정보 조회 \
    /// Check age verification information
    /// - parameters:
    ///   - ageLimit: 제한 연령 만족 여부를 판단하는 기준 제한 연령 \
    ///               Age to determine whether the user is satisfied age limit
    ///   - ageCriteria: 제한 연령 만족 여부 계산 기준 \
    ///                  Criteria to determine whether the user meets the age limit
    ///   - propertyKeys: 카카오계정 CI 값 대조가 필요한 경우 사용 \
    ///                   Used to compare CI of Kakao Account
    /// ## SeeAlso
    /// - [`AgeAuthInfo`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKUser/documentation/kakaopartnersdkuser/ageauthinfo)
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
    
    
    /// 동의항목 동의 처리 \
    /// Upgrade scopes
    /// - parameters:
    ///   - scopes: 동의항목 ID 목록 \
    ///             Scope IDs
    ///   - guardianToken: 14세 미만 사용자의 동의항목을 추가하기 위해 필요한 보호자인증 토큰 \
    ///                    Parental authorization token to upgrade scope for the users under 14 years old
    /// ## SeeAlso
    /// - [`ScopeInfo`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKUser/documentation/kakaosdkuser/scopeinfo)
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
    
    
    
    /// 연령인증 페이지 호출 \
    /// Request age verification
    /// - parameters:
    ///   - authLevel: 연령인증 레벨 \
    ///                Age verification level
    ///   - ageLimit: 제한 연령 \
    ///               Age limit
    ///   - skipTerms: 동의 화면 출력 여부 \
    ///                Whether to display the consent screen
    ///   - adultsOnly: 서비스의 청소년유해매체물 인증 필요 여부 \
    ///                 Whether the service requires age verification due to the media harmful to youth
    ///   - underAge: 연령인증 페이지 구분 여부(기본값: `false`) \
    ///               Whether to separate age verification pages (default: `false`)
    /// ## SeeAlso
    ///  - [`signupForPartner`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKUser/documentation/kakaopartnersdkuser/kakaosdkuser/userapi/signupforpartner(properties:completion:))
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
    
    /// 배송지 추가 \
    /// Add Shipping address
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
    
    /// 배송지 수정 \
    /// Update Shipping address
    /// - parameters:
    ///   - addressId: 배송지 ID \
    ///                Shipping address ID
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
