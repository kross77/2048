/**
 * Created by Administator on 19.10.14.
 */
package core.managers.input {
public class AbstractInputManager {
    private var _onActionCallback:Function;
    public function AbstractInputManager() {
    }
    
    public function inputAction(type:String, params:Object = null):void{
        if(_onActionCallback != null){
            _onActionCallback(type, params);
        }
    }

    public function set onActionCallback(value:Function):void {
        _onActionCallback = value;
    }
}
}
