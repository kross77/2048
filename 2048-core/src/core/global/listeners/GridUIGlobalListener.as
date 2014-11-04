/**
 * Created by a.krasovsky on 04.11.2014.
 */
package core.global.listeners {
import core.event.GameEvent;
import core.global.GlobalListener;
import core.managers.actuator.ui.GridUI;

public class GridUIGlobalListener extends GlobalListener {
    private var grid:GridUI;
    public function GridUIGlobalListener(gridUI:GridUI) {
        grid = gridUI;
        super(grid);
        add(restartCallback, GameEvent.RESTART);
    }

    private function restartCallback(data:Object):void {
        grid.enable();
    }
}
}
