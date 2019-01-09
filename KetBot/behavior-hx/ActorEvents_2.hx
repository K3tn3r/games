package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

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

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
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

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

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



class ActorEvents_2 extends ActorScript
{
	public var _speed:Float;
	public var _direction:String;
	public var _jump:Float;
	public var _touchfloor:Bool;
	public var _inair:Bool;
	public var _dead:Bool;
	public var _score:Float;
	public var _isalive:Bool;
	public var _RunSpeed:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_killBlob():Void
	{
		_score = asNumber((_score + 1));
		propertyChanged("_score", _score);
		Engine.engine.setGameAttribute("score", _score);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dead():Void
	{
		_isalive = false;
		propertyChanged("_isalive", _isalive);
		actor.setAnimation("" + "dead");
		runLater(1000 * 1.6, function(timeTask:TimedTask):Void
		{
			recycleActor(actor);
		}, actor);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("speed", "_speed");
		_speed = 20.0;
		nameMap.set("direction", "_direction");
		_direction = "right";
		nameMap.set("jump", "_jump");
		_jump = -28.0;
		nameMap.set("touchfloor", "_touchfloor");
		_touchfloor = true;
		nameMap.set("inair", "_inair");
		_inair = false;
		nameMap.set("dead", "_dead");
		_dead = false;
		nameMap.set("score", "_score");
		_score = 0.0;
		nameMap.set("is alive", "_isalive");
		_isalive = true;
		nameMap.set("RunSpeed", "_RunSpeed");
		_RunSpeed = 30.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.setAnimation("" + "idle right");
		_speed = asNumber(20);
		propertyChanged("_speed", _speed);
		actor.setActorValue("on ground?", false);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_isalive)
				{
					if(isKeyDown("right"))
					{
						actor.setXVelocity(_speed);
						_direction = "right";
						propertyChanged("_direction", _direction);
						actor.setAnimation("" + "walk right");
					}
					else if(isKeyDown("left"))
					{
						actor.setXVelocity(-(_speed));
						_direction = "left";
						propertyChanged("_direction", _direction);
						actor.setAnimation("" + "walk left");
					}
					else
					{
						actor.setXVelocity(0);
						if((_direction == "right"))
						{
							actor.setAnimation("" + "idle right");
						}
						else if((_direction == "left"))
						{
							actor.setAnimation("" + "idle left");
						}
					}
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((isKeyDown("up") && (_touchfloor == true)))
				{
					actor.setYVelocity(_jump);
					_touchfloor = false;
					propertyChanged("_touchfloor", _touchfloor);
					runLater(1000 * .2, function(timeTask:TimedTask):Void
					{
						_inair = true;
						propertyChanged("_inair", _inair);
					}, actor);
				}
				else if((isKeyDown("up") && (_inair == true)))
				{
					actor.setYVelocity(_jump);
					_inair = false;
					propertyChanged("_inair", _inair);
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_touchfloor = true;
				propertyChanged("_touchfloor", _touchfloor);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}