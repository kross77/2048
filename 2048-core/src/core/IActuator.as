/**
 * Created by Administator on 13.10.14.
 */
package core {
import core.object.Grid;

public interface IActuator {
    function continueGame():void;
    function actuate(grid:Grid, params:Object):void;
}
}
