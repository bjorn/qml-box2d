import Qt 4.7
import Box2D 1.0

Body {
    id: ball
    sleepingAllowed: false
    linearDamping: 0.5
    angularDamping: 0.5

    property real holeX
    property real holeY

    function disappearTo(point) {
        holeX = point.x
        holeY = point.y
        state = "gone"
    }

    function respawnAt(point) {
        state = ""
        x = point.x
        y = point.y
    }

    fixtures: Circle {
        id: circle
        radius: 13
        density: 1.0
        friction: 0.3
        restitution: 0.3

        Item {
            rotation: -ball.rotation
            Image {
                id: ballImage
                rotation: 90
                source: "metalball1.png"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -2
                anchors.horizontalCenterOffset: -2
                smooth: true
            }
        }
    }

    states: State {
        name: "gone"
        PropertyChanges {
            target: ball
            x: holeX
            y: holeY
            bodyType: Body.Static
        }
        PropertyChanges {
            target: ballImage
            scale: 0
        }
    }

    transitions: Transition {
        to: "gone"
        NumberAnimation { properties: "x,y,scale" }
    }
}
