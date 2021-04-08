const { onMounted } = Vue

const myApp = Vue.createApp({
    data() {
        return {
            records: [],
            options: [],
            optionValue: null,
            hasOS: false,
        }
    },
    methods: {
        /// 到AirTable取資料 => 資料結構：{ Name, Notes, URL, OS }
        updateInfo() {

            $.blockUI({
                message: '<h1>讀取中...</h1>' 
            })

            const Key = {
                app: '<Your AirTable APP Key>',
                authorization: '<Your Authorization Key>',
                database: this.optionValue
            }

            const baseRequest = axios.create({
                baseURL: `https://api.airtable.com/v0/${Key.app}/`,
                headers: { Authorization: `${Key.authorization}` }
            })

            baseRequest.get(`${Key.database}?sort[0][field]=Name`)
            .then(response => {
                this.records = response.data.records
            })
            .catch(error => {
                console.log(error)
            })
            .finally(() => {
                setTimeout(() => { $.unblockUI() }, 500)
            })
        },
        /// 選單選完就更新資料
        onChange() {
            this.checkOSField()
            this.updateInfo()
        },
        /// 是否顯示OS欄位
        checkOSField() {
            for (const option of this.options) {
                if (this.optionValue === option.key) { this.hasOS = option.hasOS; return }
            }
        }
    },
    computed: {},
    mounted() {
        this.options = [
            { key: "Linux", value: "Linux", hasOS: false, hasExample: false }, 
            { key: "SQL", value: "SQL", hasOS: false, hasExample: false }, 
            { key: "Software", value: "Software", hasOS: true, hasExample: false }, 
            { key: "Font", value: "Font", hasOS: false, hasExample: false }, 
            { key: "Edge", value: "Mircosoft Edge", hasOS: false, hasExample: false }, 
            { key: "Firefox", value: "Firefox", hasOS: false, hasExample: false }, 
            { key: "VisualStudioCode", value: "Visual Studio Code", hasOS: false, hasExample: false }, 
            { key: "OperatingSystem", value: "Operating System", hasOS: false, hasExample: false }, 
            { key: "WebTools", value: "WebTools", hasOS: false, hasExample: false }, 
            { key: "Android", value: "Android", hasOS: false, hasExample: false }, 
            { key: "JavaScript", value: "JavaScript", hasOS: false, hasExample: false }, 
            { key: "Bookmark", value: "Bookmark", hasOS: false, hasExample: false }, 
            { key: "iOS", value: "iOS", hasOS: false, hasExample: false },
            { key: "Grails", value: "Grails", hasOS: false, hasExample: false }, 
        ]

        this.optionValue = this.options[0].key
        // this.updateInfo()
        // this.checkOSField()
    }
})