Class {
	#name : #MDBEnvironment,
	#superclass : #MDBHandle,
	#category : #'LightningMDB-Core'
}

{ #category : #'instance creation' }
MDBEnvironment class >> create [

	| instance result |
	
	result := self primCreate: (instance := self new).
	result = 0
		ifFalse: [ self error: '' ].
		
	instance registerAsExternalResource.

	^instance
]

{ #category : #'as yet unclassified' }
MDBEnvironment class >> finalizeResourceData: aHandle [

	Transcript cr;show: 'Fin....';cr.

	aHandle isNull
		ifFalse: [ 
			self primClose: aHandle value. 
			aHandle value: 0 ]
]

{ #category : #'instance creation' }
MDBEnvironment class >> open: aPath [

	^self open: aPath flags: 0
]

{ #category : #'instance creation' }
MDBEnvironment class >> open: aPath flags: aFlagsInt [

	^self open: aPath flags: aFlagsInt mode: 8r664
]

{ #category : #'instance creation' }
MDBEnvironment class >> open: aPath flags: aFlagsInt mode: aModeInt [

	^self create open: aPath flags: aFlagsInt mode: aModeInt

]

{ #category : #primitives }
MDBEnvironment class >> primClose: aHandle [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_close ( void* aHandle ) )
]

{ #category : #primitives }
MDBEnvironment class >> primCreate: aMDBEnvironment [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_create ( MDBEnvironment *aMDBEnvironment ) )
]

{ #category : #primitives }
MDBEnvironment class >> primMDBVersion [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^ self nbCall: #( String mdb_version (nil, nil, nil ) ) 
		
	"self primMDBVersion"
]

{ #category : #public }
MDBEnvironment class >> version [

	^self primMDBVersion
]

{ #category : #'as yet unclassified' }
MDBEnvironment >> beginReadTransaction [

	^MDBTransaction begin: self parent: nil flags: MDB_RDONLY
]

{ #category : #'as yet unclassified' }
MDBEnvironment >> beginTransaction [

	^MDBTransaction begin: self parent: nil flags: 0
]

{ #category : #'initialize-release' }
MDBEnvironment >> close [

	self primClose.
	self handle: 0
]

{ #category : #primitives }
MDBEnvironment >> maxkeysize [

	^self primGetMaxkeysize
]

{ #category : #'instance creation' }
MDBEnvironment >> open: aPath [

	self open: aPath flags: 0 mode: 8r664
]

{ #category : #'instance creation' }
MDBEnvironment >> open: aPath flags: aFlagsInt mode: aModeInt [

	| result buf |
	
	buf := NBExternalAddress fromString: aPath.
	
	result := self primOpen: buf flags: aFlagsInt mode: aModeInt.
	buf free.
	result = 0
		ifFalse: [ self mdbError: result ].
]

{ #category : #primitives }
MDBEnvironment >> primClose [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_close ( MDBEnvironment self ) )
]

{ #category : #primitives }
MDBEnvironment >> primDbiClose: aMDBDbi [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( void mdb_dbi_close ( MDBEnvironment self, MDB_dbi aMDBDbi ) )
]

{ #category : #primitives }
MDBEnvironment >> primGetMaxkeysize [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_get_maxkeysize ( MDBEnvironment self ) )
]

{ #category : #primitives }
MDBEnvironment >> primOpen: aPath flags: aFlagsInt mode: aModeInt [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_open ( MDBEnvironment self, void* aPath, uint aFlagsInt, uint aModeInt) )
]

{ #category : #primitives }
MDBEnvironment >> primSetMapsize: anInteger [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_set_mapsize ( MDBEnvironment self, size_t anInteger ) )
]

{ #category : #primitives }
MDBEnvironment >> primSetMaxdbs: anInteger [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_set_maxdbs ( MDBEnvironment self, uint anInteger ) )
]

{ #category : #primitives }
MDBEnvironment >> primStat: aMDBStat [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_env_stat ( MDBEnvironment self, MDBStat *aMDBStat ) )
]

{ #category : #'initialize-release' }
MDBEnvironment >> resourceData [

	^handle
]

{ #category : #'as yet unclassified' }
MDBEnvironment >> setMapsize: anInteger [
	"Set the size of the memory map to use for this environment."

	| result |
	
	result := self primSetMapsize: anInteger.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'as yet unclassified' }
MDBEnvironment >> setMaxdbs: anInteger [

	| result |
	
	result := self primSetMaxdbs: anInteger.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'as yet unclassified' }
MDBEnvironment >> stat [
	"Return statistics about this MDB environment."

	| struct |
	
	struct := MDBStat new.
	self primStat: struct.
	^struct
]
