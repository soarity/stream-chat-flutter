## 9.15.0

✅ Added

- Added `avgResponseTime` field to the `User` model to track average response time in seconds.
- Added support for `skipPush` while updating a channel message, which allows you to update a
  message without sending a push notification.

🐞 Fixed

- Fixed `WebSocket` race condition where reconnection could access null user during disconnect.
- Fixed draft message persistence issues where removed drafts were not properly deleted from the
  database.

## 9.14.0

🐞 Fixed

- Fixed cached messages are cleared from channels with unread messages when accessed
  offline. [[#2083]](https://github.com/GetStream/stream-chat-flutter/issues/2083)
- Fixed RetryQueue skipping messages due to premature removal from the
  queue. [[#2308]](https://github.com/GetStream/stream-chat-flutter/pull/2308)

✅ Added

- Added support for `client.getUnreadCount()`, which returns the unread count information for the
  current user.

🔄 Changed

- Deprecated `SortOption.new` constructor in favor of `SortOption.desc` and `SortOption.asc`.

## 9.13.0

- Bug fixes and improvements

## 9.12.0

✅ Added

- Added support for `MessageReminder` feature, which allows users to bookmark or set reminders
  for specific messages in a channel.

## 9.11.0

✅ Added

- Added `reactionGroups` to the `Message` model. This field is a map of reaction types to their
  respective counts and scores and additional metadata such as the first and last reaction
  timestamps.

🔄 Changed

- Deprecated `message.reactionCounts`, `message.reactionScores` in favor of
  `message.reactionGroups`.

🐞 Fixed
- `Null check operator used on a null value` in Websocket connect.
- Ensure query cache is cleared when refreshing channel queries.

## 9.10.0

🐞 Fixed

- [[#2013]](https://github.com/GetStream/stream-chat-flutter/issues/2013) Fix pinned message get duplicated.

🔄 Changed

- Updated `freezed_annotation` dependency to `">=2.4.1 <4.0.0"`.

## 9.9.0

✅ Added

- Added teams role support for users.
- Added support for Filtering and Sorting in the `client.queryThreads` method.

## 9.8.0

✅ Added

- Added support for Channel pinning and archiving.
- Added support for 'DraftMessage' feature, which allows users to save draft messages in channels.
  Several methods have been added to the `Client` and `Channel` class to manage draft messages:
    - `channel.createDraft`: Saves a draft message for a specific channel.
    - `channel.getDraft`: Retrieves a draft message for a specific channel.
    - `channel.deleteDraft`: Deletes a draft message for a specific channel.
    - `client.queryDrafts`: Queries draft messages created by the current user.

🐞 Fixed

- Fixed `channelState.unreadCount` not updating if the user is not part of the read list.

🔄 Changed

- Improved read event handling in the `Channel` class to properly update unread state information.

## 9.7.0

✅ Added

- Added new helper extensions on `Channel` to provide a convenient way to check if the current user
  has specific capabilities in a channel.

  ```dart
  final canSendMessage = channel.canSendMessage;
  final canSendReaction = channel.canSendReaction;
  ```

- Added support for message moderation feature.

- Improved user blocking functionality by updating client state when blocking/unblocking users:
  - `client.blockUser` now updates `currentUser.blockedUserIds` list with newly blocked user IDs.
  - `client.unblockUser` now removes the unblocked user ID from `currentUser.blockedUserIds` list.
  - `client.queryBlockedUsers` now updates `currentUser.blockedUserIds` with the latest blocked users data.

🐞 Fixed

- [[#1964]](https://github.com/GetStream/stream-chat-flutter/issues/1964) Fixes `Channel.membership`
  field not updating correctly.
- [[#2171]](https://github.com/GetStream/stream-chat-flutter/issues/2171) Fixed [Flutter Web]
  dynamic TypeError

🔄 Changed

- Deprecated `PermissionType` in favor of `ChannelCapability`.
- Deprecated third party calls related APIs (Agora and 100ms).

## 9.6.0

🐞 Fixed

- [[#1775]](https://github.com/GetStream/stream-chat-flutter/issues/1775) Fix incorrect message order.

## 9.5.0

✅ Added

- [[#2101]](https://github.com/GetStream/stream-chat-flutter/issues/2101) Added support for system messages not updating `channel.lastMessageAt`.
- Added support for sending private or restricted visibility messages.
- Add `member.extraData` field.

🐞 Fixed

- [[#1774]](https://github.com/GetStream/stream-chat-flutter/issues/1774) Fixed failed to execute 'close' on 'WebSocket'.
- [[#2016]](https://github.com/GetStream/stream-chat-flutter/issues/2016) Fix muted channel's unreadCount incorrectly updated.
  
🔄 Changed

- Refactored identifying the `Attachment.uploadState` logic for local and remote attachments. Also updated the logic for determining the attachment type to check for ogScrapeUrl instead of `AttachmentType.giphy`.
- Improved the `x-stream-client` header generation for better client identification and analytics.

## 9.4.0

🔄 Changed

- Updated minimum Flutter version to 3.27.4 for the SDK.

## 9.3.0

✅ Added

- Added support for overriding the `baseUrl` of the websocket.

  ```dart
  final client = StreamChatClient(
    apiKey,
    logLevel: Level.INFO,
    baseWsUrl: 'http://localhost:8080',
  );
  ```

## 9.2.0

- Bug fixes and improvements

## 9.1.0

✅ Added

- Added support for Threads v2 feature, which allows users to query all the threads.

## 9.0.0

✅ Added

- Added support for Polls feature, which allows users to create and vote on polls in chat messages.

🔄 Changed

- Updated minimum Dart version to 3.5.4 for the SDK.

## 8.3.0

✅ Added

- Added support for AI assistant states and events.

## 8.2.0

✅ Added

- Added user blocking to the client.

## 8.1.0

✅ Added

- Added `httpClientAdapter` to `StreamHttpClient` that enables the use native http implementations

🔄 Changed

- Changed minimum Flutter version to 3.22 for the SDK.

## 8.0.0

🐞 Fixed

- Fixed incorrect user object and online presence when user is updated.

## 7.3.0

🔄 Changed

- Changed minimum Flutter version to 3.19 for the SDK.

## 7.2.2

- Version to keep in sync with the rest of the packages

## 7.2.1

✅ Added

- Added `voiceRecording` attachment type

## 7.2.0-hotfix.1

- Version to keep in sync with the rest of the packages

## 7.2.0

✅ Added

- Added `markUnread` method to `Channel` that marks messages from the provided message id onwards as
  unread

## 7.1.0

🐞 Fixed

- Fixes a thread message causing reply messages on the main thread to be considered deleted

## 7.0.2

🐞 Fixed

- [[#1837]](https://github.com/GetStream/stream-chat-flutter/issues/1837) Delete image and file 
  attachments from the CDN, when the message get's hard deleted.
- [[#1819]](https://github.com/GetStream/stream-chat-flutter/issues/1819) Handle network errors
  with String payload.

## 7.0.1

🐞 Fixed

- [[#1811]](https://github.com/GetStream/stream-chat-flutter/issues/1811) Bumped `UUID` dependency to `^4.2.1`. This
  **might** produce a **breaking change** if you your code depends in `UUID` `3.x.x` directly or indirectly.

## 7.0.0

- 🛑️ Breaking

- Removed deprecated `channelQuery.sort` property. Use `channelStateSort` instead.
- Removed deprecated `RetryPolicy.retryTimeout` property. Use `delayFactor` instead.
- Removed deprecated `StreamChatNetworkError.fromDioError` constructor. Use `StreamChatNetworkError.fromDioException`
  instead.
- Removed deprecated `MessageSendingStatus` enum. Use `MessageState` instead.

🔄 Changed

- Updated minimum supported `SDK` version to Flutter 3.13/Dart 3.1
  
# 6.10.0

🐞 Fixed

- [[#1753]](https://github.com/GetStream/stream-chat-flutter/issues/1753) Fixed Unhandled null 
  check operator exception when user is removed from a channel.

## 6.9.0

🐞 Fixed

- [[#1716]](https://github.com/GetStream/stream-chat-flutter/issues/1716) Fixed client not able to
  update message with `type: reply`.
- [[#1724]](https://github.com/GetStream/stream-chat-flutter/issues/1724) Fixed sendFile error
  on `AttachmentFile` with `bytes` and no `name`.

## 6.8.0

🐞 Fixed

- Fixed `Channel.query` not initializing `ChannelState`.

✅ Added

- Added support for `channel.countUnreadMentions()` to get the count of unread messages mentioning the current user on a
  channel. [#1692](https://github.com/GetStream/stream-chat-flutter/issues/1692)

🔄 Changed

- Updated minimum supported `SDK` version to Dart 3.0

## 6.7.0

✅ Added

- Added support for setting `Message.type`. [#1682](https://github.com/GetStream/stream-chat-flutter/issues/1682)
  ```
  It is now possible to send system messages. System messages differ from normal messages in the way they are
  presented to the user. Like the name says, system messages are normally send from the system itself, but a user is
  able to send it as well by specifying type: 'system' with the message. The user who sends a system message client-side
  should have the Create System Message permission. Server-side system messages don't need that permission.
  ```

## 6.6.0

🔄 Changed

- Deprecated `Message.status` in favor of `Message.state`.
- Deprecated `RetryPolicy.retryTimeout` in favor of `RetryPolicy.delayFactor`.

## 6.5.0

🔄 Changed

- Updated minimum supported `SDK` version to Dart 2.19

## 6.4.0

🐞 Fixed

- [[#1293]](https://github.com/GetStream/stream-chat-flutter/issues/1293) Fixed wrong message order when sending
  messages quickly.
- [[#1612]](https://github.com/GetStream/stream-chat-flutter/issues/1612) Fixed `Channel.isMutedStream` does not emit
  when channel mute expires.

## 6.3.0

🐞 Fixed

- [[#1585]](https://github.com/GetStream/stream-chat-flutter/issues/1585) Fixed channels left not being removed from
  the persistent storage.

🔄 Changed

- Updated `dio` dependency to `^5.2.0`.

## 6.2.0

🐞 Fixed

- [[#1422]](https://github.com/GetStream/stream-chat-flutter/issues/1422) Fixed `User.createdAt` property using
  currentTime when the ws connection is not established.

✅ Added

- Added support for `ChatPersistenceClient.isConnected` for checking if the client is connected to the database.
- Added support for `ChatPersistenceClient.userId` for getting the current connected user id.
- Added two new methods `ChatPersistenceClient.disconnect` and `ChatPersistenceClient.connect` for disconnecting and
  connecting to the database.

## 6.1.0

🐞 Fixed

- [[#1355]](https://github.com/GetStream/stream-chat-flutter/issues/1355) Fixed error while hiding channel and clearing
  message history.
- [[#1525]](https://github.com/GetStream/stream-chat-flutter/issues/1525) Fixed removing message not removing quoted
  message reference.

✅ Added

- Expose `ChannelMute` class. [#1473](https://github.com/GetStream/stream-chat-flutter/issues/1473)
- Added synchronization to the `StreamChatClient.sync`
  api. [#1392](https://github.com/GetStream/stream-chat-flutter/issues/1392)
- Added support for `StreamChatClient.chatApiInterceptors` to add custom interceptors to the API client.
  [#1265](https://github.com/GetStream/stream-chat-flutter/issues/1265).

  ```dart
    final client = StreamChatClient(
      chatApiInterceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before request is sent.
            return handler.next(options);
          },
          onResponse: (response, handler) {
            // Do something with response data
            return handler.next(response);
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return handler.next(e);
          },
        ),
      ],
  );
  ```

🔄 Changed

- Updated `dart` sdk environment range to support `3.0.0`.

## 6.0.0

🐞 Fixed

- Fixed streamWatchers. Before it was always new, now it is possible to follow the watchers of a channel.
- Make `Message.i18n` field read-only.

🔄 Changed

- Cancelling a attachment upload now removes the attachment from the message.
- Updated `dio` and other dependencies to resolvable versions.

✅ Added

- Added `presence` property to `Channel::watch` method.

## 5.3.0

🔄 Changed

- Updated `rate_limiter` dependency to `^1.0.0`

## 5.2.0

✅ Added

- Added `Huawei` and `Xiaomi` PushProviders.

🐞 Fixed

- Fixed initializing last synced date.

## 5.1.0

✅ Added

- Added `thumbUrl` field in `SendFileResponse` model.

🐞 Fixed

- Remove disposed channel clients from the client state.

- Deprecated the `sort` parameter in `queryChannels` in favor of `channelStateSort`.

## 5.0.0

- Included the changes from version [4.5.0](#450).

🛑️ Breaking Changes from `5.0.0-beta.2`

- `Channel.addMembers`, `Channel.removeMembers`, `Channel.inviteMembers` and `Channel.update`
  positional parameters are now optional parameters.

  ```dart
    // previous
    channel.addMembers([...ids], message, hideHistory);
    channel.removeMembers([...ids], message);
    channel.inviteMembers([...ids], message);
    channel.update({...channelData}, updateMessage);
  
    // new
    channel.addMembers([...ids], message: ..., hideHistory: ...);
    channel.removeMembers([...ids], message: ...);
    channel.inviteMembers([...ids], message: ...);
    channel.update({...channelData}, updateMessage: ...);
    ```

## 5.0.0-beta.2

- Included the changes from version [4.4.0](#440) and [4.4.1](#441).

## 5.0.0-beta.1

- Minor fixes.
- Removed deprecated code.

## 4.6.0

✅ Added

- Added `StreamChatClient.getCallToken` and `StreamChatClient.createCall` methods.

🐞 Fixed

- Only listen to client events when the user is connected to the websocket.

## 4.5.0

🐞 Fixed

- Fix `Channel.removeMessage` not able to remove thread message.

✅ Added

- Added `hide_history` flag in `client.addChannelMembers`, `channel.addMembers`.

## 4.4.1

🐞 Fixed

- Do not serialize `AttachmentFile.bytes`

## 4.4.0

🐞 Fixed

- Fix WebSocket contemporary connection calls while disconnecting

✅ Added

- Export `StreamAttachmentFileUploader`.

🔄 Changed

- Deprecated `StreamChatClient.attachmentFileUploader`,
  Use `StreamChatClient.attachmentFileUploaderProvider` instead.

## 4.3.0

🐞 Fixed

- [[#1135]](https://github.com/GetStream/stream-chat-flutter/issues/1135) Persistence was not
  removing the hidden channels.
- Fix `x-stream-client` header generation.

## 4.2.0

✅ Added

- Added `PaginationParams.createdAtAfterOrEqual` for message pagination.
- Added `PaginationParams.createdAtAfter` for message pagination.
- Added `PaginationParams.createdAtBeforeOrEqual` for message pagination.
- Added `PaginationParams.createdAtBefore` for message pagination.
- Added `PaginationParams.createdAtAround` for message pagination.
- Added support for `channel.disabled`, `channel.hidden` and `channel.truncatedAt` in `Channel`.
- Added support for `channel.membership` and `channel.membershipStream` in `Channel`.
- `Channel` now listens for `member.updated` events and updates the `Channel.members` accordingly.

🔄 Changed

- Deprecated `PaginationParams.before` and `PaginationParams.after`. Use `PaginationParams.limit`
  instead.

🐞 Fixed

- [[#1147]](https://github.com/GetStream/stream-chat-flutter/issues/1147) `channel.unset` not
  updating the extra data stream.

## 4.1.0

✅ Added

- Added support for extra data in attachment file uploader.
  Thanks, [@rlee1990](https://github.com/rlee1990).

🔄 Changed

- Deprecated `role` in `Member` in favor of `channelRole`
- Deprecated `currentUserRole` getter in `Channel` in favor of `currentUserChannelRole`

## 4.0.1

- Minor fixes

## 4.0.0

For upgrading to V4, please refer to
the [V4 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration_guide_4_0/)

✅ Added

- Added `push_provider_name` to `addDevice` API call

## 4.0.0-beta.2

🐞 Fixed

- Fixed reactions not working for threads in offline mode.
- [[#1046]](https://github.com/GetStream/stream-chat-flutter/issues/1046) After `/mute` command on
  reload cannot access any channel.
- [[#1047]](https://github.com/GetStream/stream-chat-flutter/issues/1047) `own_capabilities`
  extraData missing after channel update.
- [[#1054]](https://github.com/GetStream/stream-chat-flutter/issues/1054)
  Fix `Unsupported operation: Cannot remove from an unmodifiable list`.
- [[#1033]](https://github.com/GetStream/stream-chat-flutter/issues/1033) Hard delete from dashboard
  does not delete message from client.
- Send only `user_id` while reconnecting.

✅ Added

- Handle `event.message` in `channel.truncate` events
- Added additional parameters to `channel.truncate`

## 4.0.0-beta.0

✅ Added

- Added support for ownCapabilities.

🐞 Fixed

- Minor fixes and improvements.

## 3.6.1

🐞 Fixed

- [[#1081]](https://github.com/GetStream/stream-chat-flutter/issues/1081) Fixed a bug with user
  reconnection.

## 3.6.0

🐞 Fixed

- Fixed reactions not working for threads in offline mode.
- [[#1046]](https://github.com/GetStream/stream-chat-flutter/issues/1046) After `/mute` command on
  reload cannot access any channel.
- [[#1047]](https://github.com/GetStream/stream-chat-flutter/issues/1047) `own_capabilities`
  extraData missing after channel update.
- [[#1054]](https://github.com/GetStream/stream-chat-flutter/issues/1054)
  Fix `Unsupported operation: Cannot remove from an unmodifiable list`.
- [[#1033]](https://github.com/GetStream/stream-chat-flutter/issues/1033) Hard delete from dashboard
  does not delete message from client.
- Send only `user_id` while reconnecting.

✅ Added

- Handle `event.message` in `channel.truncate` events
- Added additional parameters to `channel.truncate`

## 3.5.1

🐞 Fixed

- `channel.unreadCount` was being set as using global unread count on a very specific case.
- The reconnection logic for the WebSocket connection is now more robust.

## 3.5.0

✅ Added

- You can now pass `score` to `client.sendReaction` and `channel.sendReaction` functions.
- Added new `client.partialUpdateUsers` function in order to partially update users.

🐞 Fixed

- [[#890]](https://github.com/GetStream/stream-chat-flutter/pull/890) Fixed Reactions not updating
  on thread messages. Thanks [bstolinski](https://github.com/bstolinski).
- [[#897]](https://github.com/GetStream/stream-chat-flutter/issues/897) Fixed error type mis-match
  in `AuthInterceptor`.
- [[#891]](https://github.com/GetStream/stream-chat-flutter/pull/891) Fixed reply counter for parent
  message not updating correctly after deleting thread message.
- Fix `channelState.copyWith` with respect to pinnedMessages.

## 3.4.0

🐞 Fixed

- [[#857]](https://github.com/GetStream/stream-chat-flutter/issues/857) Channel now listens for
  member ban/unban and updates the channel state with the latest data.
- [[#748]](https://github.com/GetStream/stream-chat-flutter/issues/748) `Message.user` is now also
  included while saving users in persistence.
- [[#871]](https://github.com/GetStream/stream-chat-flutter/issues/871) Fixed thread message
  deletion.
- [[#846]](https://github.com/GetStream/stream-chat-flutter/issues/846) Fixed `message.ownReactions`
  getting truncated when receiving a reaction event.
- Add check for invalid image URLs
- Fix `channelState.pinnedMessagesStream` getting reset to `0` after a channel update.
- Fixed `unreadCount` after removing user from a channel.

🔄 Changed

- `client.location` is now deprecated in favor of the
  new [edge server](https://getstream.io/blog/chat-edge-infrastructure) and will be removed in
  v4.0.0.
- `channel.banUser`, `channel.unbanUser` is now deprecated in favor of the new `channel.banMember`
  and `channel.unbanMember`. These deprecated methods will be removed in v4.0.0.
- Added `banExpires` property of type `DateTime` on the `Member`, `OwnUser`, and `User` models.

✅ Added

- Added `client.enrichUrl` endpoint for enriching URLs with metadata.
- Added `client.queryBannedUsers`, `channel.queryBannedUsers` endpoint for querying banned users.

## 3.3.1

🐞 Fixed

- [[#799]](https://github.com/GetStream/stream-chat-flutter/issues/799) Fixed `totalUnreadCount` is
  not updating when app is resumed from background mode.
- Fix retry mechanism failing in some cases.

## 3.3.0

✅ Added

- Extra properties added to `PaginationParams` to aid in fetching messages.
- Added hard delete functionality.

🐞 Fixed

- `closeConnection()` now uses `normalClosure` status when closing websocket.
- Fixed local unread count indicator increasing for thread replies.
- Fixed user presence indicator not updating correctly.
- `ChannelEvent.membersCount` defaults to 0 avoiding parsing errors due to missing `members_count`
  field.

## 3.2.1

🐞 Fixed

- Fixed `StreamChatClient.markAllRead` api call

## 3.2.0

🐞 Fixed

- `markAllRead()` now updates local channel states.
- [[#744]](https://github.com/GetStream/stream-chat-flutter/issues/744) Fixed unread count not
  updating correctly

## 3.1.1

✅ Added

- Added `Filter.notExists`.

🐞 Fixed

- [[#710]](https://github.com/GetStream/stream-chat-flutter/issues/710) Fixed JWT requiring
  using `String` as id.
- Fixed expired CDN attachment links not updating correctly.

## 3.0.0

🛑️ Breaking Changes from `2.2.1`

- Added 6 new methods in `ChatPersistenceClient`.
    - `bulkUpdateMessages`
    - `bulkUpdatePinnedMessages`
    - `bulkUpdateMembers`
    - `bulkUpdateReads`
    - `updatePinnedMessageReactions`
    - `deletePinnedMessageReactionsByMessageId`

✅ Added

- Added `Filter.contains` and `Filter.empty`
- Added support for `next`, `previous` value pagination in `client.search`
  , [read more.](https://getstream.io/chat/docs/other-rest/search/#pagination)
- `Attachment` class now has a `fileSize` and `mimeType` property. Setting a `file` will also set
  the `file_size`
  , `mime_type` key on `extraData`, so `attachment.fileSize`, `attachment.mimetype`
  and `attachment.extraData['file_size']`
  , `attachment.extraData['mime_type]` is same respectively.

🐞 Fixed

- [[#659]](https://github.com/GetStream/stream-chat-flutter/issues/659) Fixed unread count not
  updating correctly.
- Fix `Filter.empty()` json encoding.
- [[#700]](https://github.com/GetStream/stream-chat-flutter/issues/700) Connecting user without
  providing `name`
  uses `id` instead for setting `user.name`.

## 2.2.1

🐞 Fixed

- Fixed unread indicator not updating correctly
- Fix `channel.show` not working because of null body

## 2.2.0

🐞 Fixed

- Fixed `channel.markAllRead` throwing failed host lookup.

✅ Added

- `User` and `OwnUser` classes now have an `image` property. Setting an image will also set the '
  image' key on `extraData`, so `user.image` and `user.extraData['image']` is the same.
- `User` and `OwnUser` classes now have a `name` property. Setting a name will also set the 'name'
  key on `extraData`, so `user.name` and `user.extraData['name']` is the same.
- `Channel` class now has extra `image` getter and setter. As well as an `updateImage` to do a
  partial update after a channel has been initialized.
- `Channel` class now has extra `name` getter and setter. As well as an `updateName` to do a partial
  update after a channel has been initialized.
- Added slow mode which allows a cooldown period after a user sends a message.

## 2.1.1

🐞 Fixed

- Mutes were not working correctly in 2.1.0

## 2.1.0

🛑️ Removed

- The `MessageTranslation` class has been removed. Use the new `i18n` field in the `Message` class
  instead.

✅ Added

- The `Message` class now has an `i18n` field for translations
- The `User` class now has a `language` field for the user's language preference.

🔄 Changed

- `client.user` is now deprecated in favor of `client.currentUser`.
- `client.userStream` is now deprecated in favor of `client.currentUserStream`.

🐞 Fixed

- [#563](https://github.com/GetStream/stream-chat-flutter/issues/563): `Channel.stopWatching()` not
  working
- [#575](https://github.com/GetStream/stream-chat-flutter/issues/575): Wrong `OwnUser.*`

## 2.0.0

🛑️ Breaking Changes from `1.5.3`

- migrate this package to null safety
- `ConnectUserWithProvider` now requires `tokenProvider` as a required parameter. (Removed from the
  constructor)
- `client.disconnect()` is now divided into two different functions
    - `client.closeConnection()` -> for closing user web socket connection.
    - `client.disconnectUser()` -> for disconnecting user and resetting client state.
- `client.devToken()` now returns a `Token` model instead of `String`.
- `ApiError` is removed in favor of `StreamChatError`
    - `StreamChatError` -> parent type for all the stream errors.
    - `StreamWebSocketError` -> for user web socket related errors.
    - `StreamChatNetworkError` -> for network related errors.
- `client.queryChannels()`, `channel.query()` options parameter is removed in favor of individual parameters
    - `option.state` -> bool state
    - `option.watch` -> bool watch
    - `option.presence` -> bool presence
- `client.queryUsers()` options parameter is removed in favor of individual parameters
    - `option.presence` -> bool presence
- Migrate this package to null safety
- Added typed filters

🐞 Fixed

- [#369](https://github.com/GetStream/stream-chat-flutter/issues/369): Client does not return
  without internet connection
- several minor fixes
- performance improvements

✅ Added

- New `Location` enum is introduced for easily changing the client location/baseUrl.
- New `client.openConnection()` and `client.closeConnection()` is introduced to connect/disconnect
  user ws connection.
- New `client.partialUpdateMessage` and `channel.partialUpdateMessage` methods
- `connectWebSocket` parameter in connect user calls to use the client in "connection-less" mode.

🔄 Changed

- `baseURL` is now deprecated in favor of using `Location` to change data location.

## 2.0.0-nullsafety.8

🐞 Fixed

- Export `PushProvider` enum

## 2.0.0-nullsafety.7

🛑️ Breaking Changes from `2.0.0-nullsafety.6`

- `ConnectUserWithProvider` now requires `tokenProvider` as a required parameter. (Removed from the
  constructor)
- `client.disconnect()` is now divided into two different functions
    - `client.closeConnection()` -> for closing user web socket connection.
    - `client.disconnectUser()` -> for disconnecting user and resetting client state.
- `client.devToken()` now returns a `Token` model instead of `String`.
- `ApiError` is removed in favor of `StreamChatError`
    - `StreamChatError` -> parent type for all the stream errors.
    - `StreamWebSocketError` -> for user web socket related errors.
    - `StreamChatNetworkError` -> for network related errors.
- `client.queryChannels()`, `channel.query()` options parameter is removed in favor of individual parameters
    - `option.state` -> bool state
    - `option.watch` -> bool watch
    - `option.presence` -> bool presence
- `client.queryUsers()` options parameter is removed in favor of individual parameters
    - `option.presence` -> bool presence

✅ Added

- New `Location` enum is introduced for easily changing the client location/baseUrl.
- New `client.openConnection()` and `client.closeConnection()` is introduced to connect/disconnect
  user WS connection.

🔄 Changed

- `baseURL` is now deprecated in favor of using `Location` to change data location.

## 2.0.0-nullsafety.6

- Fix thread reply not working with attachments
- Minor fixes

## 2.0.0-nullsafety.5

- Minor fixes
- Performance improvements
- Fixed `skip_push` in `client.sendMessage`
- Added partial message update method

## 2.0.0-nullsafety.2

- Added new `Filter.raw` constructor
- Changed extraData
- Minor fixes

## 2.0.0-nullsafety.1

- Migrate this package to null safety
- Added typed filters

## 1.5.3

- fix: `StreamChatClient.connect` returns quicker when you're using the persistence package

## 1.5.2

- fix: `queryChannels` should throw exceptions only if no data is present in cache.

## 1.5.1

- Minor fixes and improvements

## 1.5.0

- Minor fixes and improvements

## 1.4.0-beta

- Improved attachment uploading
- Fix: update member presence
- Added skip_push to message model
- Minor fixes and improvements

## 1.3.2+1-beta

- Fixed queryChannels bug

## 1.3.1-beta

- Debounced frequent db calls

## 1.3.0-beta

- Save pinned messages in offline storage
- Minor fixes
- `StreamClient.QueryChannels` now returns a Stream and fetches the channels from storage before
  calling the api
- Added `StreamClient.QueryChannelsOnline` and `StreamClient.QueryChannelsOffline` to fetch channels
  only from online or offline

## 1.2.0-beta

- 🛑 **BREAKING** Changed signature of `StreamClient.search` method
- Added `pinMessage`
  feature [docs here](https://getstream.io/chat/docs/flutter-dart/pinned_messages/?language=dart)
- Fixed minor bugs

## 1.1.0-beta

- Fixed minor bugs
- Add support for custom attachment
  upload [docs here](https://getstream.io/chat/docs/flutter-dart/file_uploads/?language=dart)
- Add support for asynchronous attachment upload

## 1.0.3-beta

- Fixed issue with disconnecting after connecting without awaiting the connection result
- Fixed bug that caused duplicated typing.stop events to be fired

## 1.0.2-beta

- Deprecated `setUser`, `setGuestUser`, `setUserWithProvider` in favor of `connectUser`
  , `connectGuestUser`
  , `connectUserWithProvider`
- Optimised reaction updates - i.e., Update first call Api later.

## 1.0.1-beta

- Fixed pub analysis issues

## 1.0.0-beta

- 🛑 **BREAKING** Renamed `Client` to less generic `StreamChatClient`
- 🛑 **BREAKING** Segregated the persistence layer into separate
  package [`stream_chat_persistence`](https://pub.dev/packages/stream_chat_persistence)
- 🛑 **BREAKING** Moved `Client.backgroundKeepAlive`
  to [core package](https://pub.dev/packages/stream_chat_core)
- 🛑 **BREAKING** Moved `Client.showLocalNotification`
  to [core package](https://pub.dev/packages/stream_chat_core) and renamed it
  to `StreamChatCore.onBackgroundEventReceived`
- Removed `flutter` dependency. This is now a pure Dart package 🥳
- Minor improvements and bugfixes

## 0.2.24+2

- Fix reconnection bug while using tokenProvider

## 0.2.24+1

- Stop ws reconnection after calling disconnect

## 0.2.24

- Create enum for push providers
- Add merge helper functions in `Message` and `ChannelModel` for easier data manipulation

## 0.2.23+3

- Remove + notation from userAgent
- Fix optimistic update for totalUnreadCount

## 0.2.23+2

- Do not throw an error when calling queryChannels without an active connection if the offline
  storage is enabled

## 0.2.23+1

- Throw an error when calling queryChannels without an active connection
- Wait to establish a connection if calling queryChannels while connecting

## 0.2.23

- Add thread_participants in message model

## 0.2.22

- Add thread-less message reply feature (QuotedMessage)

## 0.2.21+2

- Fix but not throwing error during querychannels and persistance disabled
- Fix reaction.updated event handling

## 0.2.21+1

- Fix error in the offline storage queryChannelCids query

## 0.2.21

- Fix channel.hide(clearHistory: true) not clearing local messages
- Add banned field to member

## 0.2.20

- Return offline data only if the backend is unreachable. This avoids the glitch of the
  ChannelListView because we cannot sort by custom properties.

## 0.2.19

- Added message filters for `Client.search()`

## 0.2.18

- Correctly dispose resources when disposing the client state
- Limit parallel queryChannels with same parameters to 1
- Added `clearUser` parameter to `client.disconnect` to remove the user instance of the client

## 0.2.17+1

- Do not retry messages when server returns error

## 0.2.17

- Add shadow ban feature

## 0.2.16

- Listen for user.updated events

## 0.2.15+2

- Fix reaction score updates

## 0.2.15+1

- Listen to reaction.updated event

## 0.2.15

- Fix search message response

## 0.2.14

- Add event.extradata

## 0.2.13+1

- Let user change channel.extradata if the channel is not initialized yet

## 0.2.13

- Add parent_id to events for typing indicators in threads

## 0.2.12+2

- Fix error with reactions with null user

## 0.2.12

- Do not save channels in memory if not being watched. This was leading to some bugs in some
  specific use-cases.

## 0.2.11

- Fix user.name getter
- Use detached loggers
- Throw error while connecting if it comes from backend
- Fix ws reconnection

## 0.2.10+2

- Fix bug with event filtering

## 0.2.10+1

- Add default limit to pagination

## 0.2.10

- Added `channel.state.unreadCountStream`

## 0.2.9

- Adding a message on `Channel.update` is now optional

## 0.2.8+1

- Fix retry logic

## 0.2.8

- Add missing event types
- Fix local sorting on offline storage

## 0.2.7+1

- `Client.channel` returns an existing channel if available
- Update message in the offline storage if attachment has expired (for the new CDN)
- Fix `GetMessagesByIdResponse` format
- Do not query messages if already existing in offline storage

## 0.2.6

- Experimental support for Flutter web and MacOs

## 0.2.5+2

- Cleaned up Serialization on extra_data

## 0.2.5+1

- Fix `channel.show` api call

## 0.2.5

- Add `channelType` and `channelId` properties to event object

## 0.2.4+2

- Fix query members messing channel state

## 0.2.4+1

- Do not resync if there is no channel in offlinestorage

## 0.2.4

- Add null-safety to ws disconnect
- Add pagination parameters to queryUsers request

## 0.2.3+3

- Fix reaction add/remove logic

## 0.2.3+2

- Skip system messages during unreadCount computation

## 0.2.3+1

- Removed moor_ffi from dependencies in favor of moor/ffi

## 0.2.3

- Fix reject invite payload

- Add multi-tenant properties to channel and user

## 0.2.2+1

- Fix queryChannels payload

## 0.2.2

- Fix add/remove/invite members api calls

## 0.2.1

- Add `isMutedStream` to `Channel`
- Add `isGroup` to `Channel`
- Add `isDistinct` to `Channel`

## 0.2.0+2

- Fix search messages response class

## 0.2.0+1

- Fix offline members update
- Add channel mutes
- Fix default channel sort

## 0.2.0

- Add `lastMessage` getter to Channel.state
- Add `isSystem` property to Message
- Incremental websocket reconnection timeout
- Add translate message api call
- Add queryMembers api call
- Add user list to client state
- Synchronize channel members status
- Add offline storage
- Add push notifications helper functions

## 0.2.0-alpha+23

- Add `lastMessage` getter to `Channel.state`

## 0.2.0-alpha+22

- Add `isSystem` property to Message

## 0.2.0-alpha+21

- Incremental websocket reconnection timeout

## 0.2.0-alpha+20

- More robust offline storage insertions

## 0.2.0-alpha+19

- Add translate message api call
- Add queryMembers api call

## 0.2.0-alpha+18

- Revert moor_ffi version to 0.5.0

## 0.2.0-alpha+17

- Add user list to client

- Synchronize channel members status

## 0.2.0-alpha+16

- Try QueryChannels when `resync` endpoint returns an error

## 0.2.0-alpha+15

- Fix receiving reactions

## 0.2.0-alpha+14

- Avoid sending local event for optimistic updates

## 0.2.0-alpha+13

- Fix offline on app first start up

## 0.2.0-alpha+12

- Fix retry mechanism in threads
- Fix delete channel query

## 0.2.0-alpha+9

- Add retry mechanism and retry queue

## 0.2.0-alpha+8

- Add copyWith to Attachment

## 0.2.0-alpha+7

- Add channel deleted/updated event handling

## 0.2.0-alpha+6

- Align with stable release

## 0.2.0-alpha+5

- Rename client parameters

## 0.2.0-alpha+3

- Remove dependencies on notification service

- Expose some helping method for integrate offline storage with push notifications

## 0.2.0-alpha+2

- Fix unread count

## 0.2.0-alpha

- Offline storage

- Push notifications

- Minor bug fixes

## 0.1.30

- Add silent property to message

## 0.1.29

- Fix read event handling

## 0.1.28

- Fix bug clearing members when receiving a message

## 0.1.27

- Update dependencies

## 0.1.26

- Remove wrong `members` property from `ChannelModel`

## 0.1.25

- Fix online status

## 0.1.24

- Fix unread count

## 0.1.22

- Add mute/unmute channel

## 0.1.20

- Fix channel query path without id

## 0.1.19

- Fix loading message replies

## 0.1.18

- Export dio error

## 0.1.17

- Ignore current user typing events

- Add event types

## 0.1.16

- Fix message update

## 0.1.15

- Fix mentions handling

## 0.1.14

- Handle message modification and commands

## 0.1.13

- Add message.updated event handling

## 0.1.12

- Add export multipart_file from dio

## 0.1.11

- Add channel config checks

## 0.1.10

- Rename Channel.channelClients to channels

## 0.1.9

- Fix channel update on message delete

## 0.1.8

- Add delete message handling

## 0.1.7

- Add reaction handling

## 0.1.6

- Add initialized completer

- Update example

## 0.1.5

- Add `ClientState` and `ChannelClientState` classes to handle channel state updates using events

- Update example supporting threads

## 0.1.4

- Update some api with wrong or incomplete signatures

- Add documentation for public apis

## 0.1.2

- add websocket reconnection logic

- add token expiration mechanism

## 0.1.1

- add typing events handling

## 0.1.0

- a better example can be found in the example/ directory

- fix some api calls and add missing one

## 0.0.2

- first beta version
