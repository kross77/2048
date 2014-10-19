/**
 * Created by Administator on 19.10.14.
 */
package core.managers.input {
import core.managers.input.IInputManager;

import flash.display.Stage;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;

public class KeyboardInputManager extends G2048InputManager{

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
    public function KeyboardInputManager() {
        super();
    }

    public function init(stage:Stage):void{
        this.stage = stage;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDownHandler);

    }

    private function stageKeyDownHandler(event:KeyboardEvent):void {

        if(mapMove[event.keyCode] !== undefined){
            var direction:int = mapMove[event.keyCode];
            move(direction);
        }

        if(event.keyCode == 82){
            restart();
        }

    }
}
}
