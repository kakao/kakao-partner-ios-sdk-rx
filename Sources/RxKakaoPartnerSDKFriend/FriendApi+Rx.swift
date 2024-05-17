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
    /// 풀 스크린 형태의 멀티 피커 요청 \
    /// Requests a multi-picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriends(params:PickerFriendRequestParams) -> Observable<SelectedUsers> {
        return Observable<SelectedUsers>.create { observer in
            PickerApi.shared.selectFriends(params: params) { (selectedUsers, error) in
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
    
    /// 팝업 형태의 멀티 피커 요청 \
    /// Requests a multi-picker in pop-up view
    /// ## SeeAlso
    /// -  [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriendsPopup(params:PickerFriendRequestParams) -> Observable<SelectedUsers> {
        return Observable<SelectedUsers>.create { observer in
            PickerApi.shared.selectFriendsPopup(params: params) { (selectedUsers, error) in
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
    
    /// 풀 스크린 형태의 싱글 피커 요청 \
    /// Requests a single picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriend(params:PickerFriendRequestParams) -> Observable<SelectedUsers> {
        return Observable<SelectedUsers>.create { observer in
            PickerApi.shared.selectFriend(params: params) { (selectedUsers, error) in
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
    
    /// 팝업 형태의 싱글 피커 요청 \
    /// Requests a single picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriendPopup(params:PickerFriendRequestParams) -> Observable<SelectedUsers> {
        return Observable<SelectedUsers>.create { observer in
            PickerApi.shared.selectFriendPopup(params: params) { (selectedUsers, error) in
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
    
    /// 풀 스크린 형태의 채팅방 피커 요청 \
    /// Requests a chat picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChat(params:PickerChatRequestParams) -> Observable<(SelectedUsers?, SelectedChat?)> {
        return Observable<(SelectedUsers?, SelectedChat?)>.create { observer in
            PickerApi.shared.selectChat(params: params) { (selectedUsers, selectedChat, error) in
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
    
    /// 팝업 형태의 채팅방 피커 요청 \
    /// Requests a chat picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChatPopup(params:PickerChatRequestParams) -> Observable<(SelectedUsers?, SelectedChat?)> {
        return Observable<(SelectedUsers?, SelectedChat?)>.create { observer in
            PickerApi.shared.selectChatPopup(params: params) { (selectedUsers, selectedChat, error) in
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
    
    /// 풀 스크린 형태의 탭 피커 요청 \
    /// Requests a tap picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func select(params:PickerTabRequestParams) -> Observable<(SelectedUsers?, SelectedChat?)> {
        return Observable<(SelectedUsers?, SelectedChat?)>.create { observer in
            PickerApi.shared.select(params: params) { (selectedUsers, selectedChat, error) in
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
    
    
    /// 팝업 형태의 탭 피커 요청 \
    /// Requests a tap picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectPopup(params:PickerTabRequestParams) -> Observable<(SelectedUsers?, SelectedChat?)> {
        return Observable<(SelectedUsers?, SelectedChat?)>.create { observer in
            PickerApi.shared.selectPopup(params: params) { (selectedUsers, selectedChat, error) in
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

