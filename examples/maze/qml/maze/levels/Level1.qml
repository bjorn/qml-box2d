import Qt 4.7
import Box2D 1.0
import ".."
import "../record.js" as Recorder

World {
    id: world

    width: 360
    height: 540

    property real startX: world.width - 30
    property real startY: 20

    property real seconds: 0

    Component.onCompleted: start()

    function start() {
        Recorder.start(1)
        world.state = ""
        seconds = 0
        ball.respawnAt(Qt.point(startX, startY))
    }

    function won() {
        state = "won"
        Recorder.finish()
    }

    onStepped: {
        if (ball.state !== "gone")
            Recorder.step(ball, ghostBall)
    }

    Wall {
        x: 56; y: 51; width: 304; height: 12;
        rotation: -2;
    }
    Wall { x:   0; y: 121; width: 267; height:  12; }
    Wall { x: 267; y: 121; width:  12; height: 344; }
    Wall { x:  80; y: 464; width: 199; height:  12; }
    Wall { x:  80; y: 282; width:  12; height: 183; }
    Wall { x:   0; y: 194; width: 171; height:  12; }
    Wall { x: 159; y: 206; width:  12; height: 182; }

    Hole {
        id: hole1
        x: 0
        y: 91
    }

    Hole {
        id: hole2
        x: 330
        y: 66
    }

    Hole {
        id: hole3
        x: 0
        y: 0
    }

    Hole {
        id: hole4
        x: 279
        y: 185
    }

    Hole {
        id: hole5
        x: 330
        y: 332
    }

    Hole {
        id: hole6
        x: 285
        y: 510
    }

    Hole {
        id: hole7
        x: 0
        y: 510
    }

    Hole {
        id: hole8
        x: 0
        y: 206
    }

    Hole {
        id: hole9
        x: 48
        y: 365
    }

    Hole {
        id: hole10
        x: 126
        y: 206
    }

    Hole {
        id: hole11
        x: 93
        y: 435
    }

    Hole {
        id: hole12
        x: 171
        y: 268
    }

    Hole {
        id: hole13
        x: 234
        y: 365
    }

    Hole {
        id: hole14
        x: 234
        y: 136
    }

    Hole {
        id: hole15
        x: 171
        y: 136
    }

    Hole {
        id: hole16
        x: 234
        y: 185
    }

    Finish {
        id: finish1
        x: 0
        y: 136
        width: 15
        height: 55
    }

    Item {
        id: ghostBall
        x: -20
        opacity: 0.25
        Image {
            id: ballImage
            rotation: 90
            source: "../metalball1.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            anchors.horizontalCenterOffset: -2
        }
    }

    Ball {
        id: ball
        x: startX; y: startY
    }

    Image { source: "level1-walls.png" }

    // Level boundaries
    Body {
        id: ground
        height: 20
        anchors { left: parent.left; right: parent.right; top: parent.bottom }
        bodyType: Body.Static
        fixtures: Box { anchors.fill: parent }
    }
    Body {
        id: ceiling
        height: 20
        anchors { left: parent.left; right: parent.right; bottom: parent.top }
        bodyType: Body.Static
        fixtures: Box { anchors.fill: parent }
    }
    Body {
        id: leftWall
        width: 20
        anchors { right: parent.left; bottom: ground.top; top: ceiling.bottom }
        bodyType: Body.Static
        fixtures: Box { anchors.fill: parent }
    }
    Body {
        id: rightWall
        width: 20
        anchors { left: parent.right; bottom: ground.top; top: ceiling.bottom }
        bodyType: Body.Static
        fixtures: Box { anchors.fill: parent }
    }

    DebugDraw {
        id: debugDraw
        world: world
        anchors.fill: world
        opacity: 0.75
        visible: false
    }
    MouseArea {
        id: debugMouseArea
        anchors.fill: world
        onPressed: debugDraw.visible = !debugDraw.visible
    }

    Rectangle {
        color: "black"
        visible: ball.state == "gone"
        opacity:  0.5
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: start()
        }
    }

    Text {
        text: qsTr("Restart")
        visible: ball.state == "gone"
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            onClicked: start()
        }
    }

    Text {
        text: qsTr("You've Won!")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 2
        y: world.height / 3 + 2
        font.pixelSize: 45
        color: "black"
        visible: world.state == "won"
    }
    Text {
        id: wonLabel
        text: "You've Won!"
        anchors.horizontalCenter: parent.horizontalCenter
        y: world.height / 3
        font.pixelSize: 45
        color: "white"
        visible: world.state == "won"
    }

    Text {
        text: secondsDisplay.text
        x: secondsDisplay.x + 1
        y: secondsDisplay.y + 1
        font: secondsDisplay.font
        color: "black"
    }
    Text {
        id: secondsDisplay
        text: {
            var minutes = Math.floor(seconds / 60)
            var secs = seconds % 60
            return ((minutes < 10) ? "0" : "") + minutes + ":" +
                    ((secs < 10) ? "0" : "") + secs
        }
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        font.pixelSize: 25
        color: "white"
    }

    Timer {
        interval: 1000
        running: ball.state != "gone"
        repeat: true
        onTriggered: seconds++
    }

    states: [
        State {
            name: "won"
            AnchorChanges {
                target: secondsDisplay
                anchors.right: undefined
                anchors.bottom: undefined
                anchors.horizontalCenter: world.horizontalCenter
                anchors.verticalCenter: world.verticalCenter
            }
            PropertyChanges {
                target: secondsDisplay
                anchors.verticalCenterOffset: 100
                font.pixelSize: 45
            }
        }
    ]

    transitions: [
        Transition {
            to: "won"
            AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation {
                properties: "anchors.verticalCenterOffset,font.pixelSize"
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
