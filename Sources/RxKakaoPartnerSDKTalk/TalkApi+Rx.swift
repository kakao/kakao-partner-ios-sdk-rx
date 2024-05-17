//
//  TalkApi+Rx.swift
//  KakaoPartnerSDK
//
//  Created by apiteam on 5/9/2019.
//  Copyright © 2019 apiteam. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

import KakaoPartnerSDKCommon

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKTalk
import RxKakaoSDKTalk
import KakaoSDKTemplate

import KakaoPartnerSDKTalk

/// [카카오톡 채널](https://developers.kakao.com/internal-docs/latest/ko/kakaotalk-channel/common), [카카오톡 소셜](https://developers.kakao.com/internal-docs/latest/ko/kakao-social/common), [카카오톡 메시지](https://developers.kakao.com/internal-docs/latest/ko/kakaotalk-message/common) API 클래스 \
/// Class for the [Kakao Talk Channel](https://developers.kakao.com/internal-docs/latest/ko/kakaotalk-channel/common), [Kakao Talk Social](https://developers.kakao.com/internal-docs/latest/ko/kakao-social/common), [Kakao Talk Message](https://developers.kakao.com/internal-docs/latest/ko/kakaotalk-message/common) APIs
extension Reactive where Base: TalkApi  {
        
    /// 채팅방 목록 가져오기 \
    /// Retrieve list of chats
    /// - parameters:
    ///   - filters: 필터링 설정 \
    ///              Filtering options
    ///   - offset: 채팅방 목록 시작 지점 \
    ///             Start point of the chat list
    ///   - limit: 페이지당 결과 수 \
    ///            Number of results in a page
    ///   - order: 정렬 방식 \
    ///            Sorting method
    /// ## SeeAlso 
    /// - [`Chats`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/chats)
    public func chatList(filters: [ChatFilter]? = nil,
                         offset: Int? = nil,
                         limit: Int? = nil,
                         order: Order? = nil) -> Single<Chats> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:PartnerPaths.chatList),
                                        parameters: ["filter": filters?.map({ $0.parameterValue }).joined(separator: ","),
                                                     "offset": offset,
                                                     "limit": limit,
                                                     "order": order?.rawValue].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 채팅방 멤버 가져오기 \
    /// Retrieve list if chat members
    /// - parameters:
    ///   - chatId: 채팅방 ID \
    ///             Chat ID
    ///   - friendsOnly: 카카오톡 친구 여부 필터링 설정 \
    ///                  Whether to retrieve only friends
    ///   - includeProfile: 멤버 프로필 포함 여부 \
    ///                     Whether to retrieve the profile
    ///   - token: 요청에 대한 토큰 정보 \
    ///            Token for the request
    /// ## SeeAlso 
    /// - [`ChatMembers`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/chatmembers)
    public func chatMembers(chatId:Int64,
                            friendsOnly:Bool,
                            includeProfile: Bool? = nil,
                            token: String? = nil) -> Single<ChatMembers> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:PartnerPaths.chatMembers),
                                        parameters: ["chat_id":chatId,
                                                     "friends_only": friendsOnly,
                                                     "include_profile": includeProfile,                                                     
                                                     "token": token].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 기본 템플릿으로 메시지 보내기 \
    /// Send message with default template
    /// - parameters:
    ///    - templatable: 메시지 템플릿 객체 \
    ///                   An object of a message template
    ///    - receiverIdType: 수신자 ID 타입 \
    ///                      Type of receiver IDs
    ///    - receiverUuids: 수신자 UUID \
    ///                     Receiver UUIDs
    /// ## SeeAlso
    /// - [`Templatable`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKTemplate/documentation/kakaosdktemplate/templatable)
    /// - [`PartnerMessageSendResult`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnermessagesendresult)
    public func sendDefaultMessageForPartner(templatable:Templatable, receiverUuids:[String]) -> Single<PartnerMessageSendResult> {
        return AUTH_API.rx.responseData(.post,
                                        Urls.compose(path:PartnerPaths.defaultMessage),
                                        parameters: ["receiver_id_type":"uuid",
                                                     "template_object":templatable.toJsonObject()?.toJsonString(),
                                                     "receiver_ids":receiverUuids.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 기본 템플릿으로 메시지 보내기 \
    /// Send message with default template
    /// - parameters:
    ///    - templatable: 메시지 템플릿 객체 \
    ///                   An object of a message template
    ///    - receiverChatIds: 채팅방 ID 목록 \
    ///                       List of chat IDs
    /// ## SeeAlso
    /// - [`PartnerMessageSendResult`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnermessagesendresult)
    public func sendDefaultMessageForPartner(templatable:Templatable, receiverChatIds:[Int64]) -> Single<PartnerMessageSendResult> {
        return AUTH_API.rx.responseData(.post,
                                        Urls.compose(path:PartnerPaths.defaultMessage),
                                        parameters: ["receiver_id_type":"chat_id",
                                                     "template_object":templatable.toJsonObject()?.toJsonString(),
                                                     "receiver_ids":receiverChatIds.map({ (chatId) -> String in return "\(chatId)" }).toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 사용자 정의 템플릿으로 메시지 보내기 \
    /// Send message with custom template
    /// - parameters:
    ///    - templateId: 메시지 템플릿 ID \
    ///                  Message template ID
    ///    - templateArgs: 사용자 인자 \
    ///                    User arguments
    ///    - receiverUuids: 수신자 UUID \
    ///                     Receiver UUIDs
    /// ## SeeAlso
    /// - [`PartnerMessageSendResult`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnermessagesendresult)
    public func sendCustomMessageForPartner(templateId: Int64, templateArgs:[String:Any]? = nil, receiverUuids:[String]) -> Single<PartnerMessageSendResult> {
        return AUTH_API.rx.responseData(.post,
                                        Urls.compose(path:PartnerPaths.customMessage),
                                        parameters: ["receiver_id_type":"uuid",
                                                       "receiver_ids":receiverUuids.toJsonString(),
                                                       "template_id":templateId,
                                                       "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 사용자 정의 템플릿으로 메시지 보내기 \
    /// Send message with custom template
    /// - parameters:
    ///    - templateId: 메시지 템플릿 ID \
    ///                  Message template ID
    ///    - templateArgs: 사용자 인자 \
    ///                    User arguments
    ///    - receiverChatIds: 채팅방 ID 목록 \
    ///                       List of chat IDs
    /// ## SeeAlso
    /// - [`PartnerMessageSendResult`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnermessagesendresult)
    public func sendCustomMessageForPartner(templateId: Int64, templateArgs:[String:Any]? = nil, receiverChatIds:[Int64]) -> Single<PartnerMessageSendResult> {
        return AUTH_API.rx.responseData(.post,
                                        Urls.compose(path:PartnerPaths.customMessage),
                                        parameters: ["receiver_id_type":"chat_id",
                                                       "receiver_ids":receiverChatIds.map({ (chatId) -> String in return "\(chatId)" }).toJsonString(),
                                                       "template_id":templateId,
                                                       "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 스크랩 메시지 보내기 \
    /// Send scrape message
    /// - parameters:
    ///    - requestUrl: 스크랩할 URL \
    ///                   URL to scrape
    ///    - templateId: 메시지 템플릿 ID \
    ///                  Message template ID
    ///    - templateArgs: 사용자 인자 \
    ///                    User arguments
    ///    - receiverUuids: 수신자 UUID \
    ///                     Receiver UUIDs
    /// ## SeeAlso
    /// - [`PartnerMessageSendResult`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnermessagesendresult)
    public func sendScrapMessageForPartner(requestUrl: String, templateId: Int64? = nil, templateArgs:[String:Any]? = nil, receiverUuids:[String]) -> Single<PartnerMessageSendResult> {
        return AUTH_API.rx.responseData(.post,
                                        Urls.compose(path:PartnerPaths.scrapMessage),
                                        parameters: ["receiver_id_type":"uuid",
                                                      "receiver_ids":receiverUuids.toJsonString(),
                                                      "request_url": requestUrl,
                                                      "template_id":templateId,
                                                      "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 스크랩 메시지 보내기 \
    /// Send scrape message
    /// - parameters:
    ///    - requestUrl: 스크랩할 URL \
    ///                   URL to scrape
    ///    - templateId: 메시지 템플릿 ID \
    ///                  Message template ID
    ///    - templateArgs: 사용자 인자 \
    ///                    User arguments
    ///    - receiverChatIds: 채팅방 ID 목록 \
    ///                       List of chat IDs
    /// ## SeeAlso
    /// - [`PartnerMessageSendResult`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnermessagesendresult)
    public func sendScrapMessageForPartner(requestUrl: String, templateId: Int64? = nil, templateArgs:[String:Any]? = nil, receiverChatIds:[Int64]) -> Single<PartnerMessageSendResult> {
        return AUTH_API.rx.responseData(.post,
                                        Urls.compose(path:PartnerPaths.scrapMessage),
                                        parameters: ["receiver_id_type":"chat_id",
                                                      "receiver_ids":receiverChatIds.map({ (chatId) -> String in return "\(chatId)" }).toJsonString(),
                                                      "request_url": requestUrl,
                                                      "template_id":templateId,
                                                      "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 친구 목록 가져오기 \
    /// Retrieve list of friends
    /// - parameters:
    ///   - friendFilter: 친구 목록 필터링 설정 \
    ///                   Filtering options for the friend list
    ///   - friendOrder: 친구 정렬 방식 \
    ///                  Method to sort the friend list
    ///   - offset: 친구 목록 시작 지점 \
    ///             Start point of the friend list
    ///   - limit: 페이지당 결과 수 \
    ///            Number of results in a page
    ///   - order: 정렬 방식 \
    ///            Sorting method
    ///   - countryCodes: 국가 코드 필터링 설정 \
    ///                   Options for filtering by country codes
    /// ## SeeAlso 
    /// - [`PartnerFriend`](https://developers.kakao.com/sdk/reference/ios-partner/release/KakaoPartnerSDKTalk/documentation/kakaopartnersdktalk/partnerfriend)
    public func friendsForPartner(friendFilter: FriendFilter? = nil,
                                  friendOrder: FriendOrder? = nil,
                                  offset: Int? = nil,
                                  limit: Int? = nil,
                                  order: Order? = nil,
                                  countryCodes: [String]? = nil
                                  ) -> Single<Friends<PartnerFriend>> {
        return AUTH_API.rx.responseData(.get,
                                        Urls.compose(path:PartnerPaths.friends),
                                        parameters: ["friend_filter":friendFilter?.rawValue,
                                                      "friend_order": friendOrder?.rawValue,
                                                      "offset":offset,
                                                      "limit":limit,
                                                      "order":order?.rawValue,
                                                      "country_codes":countryCodes?.joined(separator:",")].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }

}
