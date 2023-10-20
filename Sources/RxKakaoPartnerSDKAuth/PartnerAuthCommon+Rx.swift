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

import KakaoSDKCommon
import RxKakaoSDKCommon

import KakaoSDKAuth
import KakaoPartnerSDKAuth

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
extension PartnerAuthCommon: ReactiveCompatible {}

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
extension Reactive where Base: PartnerAuthCommon   {
    public func checkAgeAuthRetryComposeTransformer() -> ComposeTransformer<(HTTPURLResponse, Data), (HTTPURLResponse, Data)> {
        return ComposeTransformer<(HTTPURLResponse, Data), (HTTPURLResponse, Data)> { (observable) in
            return observable
                .retry(when: {(observableError) -> Observable<Void> in
                    return observableError.flatMap { (error) -> Observable<Void> in
                        
                        guard error is SdkError else { throw error }
                        let sdkError = try SdkUtils.castOrThrow(SdkError.self, error)
                        
                        if !sdkError.isApiFailed { throw sdkError }
                        
                        switch(sdkError.getApiError().reason) {
                        case .RequiredAgeVerification:
                            return AuthController.shared.rx.verifyAgeWithAuthenticationSession()
                            
                        case .UnderAgeLimit:
                            throw sdkError
                        default:
                            throw sdkError
                        }
                    }
                })
            }
    }

}
