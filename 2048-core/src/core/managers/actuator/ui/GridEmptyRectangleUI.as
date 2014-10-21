/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator.ui {
import flash.display.Graphics;

public class GridEmptyRectangleUI {
    public var background:uint;
    public var cornerRadius:int;
    public var width:int;
    public var height:int;

    public function GridEmptyRectangleUI() {
    }

    public function drawIn(graphics:Graphics, row:int, col:int, borderWeight:int):void {
        graphics.beginFill(background);
        graphics.drawRoundRect(borderWeight+(width + borderWeight) * row, borderWeight+(height + borderWeight) * col, width, height, cornerRadius, cornerRadius);
    }
}
}
