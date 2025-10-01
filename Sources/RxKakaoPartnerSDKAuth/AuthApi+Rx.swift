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
import KakaoPartnerSDKCommon
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoPartnerSDKAuth
import RxKakaoSDKAuth

///[ 카카오 로그인](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common) 인증 및 토큰 관리 클래스 \
///Class for the authentication and token management through [Kakao Login](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common)
extension Reactive where Base: AuthApi  {
    
    /// 인가 코드로 토큰 발급 \
    /// Issues tokens with the authorization code
    /// - parameters:
    ///   - groupRefreshToken: 그룹 앱의 리프레시 토큰 \
    ///                        Refresh token of a group app
    /// ## SeeAlso
    /// - [`OAuthToken`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKAuth/documentation/kakaosdkauth/oauthtoken)
    public func token(groupRefreshToken: String? = nil) -> Single<OAuthToken> {
        return API.rx.responseData(.post,
                                Urls.compose(.Kauth, path:Paths.authToken),
                                parameters: ["grant_type":groupRefreshToken,
                                             "client_id":try! KakaoSDK.shared.appKey(),
                                             "group_refresh_token":groupRefreshToken,
                                             "ios_bundle_id":Bundle.main.bundleIdentifier].filterNil(),
                                sessionType:.RxAuthApi)
            .compose(API.rx.checkKAuthErrorComposeTransformer())
            .map({ (response, data) -> OAuthToken in
                return try SdkJSONDecoder.custom.decode(OAuthToken.self, from: data)
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
            .do(onSuccess: { (oauthToken) in
                AUTH.tokenManager.setToken(oauthToken)
            })
    }
}
