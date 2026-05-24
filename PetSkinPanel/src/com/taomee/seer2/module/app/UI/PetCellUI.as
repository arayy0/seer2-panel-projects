package com.taomee.seer2.module.app.UI
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    [Embed(source="/_assets/assets.swf", symbol="PetCellUI")]
    public dynamic class PetCellUI extends MovieClip
    {
        public var content:MovieClip;

        public var nameTxt:TextField;

        public function PetCellUI()
        {
            super();
        }
    }
}

