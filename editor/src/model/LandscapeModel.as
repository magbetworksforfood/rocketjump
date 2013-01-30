package model {
    import model.GlobalConfig;

    import view.TileView;

    public class LandscapeModel {

        public var index:uint;
        public var tiles:Vector.<TileModel> = new <TileModel>[];
        private var _selectedTile:TileModel;

        public function LandscapeModel(index:uint, empty:Boolean = true) {
            init(index, empty);
        }

        private function init(index:uint, empty:Boolean):void {
            this.index = index;

            if (!empty) {
                var length:uint = GlobalConfig.COLS * GlobalConfig.ROWS;
                for (var i:uint = 0; i < length; i++) {
                    var tile:TileModel = new TileModel(i);
                    tiles.push(tile);
                }
            }
        }

        [Bindable]
        public function get selectedTile():TileModel {
            return _selectedTile;
        }

        public function set selectedTile(value:TileModel):void {
            if (_selectedTile != value) {
                if (_selectedTile) {
                    _selectedTile.selected = false;
                }

                _selectedTile = value;

                _selectedTile.selected = true;
            }
        }
    }
}
