/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator.ui {
import animation.easy.MergeEase;

import com.bit101.components.PushButton;

import com.greensock.TweenLite;

import core.event.GameEvent;
import core.global.GlobalListener;
import core.global.IGlobalListener;
import core.global.globalEvent;
import core.global.listeners.GridUIGlobalListener;

import core.managers.actuator.TileSprite;
import core.object.Grid;
import core.object.Tile;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.setTimeout;
import mx.core.UIComponent;
import spark.components.Button;

public class GridUI extends UIComponent implements IGlobalListener{
    public var background:uint;
    public var cornerRadius:int;
    public var borderWeight:int;
    public var rect:GridEmptyRectangleUI = new GridEmptyRectangleUI();
    protected var container:Sprite = new Sprite();
    protected var _grid:Grid;
    protected var jsonGridParams:Object;
    protected var fadeButton:PushButton = new PushButton();
    protected var fade:Sprite;
    
    protected var emptyLayer:Shape;
    public var disabled:Boolean;

    public function GridUI() {
        init();
        emptyLayer = new Shape();
        addChild(emptyLayer);
        addChild(container);

    }

    protected function init():void {

    }

    protected function createFade():void {
        fade = new Sprite();
        fade.graphics.beginFill(0xFFFFFF, .8);
        var width:int =  this.width = borderWeight + (rect.width + borderWeight) * grid.size;
        var height:int = this.height = borderWeight + (rect.height + borderWeight) * grid.size;
        fade.graphics.drawRect(0, 0, width, height);
        addChild(fade);
        createFadeButton(fade);

        //fade.visible = false;
    }

    private function createFadeButton(parent:Sprite):void {
        fadeButton.label = "Play";
        fadeButton.x = (parent.width - fadeButton.width)/2;
        fadeButton.y = (parent.height - fadeButton.height)/2;
        parent.addChild(fadeButton);

        fadeButton.addEventListener(MouseEvent.CLICK, fadeButtonClickHandler);
    }

    public function setParamsFromObject(params:Object):void {
        jsonGridParams = params;
        for (var propertyName:String in params) {
            if (propertyName != "rect") {
                if (this.hasOwnProperty(propertyName)) {
                    this[propertyName] = params[propertyName];
                }
            } else {
                setEmptyRectangleParams(params[propertyName]);
            }

        }
    }

    private function setEmptyRectangleParams(params:Object):void {
        for (var propertyName:String in params) {
            if (rect.hasOwnProperty(propertyName)) {
                rect[propertyName] = params[propertyName];
            }

        }
    }

    public function redraw(grid:Grid):void {

        _grid = grid;
        if(!fade){
            createFade();
        }
        graphics.clear();

        //draw background rectangle
        graphics.beginFill(background);
        var width:int =  this.width = borderWeight + (rect.width + borderWeight) * grid.size;
        var height:int = this.height = borderWeight + (rect.height + borderWeight) * grid.size;
        graphics.drawRoundRect(0, 0, width, height, cornerRadius, cornerRadius);
        //draw empty rectangles
        for (var i:int = 0; i < _grid.size; i++) {
            for (var j:int = 0; j < _grid.size; j++) {
                rect.drawIn(emptyLayer.graphics, i, j, borderWeight);
            }
        }

    }

    public function get grid():Grid {
        return _grid;
    }

    public function updateGrid(grid:Grid):void {
        if(disabled){
            enable();
        }
        container.removeChildren();
        for (var i:int = 0; i < grid.cells.length; i++) {
            var column:Array = grid.cells[i];
            for (var j:int = 0; j < column.length; j++) {

                var tile:Tile = column[j];
                var tileSprite:ITileDisplayObject = createTile(tile, i, j);
                if(tileSprite){
                    var isNewTile:Boolean = tile.previousPosition == null;
                    if(isNewTile){
                        if(tile.mergedFrom == null && tile.hasOwnProperty("show")){
                            tileSprite.alpha = 0;
                            setTimeout(tileSprite.show, 200);
                        }else{
                            tileSprite.show(MergeEase.ease, .5);
                        }
                    }else{
                        TweenLite.to(tileSprite, .3, {x: columPosition(i), y: rowPositon(j)});
                    }
                }

            }

        }
    }

    private function createTile(tile:Tile, column:int, row:int):ITileDisplayObject {

        if (tile) {
            var graficTile:ITileDisplayObject = createFromTile(tile);
            //see if we have merged
            if(tile.mergedFrom){
                var tile1:Tile = tile.mergedFrom[0];
                var tile2:Tile = tile.mergedFrom[1];
                var s1:ITileDisplayObject = createTile(tile1, tile1.x, tile1.y);
                var s2:ITileDisplayObject = createTile(tile2, tile2.x, tile2.y);
                //              mergeAnimation.push([s1, .5, {x: columPosition(column), y: rowPositon(row)}]);
//                mergeAnimation.push([s2, .5, {x: columPosition(column), y: rowPositon(row)}]);
                TweenLite.to(s1, .5, {x: columPosition(column), y: rowPositon(row)});
                TweenLite.to(s2, .5, {x: columPosition(column), y: rowPositon(row)});
            }
            if(tile.previousPosition){
                graficTile.x = columPosition(tile.previousPosition.x);
                graficTile.y = rowPositon(tile.previousPosition.y);
            }else{
                graficTile.x = columPosition(column);
                graficTile.y = rowPositon(row);
            }

            if(graficTile is DisplayObject){
                container.addChild(graficTile as DisplayObject);
            }else{
                throw new Error("tile isn't DisplayObject, and can't added to container");
            }

            return graficTile;
        }

        return null;


    }

    private function rowPositon(row:int):int {
        return borderWeight + row * (rect.width + borderWeight);
    }

    private function columPosition(column:int):int {
        return borderWeight + column * (rect.width + borderWeight);
    }

    protected function createFromTile(tile:Tile):ITileDisplayObject {
        var sprite:TileSprite = new TileSprite();
        sprite.draw(tile, jsonGridParams);
        return sprite;
    }



    public function disable():void {
        fade.alpha = 0;
        fade.visible = true;
        TweenLite.to(fade, .5, {alpha: 1});
        disabled = true;
    }

    public function enable():void {
        TweenLite.to(fade, .5, {
            alpha: 0,
            onComplete: function():void{
                    fade.visible = false;
                    disabled = false;
                }
            }
        );
    }

    private function fadeButtonClickHandler(event:MouseEvent):void {
        globalEvent(GameEvent.RESTART);
    }

    private var _gridUIGlobalListener:GridUIGlobalListener;
    public function get listener():GlobalListener {
        if(!_gridUIGlobalListener) {
            _gridUIGlobalListener = new GridUIGlobalListener(this);
        }
        return _gridUIGlobalListener;
    }
}
}
