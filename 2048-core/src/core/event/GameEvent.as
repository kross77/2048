/**
 * Created by a.krasovsky on 04.11.2014.
 */
package core.event {
import flash.events.Event;

public class GameEvent extends Event {
    public static const RESTART:String = "restart";
    public static const UNDO:String = "undo";
    public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
