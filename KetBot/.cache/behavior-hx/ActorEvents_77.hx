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



class ActorEvents_77 extends ActorScript
{
	public var _direction:String;
	public var _stuck:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("direction", "_direction");
		_direction = "right";
		nameMap.set("stuck", "_stuck");
		_stuck = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		if(!((Engine.engine.getGameAttribute("left") : Bool)))
		{
			Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) + 1));
			actor.applyImpulse(6400, 0, 50);
			actor.setAnimation("shot");
			runLater(1000 * 1, function(timeTask:TimedTask):Void
			{
				recycleActor(actor);
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
			}, actor);
		}
		else if((Engine.engine.getGameAttribute("left") : Bool))
		{
			Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) + 1));
			actor.applyImpulse(-1, 0, 50);
			actor.setAnimation("shot1");
			runLater(1000 * 1, function(timeTask:TimedTask):Void
			{
				recycleActor(actor);
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
			}, actor);
		}
		
		/* ======================== Specific Actor ======================== */
		addActorPositionListener(actor, function(enteredScreen:Bool, exitedScreen:Bool, enteredScene:Bool, exitedScene:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && exitedScreen)
			{
				recycleActor(actor);
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				recycleActor(actor);
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(77), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				recycleActor(event.otherActor);
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(7), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
				runLater(1000 * .01, function(timeTask:TimedTask):Void
				{
					recycleActor(actor);
				}, actor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(53), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
				runLater(1000 * .01, function(timeTask:TimedTask):Void
				{
					recycleActor(actor);
				}, actor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(59), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
				runLater(1000 * .01, function(timeTask:TimedTask):Void
				{
					recycleActor(actor);
				}, actor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(0), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
				runLater(1000 * .01, function(timeTask:TimedTask):Void
				{
					recycleActor(actor);
				}, actor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(102), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				Engine.engine.setGameAttribute("N of Bullet", ((Engine.engine.getGameAttribute("N of Bullet") : Float) - 1));
				runLater(1000 * .01, function(timeTask:TimedTask):Void
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