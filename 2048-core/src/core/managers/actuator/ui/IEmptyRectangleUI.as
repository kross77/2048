/**
 * Created by a.krasovsky on 17.11.2014.
 */
package core.managers.actuator.ui {
import flash.display.Graphics;

public interface IEmptyRectangleUI {
    function drawIn(graphics:Graphics, row:int, col:int, borderWeight:int):void

    function get width():int;
    function get height():int;

    function set width(value:int):void;
    function set height(value:int):void;
}
}
