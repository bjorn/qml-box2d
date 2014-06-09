import Qt 4.7
import Box2D 1.0

Body {
    id: finish
    bodyType: Body.Static

    fixtures: Box {
        id: box
        anchors.fill: parent
        sensor: true

        onContactChanged: {
            if (other.parent != ball || ball.state == "gone")
                return;

            if (ball.x < finish.x + finish.width &&
                    ball.x >= finish.x &&
                    ball.y < finish.y + finish.height &&
                    ball.y >= finish.y) {
                ball.disappearTo(ball.parent.mapFromItem(finish,
                                                         box.width / 2,
                                                         box.height / 2))
                world.won()
            }
        }
    }

    Image {
        id: image
        anchors.fill: parent
        source: "finish.png"
        fillMode: Image.Tile
        clip: true
    }
}
