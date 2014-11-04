/**
 * Created by a.krasovsky on 04.11.2014.
 */
package core.global {



public function globalEvent(type:String, data:Object = null):void {
        GlobalDispatcherSingleton.instance.newEvent(type, data);
}

}
