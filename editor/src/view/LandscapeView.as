package view {
    import as3isolib.display.scene.IsoScene;

    import events.ProxyEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.ContextMenuClipboardItems;
    import flash.utils.Dictionary;

    import model.LandscapeModel;
    import model.TileModel;

    import mx.core.UIComponent;

    import model.GlobalConfig;

    public class LandscapeView extends UIComponent {

        private var _dataProvider:LandscapeModel;
        private var scene:IsoScene;
        private var tileViewByModel:Dictionary = new Dictionary();

        override protected function createChildren():void {
            super.createChildren();

            scene = new IsoScene();
            scene.hostContainer = this;

            updateView();
        }

        public function get dataProvider():LandscapeModel {
            return _dataProvider;
        }

        public function set dataProvider(value:LandscapeModel):void {
            if (_dataProvider != value) {

                _dataProvider = value;

                updateView();
            }
        }

        private function updateView():void {
            clearView();

            if (_dataProvider) {
                for each (var tileModel:TileModel in _dataProvider.tiles) {
                    var tileView:TileView = new TileView(tileModel);
                    tileView.addEventListener(MouseEvent.CLICK, onClick);
                    tileModel.addEventListener(Event.CHANGE, onChangeTileModel);
                    tileViewByModel[tileModel] = tileView;

                    tileView.x = (tileModel.index % GlobalConfig.COLS) * tileModel.width;
                    tileView.y = Math.floor(tileModel.index / GlobalConfig.COLS) * tileModel.length;

                    scene.addChild(tileView);
                }
            }
            scene.render();
        }

        private function onChangeTileModel(event:Event):void {
            var tileModel:TileModel = TileModel(event.currentTarget);
            var tileView:TileView = tileViewByModel[tileModel];

            tileView.update();
            scene.render();
        }

        private function clearView():void {
            for (var key:Object in tileViewByModel) {
                var tileModel:TileModel = TileModel(key);
                if (tileModel.hasEventListener(Event.CHANGE)) {
                    tileModel.removeEventListener(Event.CHANGE, onChangeTileModel);
                }

                var tileView:TileView = tileViewByModel[tileModel];
                if (tileView.hasEventListener(MouseEvent.CLICK)) {
                    tileView.removeEventListener(MouseEvent.CLICK, onClick);
                }

                delete tileViewByModel[tileModel];
            }

            scene.removeAllChildren();
        }

        private function onClick(event:ProxyEvent):void {
            var tileView:TileView = TileView(event.target);
            var tileModel:TileModel = tileView.model;

            _dataProvider.selectedTile = tileModel;

            tileView.update();
            scene.render();
        }
    }
}
