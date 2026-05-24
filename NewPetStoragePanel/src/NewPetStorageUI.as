package
{
import flash.display.MovieClip;
import flash.display.SimpleButton;

[Embed(source="/_assets/assets.swf", symbol="NewPetStorageUI")]
public dynamic class NewPetStorageUI extends MovieClip
{


    public var bagPets:MovieClip;

    public var closeBtn:SimpleButton;

    public var oldPetStorageBtn:SimpleButton;

    public var petBagBtn:SimpleButton;

    public var petInfo:MovieClip;

    public var storage:MovieClip;

    public function NewPetStorageUI()
    {
        super();
    }
}
}