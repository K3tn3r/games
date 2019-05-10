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
	public var _Lives:Float;
	public var _StartLives:Float;
	public var _isJumping:Bool;
	public var _isShooting:Bool;
	public var _InAir2:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dead():Void
	{
		if(_isalive)
		{
			Engine.engine.setGameAttribute("shoot", false);
			_isalive = false;
			propertyChanged("_isalive", _isalive);
			actor.setAnimation("" + "dead");
			runLater(1000 * .5, function(timeTask:TimedTask):Void
			{
				reloadCurrentScene(createFadeOut(1, Utils.getColorRGB(0,0,0)), createCircleIn(.5, Utils.getColorRGB(0,0,0)));
			}, actor);
			Engine.engine.setGameAttribute("Lives", (Engine.engine.getGameAttribute("Lives") + 1));
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("speed", "_speed");
		_speed = 20.0;
		nameMap.set("direction", "_direction");
		_direction = "right";
		nameMap.set("jump", "_jump");
		_jump = -30.0;
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
		nameMap.set("Lives", "_Lives");
		_Lives = 3.0;
		nameMap.set("StartLives", "_StartLives");
		_StartLives = 0.0;
		nameMap.set("isJumping", "_isJumping");
		_isJumping = false;
		nameMap.set("isShooting", "_isShooting");
		_isShooting = false;
		nameMap.set("InAir2", "_InAir2");
		_InAir2 = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.setX(Engine.engine.getGameAttribute("Spawn X"));
		actor.setY(Engine.engine.getGameAttribute("Spawn Y"));
		actor.setAnimation("" + "idle right");
		_speed = asNumber(20);
		propertyChanged("_speed", _speed);
		actor.setActorValue("on ground?", false);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("x of Andy", actor.getX());
				Engine.engine.setGameAttribute("Y of Andy", actor.getY());
				if((_isalive && !(_isJumping)))
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
				if(!(_touchfloor))
				{
					actor.setFriction(0);
				}
				else
				{
					actor.setFriction(.2);
				}
				if(_isalive)
				{
					if(((isKeyDown("up") && !(isKeyDown("left"))) && _touchfloor))
					{
						_isJumping = true;
						propertyChanged("_isJumping", _isJumping);
						actor.setAnimation("" + "Jump right");
						actor.setYVelocity(_jump);
						_touchfloor = false;
						propertyChanged("_touchfloor", _touchfloor);
						runLater(1000 * .2, function(timeTask:TimedTask):Void
						{
							_inair = true;
							propertyChanged("_inair", _inair);
							_isJumping = false;
							propertyChanged("_isJumping", _isJumping);
						}, actor);
					}
					else if(((isKeyDown("up") && isKeyDown("left")) && _touchfloor))
					{
						_isJumping = true;
						propertyChanged("_isJumping", _isJumping);
						actor.setAnimation("" + "Jump left");
						actor.setYVelocity(_jump);
						_touchfloor = false;
						propertyChanged("_touchfloor", _touchfloor);
						runLater(1000 * .2, function(timeTask:TimedTask):Void
						{
							_inair = true;
							propertyChanged("_inair", _inair);
							_isJumping = false;
							propertyChanged("_isJumping", _isJumping);
						}, actor);
					}
					else if(((isKeyDown("up") && !(isKeyDown("left"))) && _inair))
					{
						_isJumping = true;
						propertyChanged("_isJumping", _isJumping);
						actor.setAnimation("" + "Jump right");
						actor.setYVelocity(_jump);
						_inair = false;
						propertyChanged("_inair", _inair);
						runLater(1000 * .3, function(timeTask:TimedTask):Void
						{
							_InAir2 = true;
							propertyChanged("_InAir2", _InAir2);
							_isJumping = false;
							propertyChanged("_isJumping", _isJumping);
						}, actor);
					}
					else if(((isKeyDown("up") && isKeyDown("left")) && _inair))
					{
						_isJumping = true;
						propertyChanged("_isJumping", _isJumping);
						actor.setAnimation("" + "Jump left");
						actor.setYVelocity(_jump);
						_inair = false;
						propertyChanged("_inair", _inair);
						runLater(1000 * .3, function(timeTask:TimedTask):Void
						{
							_InAir2 = true;
							propertyChanged("_InAir2", _InAir2);
							_isJumping = false;
							propertyChanged("_isJumping", _isJumping);
						}, actor);
					}
					else if((((isKeyDown("up") && !(isKeyDown("left"))) && _InAir2) && Engine.engine.getGameAttribute("Jump3")))
					{
						_isJumping = true;
						propertyChanged("_isJumping", _isJumping);
						actor.setAnimation("" + "Jump right");
						actor.setYVelocity(_jump);
						_InAir2 = false;
						propertyChanged("_InAir2", _InAir2);
						runLater(1000 * .3, function(timeTask:TimedTask):Void
						{
							_isJumping = false;
							propertyChanged("_isJumping", _isJumping);
						}, actor);
					}
					else if((((isKeyDown("up") && isKeyDown("left")) && _InAir2) && Engine.engine.getGameAttribute("Jump3")))
					{
						_isJumping = true;
						propertyChanged("_isJumping", _isJumping);
						actor.setAnimation("" + "Jump left");
						actor.setYVelocity(_jump);
						_InAir2 = false;
						propertyChanged("_InAir2", _InAir2);
						runLater(1000 * .3, function(timeTask:TimedTask):Void
						{
							_isJumping = false;
							propertyChanged("_isJumping", _isJumping);
						}, actor);
					}
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((event.thisFromBottom && event.otherFromTop))
				{
					_touchfloor = true;
					propertyChanged("_touchfloor", _touchfloor);
				}
				else if(((event.thisFromLeft && event.otherFromRight) || (event.thisFromLeft && event.otherFromRight)))
				{
					_touchfloor = false;
					propertyChanged("_touchfloor", _touchfloor);
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(Engine.engine.getGameAttribute("shoot"))
				{
					if((Engine.engine.getGameAttribute("N of Bullet") < 1))
					{
						if(((isKeyPressed("Shoot") && _isalive) && (_direction == "right")))
						{
							_isShooting = true;
							propertyChanged("_isShooting", _isShooting);
							Engine.engine.setGameAttribute("left", false);
							createRecycledActor(getActorType(77), (Engine.engine.getGameAttribute("x of Andy") + 15), (Engine.engine.getGameAttribute("Y of Andy") + 15), Script.FRONT);
						}
						else if(((isKeyPressed("Shoot") && _isalive) && (_direction == "left")))
						{
							_isShooting = true;
							propertyChanged("_isShooting", _isShooting);
							Engine.engine.setGameAttribute("left", true);
							createRecycledActor(getActorType(77), (Engine.engine.getGameAttribute("x of Andy") - 15), (Engine.engine.getGameAttribute("Y of Andy") + 15), Script.FRONT);
							Engine.engine.setGameAttribute("left", false);
						}
					}
				}
				else if(Engine.engine.getGameAttribute("shoot2"))
				{
					if((Engine.engine.getGameAttribute("N of Bullet") < 3))
					{
						if(((isKeyPressed("Shoot") && _isalive) && (_direction == "right")))
						{
							_isShooting = true;
							propertyChanged("_isShooting", _isShooting);
							Engine.engine.setGameAttribute("left", false);
							createRecycledActor(getActorType(93), (Engine.engine.getGameAttribute("x of Andy") + 15), (Engine.engine.getGameAttribute("Y of Andy") + 25), Script.FRONT);
							createRecycledActor(getActorType(93), (Engine.engine.getGameAttribute("x of Andy") + 15), (Engine.engine.getGameAttribute("Y of Andy") + 15), Script.FRONT);
							createRecycledActor(getActorType(93), (Engine.engine.getGameAttribute("x of Andy") + 15), (Engine.engine.getGameAttribute("Y of Andy") + 5), Script.FRONT);
						}
						else if(((isKeyPressed("Shoot") && _isalive) && (_direction == "left")))
						{
							_isShooting = true;
							propertyChanged("_isShooting", _isShooting);
							Engine.engine.setGameAttribute("left", true);
							createRecycledActor(getActorType(93), (Engine.engine.getGameAttribute("x of Andy") - 15), (Engine.engine.getGameAttribute("Y of Andy") + 25), Script.FRONT);
							createRecycledActor(getActorType(93), (Engine.engine.getGameAttribute("x of Andy") - 15), (Engine.engine.getGameAttribute("Y of Andy") + 15), Script.FRONT);
							createRecycledActor(getActorType(93), (Engine.engine.getGameAttribute("x of Andy") - 15), (Engine.engine.getGameAttribute("Y of Andy") + 5), Script.FRONT);
						}
					}
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(4),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_touchfloor = true;
				propertyChanged("_touchfloor", _touchfloor);
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(6),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_touchfloor = true;
				propertyChanged("_touchfloor", _touchfloor);
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(7),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_touchfloor = true;
				propertyChanged("_touchfloor", _touchfloor);
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(14),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_touchfloor = true;
				propertyChanged("_touchfloor", _touchfloor);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getScreenY() > getScreenHeight()))
				{
					actor.shout("_customEvent_" + "dead");
				}
				else if((actor.getScreenY() > getScreenHeight()))
				{
					actor.shout("_customEvent_" + "dead");
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(83), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.shout("_customEvent_" + "dead");
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(Engine.engine.getGameAttribute("NoTime")))
				{
					if((Engine.engine.getGameAttribute("Time") <= 0))
					{
						actor.shout("_customEvent_" + "dead");
					}
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getScreenX() < 0))
				{
					actor.setX(1);
				}
				else if((actor.getScreenX() > (getScreenWidth() - (actor.getWidth()))))
				{
					actor.setX((getScreenWidth() - ((actor.getWidth()) - 1)));
				}
				else if((actor.getScreenY() < 0))
				{
					actor.setY(1);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}