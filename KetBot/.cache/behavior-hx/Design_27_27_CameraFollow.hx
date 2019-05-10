package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.graphics.ScaleMode;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Config;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.motion.*;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_27_27_CameraFollow extends ActorScript
{
	public var _intendedCameraX:Float;
	public var _intendedCameraY:Float;
	public var _currentCameraX:Float;
	public var _currentCameraY:Float;
	public var _ScrollSpeed:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("intendedCameraX", "_intendedCameraX");
		_intendedCameraX = 0.0;
		nameMap.set("intendedCameraY", "_intendedCameraY");
		_intendedCameraY = 0.0;
		nameMap.set("currentCameraX", "_currentCameraX");
		_currentCameraX = 0.0;
		nameMap.set("currentCameraY", "_currentCameraY");
		_currentCameraY = 0.0;
		nameMap.set("Scroll Speed", "_ScrollSpeed");
		_ScrollSpeed = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_intendedCameraX = (Engine.engine.getGameAttribute("Spawn X") : Float);
		_intendedCameraY = (Engine.engine.getGameAttribute("Spawn Y") : Float);
		_currentCameraX = (Engine.engine.getGameAttribute("Spawn X") : Float);
		_currentCameraY = (Engine.engine.getGameAttribute("Spawn Y") : Float);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_intendedCameraX = actor.getXCenter();
				_intendedCameraY = actor.getYCenter();
				if(!(_currentCameraX == _intendedCameraX))
				{
					if(!(Math.abs(_ScrollSpeed) == 0))
					{
						if((_currentCameraX < (_intendedCameraX - _ScrollSpeed)))
						{
							_currentCameraX += Math.abs(_ScrollSpeed);
						}
						else if((_currentCameraX > (_intendedCameraX + _ScrollSpeed)))
						{
							_currentCameraX -= Math.abs(_ScrollSpeed);
						}
						else
						{
							_currentCameraX = _intendedCameraX;
						}
					}
					else
					{
						_currentCameraX = _intendedCameraX;
					}
				}
				if(!(_currentCameraY == _intendedCameraY))
				{
					if(!(Math.abs(_ScrollSpeed) == 0))
					{
						if((_currentCameraY < (_intendedCameraY - _ScrollSpeed)))
						{
							_currentCameraY += Math.abs(_ScrollSpeed);
						}
						else if((_currentCameraY > (_intendedCameraY + _ScrollSpeed)))
						{
							_currentCameraY -= Math.abs(_ScrollSpeed);
						}
						else
						{
							_currentCameraY = _intendedCameraY;
						}
					}
					else
					{
						_currentCameraY = _intendedCameraY;
					}
				}
				engine.moveCamera(_currentCameraX, _currentCameraY);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}