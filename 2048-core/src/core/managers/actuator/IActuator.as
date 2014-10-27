/**
 * Created by Administator on 13.10.14.
 */
package core.managers.actuator {
import core.object.model.GameManagerVO;

import mx.core.IUIComponent;

public interface IActuator extends IUIComponent{
    function continueGame():void;
    function actuate(params:GameManagerVO):void;
}
}
