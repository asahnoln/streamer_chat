# TODO

Chat aggregator

- [x] get_last_messages([]Service) -> []Message
- [ ] twitch get messages
- [ ] tiktok get messages
- [ ] Play sound when displaying a message
- [ ] Messages should be placed in a box with a scroll
- [ ] Viewer count from platforms
- [ ] Handle errors (logging?)

## Info on connections

### Twitch

<https://dev.twitch.tv/docs/chat/send-receive-messages/#receiving-chat-messages>

```fish
curl -X POST 'https://api.twitch.tv/helix/eventsub/subscriptions' \
-H 'Authorization: Bearer kpvy3cjboyptmdkiacwr0c19hotn5s' \
-H 'Client-Id: hof5gwx0su6owfnys0nyan9c87zr6t' \
-H 'Content-Type: application/json' \
-d '{
  "type": "channel.chat.message",
  "version": "1",
  "condition": {
    "broadcaster_user_id": "12826",
    "user_id": "141981764"
  },
  "transport": {
    "method": "webhook",
    "callback": "https://your-callback-url-here.example",
    "secret": "s3cre7"
  }
}'
```

### tiktok

data-e2e="chat-message" ... data-e2e="message-owner-name" title="{name}" ... DivComment ... >{text}
