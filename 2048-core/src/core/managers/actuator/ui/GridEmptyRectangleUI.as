/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator.ui {
import flash.display.Graphics;

public class GridEmptyRectangleUI implements IEmptyRectangleUI{
    public var background:uint;
    public var cornerRadius:int;
    private var _width:int;
    private var _height:int;

    public function GridEmptyRectangleUI() {
    }

    public function drawIn(graphics:Graphics, row:int, col:int, borderWeight:int):void {
        graphics.beginFill(background);
        graphics.drawRoundRect(borderWeight+(width + borderWeight) * row, borderWeight+(height + borderWeight) * col, width, height, cornerRadius, cornerRadius);
    }

    public function get width():int {
        return _width;
    }

    public function get height():int {
        return _height;
    }

    public function set width(value:int):void {
        _width = value;
    }

    public function set height(value:int):void {
        _height = value;
    }
}
}
