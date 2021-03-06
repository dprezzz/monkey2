
Namespace std.geom

#rem monkeydoc @hidden
#end
Const EPSILON:=0

#rem monkeydoc @hidden
#end
Alias Quatf:Quat<Float>

#rem monkeydoc @hidden
#end
Class Quat<T>

	Field v:Vec3<T>
	Field w:T
	
	Method New()
		w=1
	End
	
	Method New( v:Vec3<T>,w:Float )
		Self.v=v; Self.w=w
	End
	
	Method New( vx:T,vy:T,vz:T,w:T )
		v.x=vx ; v.y=vy ; v.z=vz ; Self.w=w
	End
	
	Operator To<C>:Quat<C>()
		Return New Quat<C>( v,w )
	End
	
	Method To:String()
		Return "Quat("+v+","+w+")"
	End
	
	Property Length:Double()
		Return Sqrt( v.Dot(v) + w*w )
	End
	
	Property I:Vec3<T>()
		Local xz:=v.x*v.z , wy:=w*v.y
		Local xy:=v.x*v.y , wz:=w*v.z
		Local yy:=v.y*v.y , zz:=v.z*v.z
		Return New Vec3<T>( 1-2*(yy+zz),2*(xy-wz),2*(xz+wy) )
	End

	Property J:Vec3<T>()
		Local yz:=v.y*v.z , wx:=w*v.x
		Local xy:=v.x*v.y , wz:=w*v.z
		Local xx:=v.x*v.x , zz:=v.z*v.z
		Return New Vec3<T>( 2*(xy+wz),1-2*(xx+zz),2*(yz-wx) )
	End
	
	Property K:Vec3<T>()
		Local xz:=v.x*v.z , wy:=w*v.y
		Local yz:=v.y*v.z , wx:=w*v.x
		Local xx:=v.x*v.x , yy:=v.y*v.y
		Return New Vec3<T>( 2*(xz-wy),2*(yz+wx),1-2*(xx+yy) )
	End
	
	Operator-:Quat()
		Return New Quat( -v,w )
	End
	
	Operator+:Quat( q:Quat )
		Return New Quat( v+q.v,w+q.w )
	End
	
	Operator-:Quat( q:Quat )
		Return New Quat( v-q.v,w-q.w )
	End
	
	Operator*:Quat( q:Quat )
		Return New Quat( q.v.Cross( v )+q.v*w+v*q.w, w*q.w-v.Dot( q.v ) )
	End
	
	Operator*:Vec3<T>( v:Vec3<T> )
		Return (Self * New Quat( v,0 ) * -Self).v
	End
	
	Operator*:Quat( t:Double )
		Return New Quat( v*t,w*t )
	End
	
	Operator/:Quat( t:Double )
		Return New Quat( v/t,w/t )
	End
	
	Method GetYaw:Double()
		Return K.Yaw
	End
	
	Method GetPitch:Double()
		Return K.Pitch
	End
	
	Method GetRoll:Double()
		Return ATan2( I.y,J.y )
	End
	
	Method Dot:Double( q:Quat )
		Return v.x*q.v.x + v.y*q.v.y + v.z*q.v.z + w*q.w
	End
	
	Method Normalize:Quat()
		Return Self/Length
	End
	
	Method Slerp:Quat( q:Quat,a:Double )
		Local t:=q
		Local b:=1-a
		Local d:=Dot( q )
		If d<0 
			t.v=-t.v
			t.w=-t.w
			d=-d
		Endif
		If d<1-EPSILON
			Local om:=ACos( d )
			Local si:=Sin( om )
			a=Sin( a*om )/si
			b=Sin( b*om )/si
		Endif
		Return Self*b + t*a
	End
	
	Function Pitch:Quat( r:Double )
		Return New Quat( Sin( r/2 ),0,0,Cos( r/2 ) )
	End

	Function Yaw:Quat( r:Double )
		Return New Quat( 0,Sin( r/2 ),0,Cos( r/2 ) )
	End

	Function Roll:Quat( r:Double )
		Return New Quat( 0,0,Sin( r/2 ),Cos( r/2 ) )
	End

	Function Rotation:Quat( rv:Vec3<Double> )
		Return Yaw( rv.y ) * Pitch( rv.x ) * Roll( rv.z )
	End
	
	Function Rotation:Quat( rx:Double,ry:Double,rz:Double )
		Return Yaw( ry ) * Pitch( rx ) * Roll( rz )
	End

End
