import Qt 4.7

Image {
    source: "levels/woodbackground.png"

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 50
//        source: "title.png"
    }

    Column {
        anchors.centerIn: parent
        MenuItem { text: "Start" }
        MenuItem { text: "Resume" }
        MenuItem { text: "Quit" }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.state = "Playing"
    }

    Loader {
        id: levelLoader
        visible: false
        source: "levels/Level1.qml"
    }

    states: [
        State {
            name: "Playing"
            PropertyChanges {
                target: levelLoader
                visible: true
            }
        }
    ]
}
