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

/// 친구 피커 API 호출을 담당하는 클래스입니다.
extension Reactive where Base: PickerApi  {
    /// 여러 명의 친구를 선택(멀티 피커)할 수 있는 친구 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 여러 명의 친구를 선택(멀티 피커)할 수 있는 친구 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 한 명의 친구만 선택(싱글 피커)할 수 있는 친구 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 한 명의 친구만 선택(싱글 피커)할 수 있는 친구 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 채팅방 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerChatRequestParams`
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
    
    /// 채팅방 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerChatRequestParams`
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
    
    /// 친구 피커와 채팅방 피커를 탭 구조로 제공하는 탭 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerTabRequestParams`
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
    
    
    /// 친구 피커와 채팅방 피커를 탭 구조로 제공하는 탭 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerTabRequestParams`
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

