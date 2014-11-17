/**
 * Created by Administator on 19.10.14.
 */
package core.managers.input {
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.TransformGestureEvent;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

public class GestureInputManager extends G2048InputManager {

    private var mapMove:Object = {
        38: 0, // Up
        39: 1, // Right
        40: 2, // Down
        37: 3, // Left
        75: 0, // Vim up
        76: 1, // Vim right
        74: 2, // Vim down
        72: 3, // Vim left
        87: 0, // W
        68: 1, // D
        83: 2, // S
        65: 3  // A
    };
    private var stage:Stage;

    public function GestureInputManager() {
        super();
    }

    public function init(stage:Stage):void {
        this.stage = stage;
        Multitouch.inputMode = MultitouchInputMode.GESTURE;
        stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);

    }

    private function onSwipe(event:TransformGestureEvent):void {
        if (event.offsetX == 1) {
            //User swiped towards right
            move(1);
        }
        if (event.offsetX == -1) {
            //User swiped towards left
            move(3);
        }

        if (event.offsetY == 1) {
            //User swiped towards bottom
            move(2);
        }
        if (event.offsetY == -1) {
            //User swiped towards top
            move(0);
        }
    }

    private function stageKeyDownHandler(event:KeyboardEvent):void {

        if (mapMove[event.keyCode] !== undefined) {
            var direction:int = mapMove[event.keyCode];
            move(direction);
        }

        if (event.keyCode == 82) {
            restart();
        }

    }
}
}
