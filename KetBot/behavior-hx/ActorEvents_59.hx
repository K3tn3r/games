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



class ActorEvents_59 extends ActorScript
{
	public var _speed:Float;
	public var _left:Bool;
	public var _isalive:Bool;
	public var _turntimer:Float;
	public var _stuck:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_death():Void
	{
		_isalive = false;
		propertyChanged("_isalive", _isalive);
		actor.setAnimation("" + "dead");
		runLater(1000 * .7, function(timeTask:TimedTask):Void
		{
			recycleActor(actor);
		}, actor);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("speed", "_speed");
		_speed = 15.0;
		nameMap.set("left", "_left");
		_left = false;
		nameMap.set("is alive", "_isalive");
		_isalive = true;
		nameMap.set("turn timer", "_turntimer");
		_turntimer = 0.0;
		nameMap.set("stuck", "_stuck");
		_stuck = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((!(_left) && _isalive))
				{
					actor.setXVelocity(-(_speed));
					actor.setAnimation("" + "walk left");
				}
				else if((_left && _isalive))
				{
					actor.setXVelocity(_speed);
					actor.setAnimation("" + "walk right");
				}
			}
		});
		
		/* ======================== Something Else ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				runLater(1000 * .05, function(timeTask:TimedTask):Void
				{
					if((((event.thisFromRight || event.thisFromLeft) && _isalive) && !(_stuck)))
					{
						_left = !(_left);
						propertyChanged("_left", _left);
						_turntimer = asNumber(3);
						propertyChanged("_turntimer", _turntimer);
						_stuck = true;
						propertyChanged("_stuck", _stuck);
						runLater(1000 * .5, function(timeTask:TimedTask):Void
						{
							_stuck = false;
							propertyChanged("_stuck", _stuck);
						}, actor);
					}
				}, actor);
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				for(point in event.points)
				{
					if(((getTileDataForCollision(event, point) == "turn tile") && !(_stuck)))
					{
						_left = !(_left);
						propertyChanged("_left", _left);
						_stuck = true;
						propertyChanged("_stuck", _stuck);
						runLater(1000 * .5, function(timeTask:TimedTask):Void
						{
							_stuck = false;
							propertyChanged("_stuck", _stuck);
						}, actor);
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(2), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((event.thisFromTop && _isalive))
				{
					actor.shout("_customEvent_" + "death");
				}
				else if((!(event.thisFromTop) && _isalive))
				{
					shoutToScene("_customEvent_" + "AndyDied");
					_left = !(_left);
					propertyChanged("_left", _left);
					_turntimer = asNumber(3);
					propertyChanged("_turntimer", _turntimer);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(77), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_isalive = false;
				propertyChanged("_isalive", _isalive);
				actor.setAnimation("" + "dead");
				runLater(1000 * .7, function(timeTask:TimedTask):Void
				{
					recycleActor(actor);
				}, actor);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}