/**
 * Created by a.krasovsky on 04.11.2014.
 */
package core.global {
import flash.utils.Dictionary;

public class GlobalListener {
    public var collection:Dictionary = new Dictionary();
    protected var parent:Object;
    public function GlobalListener(parent:Object) {
        this.parent = parent;
    }

    protected function add(callback:Function, type:String):void
    {
        collection[type] = callback;
    }
}
}
