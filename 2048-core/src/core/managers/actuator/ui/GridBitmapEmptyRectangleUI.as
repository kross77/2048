/**
 * Created by a.krasovsky on 17.11.2014.
 */
package core.managers.actuator.ui {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;

public class GridBitmapEmptyRectangleUI extends GridEmptyRectangleUI {
    [Embed(source="../../../../../../resources/standart-skin.png")]
    public static var Skin:Class;
    public function GridBitmapEmptyRectangleUI() {
        super();
    }


    override public function drawIn(graphics:Graphics, row:int, col:int, borderWeight:int):void {

        //get bitmap data from Atlas
        var bd:BitmapData = new Skin().bitmapData;
        var rectBD:BitmapData = new BitmapData(width, height, true, 0x00ffffff);
        var m:Matrix = new Matrix();
        m.translate(-width, 0);
        rectBD.draw(bd, m);

        //draw empty rectangle
        var m2:Matrix = new Matrix();
        m2.translate(borderWeight+borderWeight*row, borderWeight+borderWeight*col);
        graphics.beginBitmapFill(rectBD, m2);
        graphics.drawRect(borderWeight+(width + borderWeight) * row, borderWeight+(height + borderWeight) * col, width, height);

    }
}
}
