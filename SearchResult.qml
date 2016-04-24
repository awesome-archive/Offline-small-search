import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)
    z: 0

    Rectangle {
        z: 1
        id: rectangle3
        height: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0


        Text {
            id: text8
            text: qsTr("搜索结果")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
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
    }

    ListView {
        id: listView1
        anchors.top: rectangle3.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        model: search_result_obj
        z: 0

        delegate: Item {
            z: -1
            width: rectangle2.width
            height: Math.min(200*Math.min(rectangle2.a_max/1280,a_pd/12),str.contentHeight+3)
            Rectangle{
                anchors.fill: parent
                anchors.bottomMargin: 3*Math.min(rectangle2.a_max/1280,a_pd/12)

                Text {
                    id: str
                    text: (index+1)+".  "+model.modelData.str
                    anchors.fill: parent
                    anchors.leftMargin: 20*rectangle2.a_sqrt
                    anchors.rightMargin: 20*rectangle2.a_sqrt
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    maximumLineCount: (height-font.pixelSize)/(linespaceCheck.contentHeight-font.pixelSize)+1
                    elide: Text.ElideLeft
                    wrapMode: Text.Wrap
                    font.pixelSize: 35*rectangle2.a_sqrt
                    Text {
                        visible: false
                        text: "\n"
                        id: linespaceCheck
                        font.pixelSize: 35*rectangle2.a_sqrt
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rectangle2.focus = true
                        main_widget.show_result(model.modelData.url)
                    }
                }
            }
            Rectangle {
                height: 3*Math.min(rectangle2.a_max/1280,a_pd/12)
                color: "#bbbbbb"
                border.width: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
            }
        }
    }

    AnimatedImage {
        id: image2
        z: 1
        objectName: "wait_image"
        width: 200*rectangle2.a_min/720
        height: 156*rectangle2.a_max/1280
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/image/icon_wait.gif"
        fillMode: Image.PreserveAspectFit
        visible: false
    }
}
