import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtWebView 1.0

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)

    Rectangle {
        id: rectangle3
        height: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        /*
        Text {
            id: text8
            text: qsTr("内容")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
        }
        */
        TextField {
            anchors.left: image1.right
            anchors.right: search_img.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Layout.fillWidth: true
            id: text8
            inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhPreferLowercase
            text: text.docurl

            onAccepted: {
                if(text8.text.indexOf(":/") == -1) text8.text = "http://"+text8.text;
                if((text8.text.indexOf("http://") == 0)||(text8.text.indexOf("https://") == 0))  text.url = text8.text;
                else main_widget.load_html(text8.text);
            }

            ProgressBar {
                anchors.centerIn: parent
                style: ProgressBarStyle {
                    background: Rectangle {
                        radius: 2
                        color: "transparent"
                        implicitHeight: text8.height - 2
                        implicitWidth: text8.width
                    }
                    progress: Rectangle {
                        anchors.fill: parent
                        color: "#80c342"
                        opacity: 0.5
                    }

                }
                z: Qt.platform.os === "android" ? -1 : 1
                visible: text.loading && Qt.platform.os !== "ios" && (text.url.toString().indexOf("/") > -1)
                minimumValue: 0
                maximumValue: 100
                value: text.loadProgress > 100 ? 0 : text.loadProgress
            }
        }

        Image {
            id: image1
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_back.png"

            MouseArea {
                id: mouseArea1
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    main_widget.show_back()
                }
            }
        }
        Image {
            id: search_img
            objectName: "result_search_img"
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.topMargin: 10*rectangle2.a_max/1280
            anchors.bottomMargin: 10*rectangle2.a_max/1280
            source: "qrc:/image/icon_search.png"

            MouseArea {
                id: mouseArea2
                anchors.topMargin: -10*rectangle2.a_max/1280
                anchors.bottomMargin: -10*rectangle2.a_max/1280
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    rectangle2.focus = true
                    main_widget.show_search()
                }
            }
        }
    }
/*
    TextArea {
        id: text
        objectName: "text"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        textFormat: TextEdit.RichText
        readOnly: true
        wrapMode: TextEdit.Wrap
    }
*/

    WebView {
        id: text
        url: ""
        objectName: "text"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0
        anchors.bottom: rectangle4.top
        anchors.bottomMargin: 0
        property int count: 0
        property string docurl: ""
        onDocurlChanged: text8.text = docurl

        onUrlChanged: {
            if(url.toString().indexOf("/") > -1) {
                console.log("load1",url)
                if((text8.text.indexOf("http://") == 0)||(text8.text.indexOf("https://") == 0)) text8.text = url
                else main_widget.load_html(url)
                console.log("load2",url)
            }
            else console.log("load3",url)
        }
    }

    Rectangle {
        id: rectangle4
        height: 80*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        Rectangle {
            id: back
            color: "#f0f0f0"
            anchors.left: parent.left
            anchors.leftMargin: 0
            width: (text.count > 1) ? rectangle2.width/3 : 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            Image {
                id: back_img
                anchors.right: back_t.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                width: height
                source: "qrc:/image/icon_back.png"
            }

            Text {
                id: back_t
                text: qsTr("后退")
                font.pixelSize: 40*rectangle3.height/100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rectangle2.focus = true
                    main_widget.webview_goback()
                }
            }
        }

        Rectangle {
            id: tran
            color: "#f0f0f0"
            anchors.left: back.right
            anchors.leftMargin: 0
            width: (text.count > 1) ? rectangle2.width/3 : rectangle2.width/2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            Image {
                id: tran_img
                anchors.right: tran_t.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                width: height
                source: "qrc:/image/icon_tran.png"
            }

            Text {
                id: tran_t
                text: qsTr("有道翻译")
                font.pixelSize: 40*rectangle3.height/100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    text.runJavaScript("javascript:var d = document.createElement(\"script\");d.setAttribute(\"src\", \"http://fanyi.youdao.com/web2/scripts/all-packed-utf-8.js?572877&\" + Date.parse(new Date()));d.setAttribute(\"type\", \"text/javascript\");d.setAttribute(\"charset\", \"utf-8\");document.body.appendChild(d);",function() { console.log("runjs"); })
                }
            }
        }

        Rectangle {
            id: mark
            color: "#f0f0f0"
            anchors.left: tran.right
            anchors.leftMargin: 0
            width: (text.count > 1) ? rectangle2.width/3 : rectangle2.width/2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            Image {
                id: mark_img
                objectName: "mark_img"
                anchors.right: mark_t.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                width: height
                visible: !((text8.text.indexOf("http://") == 0)||(text8.text.indexOf("https://") == 0))
            }

            Image {
                id: refresh_img
                anchors.fill: mark_img
                width: height
                source: "qrc:/image/icon_refresh.png"
                visible: !mark_img.visible
            }

            Text {
                id: mark_t
                text: ((text8.text.indexOf("http://") == 0)||(text8.text.indexOf("https://")) == 0) ? qsTr("刷新") :qsTr("收藏")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 40*rectangle3.height/100
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if((text8.text.indexOf("http://") == 0)||(text8.text.indexOf("https://") == 0)) text.reload()
                    else {
                        main_widget.check_mark()
                        main_widget.mark_list_to_data_file()
                    }
                }
            }
        }
    }

    MessageDialog {
        id: not_mark
        title: qsTr("无法收藏")
        text: qsTr("对不起,本程序不收藏在线页面.")
        standardButtons: StandardButton.Ok
    }
}

