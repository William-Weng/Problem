package main

import (
	"net/http"
	"time"
	"william/utility"

	"github.com/gin-gonic/gin"
)

type MyError struct {
	Message string
}

func init() {
}

const (
	CredentialsFileUrl string = "/Users/iOS/Documents/Secrets/fcm-demo-f447b-firebase-adminsdk-c083h-6409543751.json"
)

func main() {

	router := gin.Default()
	apiV1 := router.Group("/push/v1")
	router.MaxMultipartMemory = 8 << 20 // 8 MiB

	pushAPI(apiV1)
	firebaseAPI(apiV1)

	router.Run(":12345")
}

// <GET> 推播 => push/v1/dev/<AppId>/<Token> + {url":"<URL>"}
func pushAPI(router *gin.RouterGroup) {

	router.GET("/:fcm/:topic/:token", func(context *gin.Context) {

		dictionary := utility.RequestBodyToMap(context)
		url, _ := dictionary["url"].(string)
		appId := context.Param("topic")
		token := context.Param("token")

		result, error := firebaseCloudMessagingResult(token, appId, url)
		utility.ContextJSON(context, http.StatusOK, result, error)
	})
}

// <POST> 推播 => push/v1/dev/<AppId> + {"token":"<Token>","url":"<URL>"}
func firebaseAPI(router *gin.RouterGroup) {

	router.POST("/:fcm/:topic", func(context *gin.Context) {

		dictionary := utility.RequestBodyToMap(context)
		token, _ := dictionary["token"].(string)
		url, _ := dictionary["url"].(string)
		appId := context.Param("topic")

		result, error := firebaseCloudMessagingResult(token, appId, url)
		utility.ContextJSON(context, http.StatusOK, result, error)
	})
}

// 推播功能總合
func firebaseCloudMessagingResult(token string, appId string, url string) (string, error) {

	now := time.Now()
	body := now.Format(time.UnixDate)

	result, error := utility.FirebaseCloudMessagingV1(CredentialsFileUrl, token, appId, body, url)
	return result, error
}
