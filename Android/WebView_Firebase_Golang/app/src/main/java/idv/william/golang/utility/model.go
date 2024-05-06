package utility

type FirebaseMessage struct {
	Token string
	Title string
	Body  string
	Topic string
	Data  map[string]string

	// Apple / iOS
	Subtitle  string
	ActioniOS string

	// Android
	ActionAndroid string

	// Webpush
	ActionWebPush  string
	CustomData     map[string]interface{}
	BadgeIconImage string
	SoundWebPush   string
	TagsCategory   string
}
