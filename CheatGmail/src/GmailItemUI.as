package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol360")]
   public dynamic class GmailItemUI extends MovieClip
   {
      
      public var selectBtn:SimpleButton;
      
      public var simpleInfoTxt:TextField;
      
      public var senderNameTxt:TextField;
      
      public var readSymble:MovieClip;
      
      public var attachmentSymble:MovieClip;
      
      public var crossSymble:MovieClip;
      
      public var sendTimeTxt:TextField;
      
      public function GmailItemUI()
      {
         super();
      }
   }
}

