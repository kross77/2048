/**
 * Created by a.krasovsky on 04.11.2014.
 */
package core.global {
import core.global.listeners.GameManagerListener;

import flash.events.EventDispatcher;

public class GlobalDispatcherSingleton extends EventDispatcher{
    private static var _instance:GlobalDispatcherSingleton;
    private var listeners:Array = [];
    public function GlobalDispatcherSingleton(instance:PrivateClass) {

    }


    public static function get instance():GlobalDispatcherSingleton {
        if(!_instance){
            _instance = new GlobalDispatcherSingleton(new PrivateClass());
        }
        return _instance;
    }

    public function newEvent(type:String, data:Object):void {
        for (var i:int = 0; i < listeners.length; i++) {
            var item:IGlobalListener = listeners[i];
            if(item.listener.collection[type]){
                item.listener.collection[type](data);
            }
        }
    }

    public function addGlobalListener(listener:IGlobalListener):void{
        listeners.push(listener);
    }
}



}

class PrivateClass{

}
