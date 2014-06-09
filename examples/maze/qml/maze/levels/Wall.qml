import Qt 4.7
import Box2D 1.0

Body {
    width: 20
    height: 100
    bodyType: Body.Static

    fixtures: Box { anchors.fill: parent; }
}
