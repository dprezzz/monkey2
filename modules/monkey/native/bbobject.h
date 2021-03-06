
#ifndef BB_OBJECT_H
#define BB_OBJECT_H

#include "bbgc.h"
#include "bbstring.h"
#include "bbdebug.h"

struct bbObject : public bbGCNode{

	typedef bbObject *bb_object_type;

	bbObject(){
		bbGC::beginCtor( this );
	}
	
	virtual ~bbObject();

	//implemented in bbtypeinfo.h
	//	
	virtual bbTypeInfo *typeof()const;
	
	virtual const char *typeName()const;
	
	void *operator new( size_t size ){
		return bbGC::alloc( size );
	}
	
	//NOTE! We need this in case ctor throws an exception. delete never otherwise called...
	//
	void operator delete( void *p ){
		bbGC::endCtor( (bbObject*)(p) );
	}
};

struct bbThrowable : public bbObject{
};

struct bbInterface{

	typedef bbInterface *bb_object_type;

	virtual ~bbInterface();
};

struct bbNullCtor_t{
};

extern bbNullCtor_t bbNullCtor;

template<class T,class...A> T *bbGCNew( A...a ){
	T *p=new T( a... );
	bbGC::endCtor( p );
	return p;
}

template<class T,class R=typename T::bb_object_type> void bbGCMark( T *p ){
	bbGC::enqueue( dynamic_cast<bbObject*>( p ) );
}

template<class T,class C> T bb_object_cast( const bbGCVar<C> &p ){
	return dynamic_cast<T>( p._ptr );
}

template<class T,class C> T bb_object_cast( C *p ){
	return dynamic_cast<T>( p );
}

inline void bbDBAssertSelf( void *p ){
	bbDebugAssert( p,"'Self' is null" );
}

inline bbString bbDBObjectValue( bbObject *p ){
	char buf[64];
	sprintf( buf,"@%p",p );
	return buf;
}

inline bbString bbDBInterfaceValue( bbInterface *p ){
	return bbDBObjectValue( dynamic_cast<bbObject*>( p ) );
}

template<class T> bbString bbDBStructValue( T *p ){
	char buf[64];
	sprintf( buf,"@%p:%p",p,&T::dbEmit );
	return buf;
}

inline bbString bbDBType( bbObject **p ){
	return "Object";
}

inline bbString bbDBValue( bbObject **p ){
	return bbDBObjectValue( *p );
}

#endif
