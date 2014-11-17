/**
 * Created by a.krasovsky on 17.11.2014.
 */
package core.managers.actuator.ui {
import com.greensock.easing.Ease;

import core.object.Tile;

import flash.display.IBitmapDrawable;

public interface ITileDisplayObject extends IBitmapDrawable{
    function get x():Number;
    function set x(value:Number):void;

    function get y():Number;
    function set y(value:Number):void;

    function get alpha():Number;
    function set alpha(value:Number):void;

    function show(animationType:Ease = null, animationTime:Number = .3):void

    function draw(tile:Tile, gridExternalParams:Object):void
}
}
