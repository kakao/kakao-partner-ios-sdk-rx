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

import UIKit

import RxSwift
import Alamofire
import RxAlamofire

import KakaoSDKCommon
import RxKakaoSDKCommon

import KakaoSDKAuth
import RxKakaoSDKAuth

import KakaoSDKFriend
import KakaoPartnerSDKFriend

extension PickerApi: ReactiveCompatible {}

/// [피커](https://developers.kakao.com/internal-docs/latest/ko/kakao-social/common) API 클래스 \
/// Class for the [picker](https://developers.kakao.com/internal-docs/latest/ko/kakao-social/common) APIs
extension Reactive where Base: PickerApi  {
    
    /// 친구 피커 \
    /// Friends picker
    /// ## SeeAlso
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriend(params:PickerFriendRequestParams, viewType: ViewType, enableMulti: Bool = true) -> Observable<SelectedUsers> {
        return Observable<SelectedUsers>.create { observer in
            PickerApi.shared.selectFriend(params: params, viewType: viewType, enableMulti: enableMulti) { (selectedUsers, error) in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    if let selectedUsers = selectedUsers {
                        observer.onNext(selectedUsers)
                    }
                    else {
                        observer.onError(SdkError(reason: .Unknown, message: "Unknown Error."))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    /// 채팅방 피커 \
    /// Chat picker
    /// ## SeeAlso 
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChat(params:PickerChatRequestParams, viewType: ViewType, enableMulti: Bool = true) -> Observable<(SelectedUsers?, SelectedChat?)> {
        return Observable<(SelectedUsers?, SelectedChat?)>.create { observer in
            PickerApi.shared.selectChat(params: params, viewType: viewType, enableMulti: enableMulti) { (selectedUsers, selectedChat, error) in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    if selectedUsers == nil && selectedChat == nil {
                        observer.onError(SdkError(reason: .Unknown, message: "Unknown Error."))
                    }
                    else {
                        observer.onNext((selectedUsers, selectedChat))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    
    /// 탭 피커 \
    /// Tap picker
    /// ## SeeAlso
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func select(params:PickerTabRequestParams, viewType: ViewType, enableMulti: Bool = true) -> Observable<(SelectedUsers?, SelectedChat?)> {
        return Observable<(SelectedUsers?, SelectedChat?)>.create { observer in
            PickerApi.shared.select(params: params, viewType: viewType, enableMulti: enableMulti) { (selectedUsers, selectedChat, error) in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    if selectedUsers == nil && selectedChat == nil {
                        observer.onError(SdkError(reason: .Unknown, message: "Unknown Error."))
                    }
                    else {
                        observer.onNext((selectedUsers, selectedChat))
                    }
                }
            }
            return Disposables.create()
        }
    }
}

