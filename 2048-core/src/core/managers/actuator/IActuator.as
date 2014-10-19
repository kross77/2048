/**
 * Created by Administator on 13.10.14.
 */
package core.managers.actuator {
import core.object.Grid;
import core.object.model.GameManagerVO;

public interface IActuator {
    function continueGame():void;
    function actuate(grid:Grid, params:GameManagerVO):void;
}
}
