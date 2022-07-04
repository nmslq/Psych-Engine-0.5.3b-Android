package android.flixel;

import android.flixel.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

/**
 * A hitbox.
 * It's easy to set the callbacks and to customize the layout.
 *
 * @original author: luckydog
 * @modifications author: Saw (M.A. Jigsaw)
 */
@:keep @:bitmap("assets/preload/images/android/hitbox.png")
class GraphicHitboxInput extends BitmapData {}

@:keep @:file("assets/preload/images/android/hitbox.xml")
class DataHitboxInput extends #if (lime_legacy || nme) ByteArray #else ByteArrayData #end {}

class FlxHitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	public var hintLeft:FlxSprite;
	public var hintDown:FlxSprite;
	public var hintUp:FlxSprite;
	public var hintRight:FlxSprite;

	/**
	 * Group of the hint buttons.
	 */
	public var hitbox:FlxSpriteGroup;

	/**
	 * Create a hitbox.
	 */
	public function new()
	{
		super();

		scrollFactor.set();

		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();

		hitbox.add(add(buttonLeft = createHitbox(0, 0, 'left', 0xFFFF00FF)));
		hitbox.add(add(buttonDown = createHitbox(FlxG.width / 4, 0, 'down', 0xFF00FFFF)));
		hitbox.add(add(buttonUp = createHitbox(FlxG.width / 2, 0, 'up', 0xFF00FF00)));
		hitbox.add(add(buttonRight = createHitbox((FlxG.width / 2) + (FlxG.width / 4), 0, 'right', 0xFFFF0000)));

		hitbox.add(add(hintLeft = createHitboxHint(0, 0, 'left_hint', 0xFFFF00FF)));
		hitbox.add(add(hintDown = createHitboxHint(FlxG.width / 4, 0, 'down_hint', 0xFF00FFFF)));
		hitbox.add(add(hintUp = createHitboxHint(FlxG.width / 2, 0, 'up_hint', 0xFF00FF00)));
		hitbox.add(add(hintRight = createHitboxHint((FlxG.width / 2) + (FlxG.width / 4), 0, 'right_hint', 0xFFFF0000)));
	}

	override function destroy()
	{
		super.destroy();

		hitbox = FlxDestroyUtil.destroy(hitbox);
		hitbox = null;

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;

		hintLeft = null;
		hintDown = null;
		hintUp = null;
		hintRight = null;
	}

	/**
	 * @param   X          The x-position of the button.
	 * @param   Y          The y-position of the button.
	 * @param   Color      The color of the button.
	 * @param   Callback   The callback for the button.
	 * @return  The button
	 */
	public function createHitbox(X:Float, Y:Float, Graphic:String, ?Color:Int, ?OnClick:Void->Void):FlxButton
	{
		var button:FlxButton = new FlxButton(X, Y);
		button.loadGraphic(FlxGraphic.fromFrame(getHitboxInputFrames().getByName(Graphic)));
		button.setGraphicSize(Std.int(FlxG.width / 4), FlxG.height);
		button.updateHitbox();
		button.alpha = 0.00001;

		var tween:FlxTween = null;

		button.onDown.callback = function()
		{
			if (tween != null)
				tween.cancel();

			tween = FlxTween.num(button.alpha, 0.6, 0.06, {ease: FlxEase.circInOut}, function(value:Float)
			{
				button.alpha = value;
			});
		}

		button.onUp.callback = function()
		{
			if (tween != null)
				tween.cancel();

			tween = FlxTween.num(button.alpha, 0.00001, 0.15, {ease: FlxEase.circInOut}, function(value:Float)
			{
				button.alpha = value;
			});
		}

		button.onOut.callback = function()
		{
			if (tween != null)
				tween.cancel();

			tween = FlxTween.num(button.alpha, 0.00001, 0.15, {ease: FlxEase.circInOut}, function(value:Float)
			{
				button.alpha = value;
			});
		}

		if (Color != null)
			button.color = Color;

		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end

		if (OnClick != null)
			button.onDown.callback = OnClick;

		return button;
	}

	public function createHitboxHint(x:Float = 0, y:Float = 0, frames:String, ?color:Int):FlxSprite
	{
		var hint:FlxSprite = new FlxSprite(x, y);
		hint.loadGraphic(FlxGraphic.fromFrame(getFrames().getByName(frames)));
		hint.alpha = 0.75;
		hint.antialiasing = ClientPrefs.globalAntialiasing;
		if (color != null)
			hint.color = color;
		return hint;
	}

	public function getFrames():FlxAtlasFrames
	{
		return Paths.getSparrowAtlas('android/hitbox');
	}

	public static function getHitboxInputFrames():FlxAtlasFrames
	{
		var bitmapData:BitmapData = new GraphicHitboxInput(0, 0);

		#if html5 // dirty hack for openfl/openfl#682
		Reflect.setProperty(bitmapData, "width", 1280);
		Reflect.setProperty(bitmapData, "height", 720);
		#end

		return FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(bitmapData), Std.string(new DataHitboxInput()));
	}
}