package utility

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"runtime"

	firebase "firebase.google.com/go"
	message "firebase.google.com/go/messaging"
	"github.com/appleboy/go-fcm"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/option"
)

// [印出結果](https://dotblogs.com.tw/DizzyDizzy/2019/11/29/ColorfulCLI)
func Println(value ...any) {

	_, filename, line, _ := runtime.Caller(1)

	// title := fmt.Sprintf("\033[30;106m%v\033[0m", time.Now().Local())
	message := fmt.Sprintf("\033[30;102m[%s]\033[0m\033[30;103m%s:%d\033[0m %v", "DEBUG", filename, line, value)

	// fmt.Print(title)
	fmt.Println(message)
}

// 讀取Request上的Body值 => MAP
func RequestBodyToMap(context *gin.Context) map[string]interface{} {

	rawJSON, _ := RequestBody(context)
	dictionary := RawBodyToMap(rawJSON)

	return dictionary
}

// 讀取Request上的Body值
func RequestBody(context *gin.Context) ([]byte, error) {
	return io.ReadAll(context.Request.Body)
}

// 將網路傳來的[]byte => map
func RawBodyToMap(rawJSON []byte) map[string]interface{} {

	dictionary := map[string]interface{}{}
	json.Unmarshal(rawJSON, &dictionary)

	return dictionary
}

// 輸出JSON (正確)
func ContextJSON(context *gin.Context, httpStatus int, result interface{}, error error) {

	context.JSON(httpStatus, gin.H{
		"code":   httpStatus,
		"error":  error,
		"result": result,
	})
}

// 輸出JSON (錯誤)
func ContextErrorJSON(context *gin.Context, httpStatus int, result interface{}, error error) {

	context.AbortWithStatusJSON(httpStatus, gin.H{
		"code":   httpStatus,
		"error":  error,
		"result": result,
	})
}

// Android推播功能 (舊版)
func FirebaseCloudMessaging(apiKey string, deviceToken string, title string, body string, url string) (*fcm.Response, error) {

	message := &fcm.Message{
		To: deviceToken,
		Data: map[string]interface{}{
			"url": url,
		},
		Notification: &fcm.Notification{
			Title: title,
			Body:  body,
		},
	}

	client, error := fcm.NewClient(apiKey)

	if error != nil {
		return nil, error
	}

	return client.Send(message)
}

// [Android推播功能 (新版)](https://github.com/orgmatileg/go-fcm)
func FirebaseCloudMessagingV1(fileURL string, deviceToken string, title string, body string, url string) (string, error) {

	var message FirebaseMessage = FirebaseMessage{}

	message.ActionWebPush = "https://www.google.com/"
	message.Token = deviceToken
	message.Title = title
	message.Body = body
	message.Data = map[string]string{
		"url": url,
	}

	result, error := firebaseHttpCloudMessaging(fileURL, &message)
	return result, error
}

// [Android推播功能 (新版)](https://github.com/orgmatileg/go-fcm)
// => export GOOGLE_APPLICATION_CREDENTIALS="/Users/ios/Documents/Secrets/fir-c77a1-firebase-adminsdk-46tby-89867a0665.json"
func firebaseHttpCloudMessaging(fileURL string, message *FirebaseMessage) (string, error) {

	fcmMessage := fcmMessageMaker(message)

	client, error := firebaseClientMaker(fileURL, message)
	if error != nil {
		return "", fmt.Errorf("初始化Messaging錯誤: %s", error.Error())
	}

	result, error := client.Send(context.Background(), fcmMessage)
	if error != nil {
		return "", fmt.Errorf("messaging發送錯誤: %s", error.Error())
	}

	return result, nil
}

// Android推播Token測試 (新版)
func firebaseHttpValidateToken(fileURL string, message *FirebaseMessage) (string, error) {

	fcmMessage := fcmMessageMaker(message)

	client, error := firebaseClientMaker(fileURL, message)
	if error != nil {
		return "", fmt.Errorf("初始化Messaging錯誤: %s", error.Error())
	}

	result, error := client.SendDryRun(context.Background(), fcmMessage)
	if error != nil {
		return "", fmt.Errorf("messaging發送錯誤: %s", error.Error())
	}

	return result, nil
}

// 產生message.Client
func firebaseClientMaker(fileURL string, message *FirebaseMessage) (*message.Client, error) {

	if message.Token == "" {
		return nil, errors.New("Token不得為空值")
	}

	app, error := initFirebaseCloudMessaging(fileURL)
	if error != nil {
		return nil, error
	}

	client, error := app.Messaging(context.Background())
	if error != nil {
		return nil, fmt.Errorf("初始化Messaging錯誤: %s", error.Error())
	}

	return client, nil
}

// 初始化FirebaseCloudMessaging
func initFirebaseCloudMessaging(fileURL string) (*firebase.App, error) {

	option := option.WithCredentialsFile(fileURL)
	app, error := firebase.NewApp(context.Background(), nil, option)

	if error != nil {
		return nil, fmt.Errorf("初始化Messaging失敗: %s", error.Error())
	}

	return app, nil
}

// 將自訂的FirebaseMessage => 推播格式的message.Message
func fcmMessageMaker(msg *FirebaseMessage) *message.Message {

	return &message.Message{
		Topic: msg.Topic,
		Token: msg.Token,
		Data:  msg.Data,
		APNS: &message.APNSConfig{
			Payload: &message.APNSPayload{
				Aps: &message.Aps{
					Category:   msg.TagsCategory,
					CustomData: msg.CustomData,
					Alert: &message.ApsAlert{
						ActionLocKey: msg.ActioniOS,
						Title:        msg.Title,
						SubTitle:     msg.Subtitle,
						Body:         msg.Body,
					},
				},
				CustomData: msg.CustomData,
			},
		},
		Android: &message.AndroidConfig{
			Data: msg.Data,
			Notification: &message.AndroidNotification{
				Title:       msg.Title,
				Icon:        msg.BadgeIconImage,
				Tag:         msg.TagsCategory,
				Body:        msg.Body,
				ClickAction: msg.ActionAndroid,
			},
			Priority: "high",
		},
		Webpush: &message.WebpushConfig{
			Data: msg.Data,
			Notification: &message.WebpushNotification{
				Title:      msg.Title,
				Body:       msg.Body,
				Data:       msg.CustomData,
				CustomData: msg.CustomData,
				Icon:       msg.BadgeIconImage,
				Badge:      msg.BadgeIconImage,
				Image:      msg.BadgeIconImage,
				Vibrate:    []int{500, 500, 200, 200, 200},
				Tag:        msg.TagsCategory,
			},
			FcmOptions: &message.WebpushFcmOptions{
				Link: msg.ActionWebPush,
			},
		},
		Notification: &message.Notification{
			Title: msg.Title,
			Body:  msg.Body,
		},
	}
}
