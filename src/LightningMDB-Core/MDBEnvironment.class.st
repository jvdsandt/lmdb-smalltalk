"
A MDBEnvironemnt provides access to MDB_env related functionality.
"
Class {
	#name : #MDBEnvironment,
	#superclass : #MDBHandle,
	#instVars : [
		'resourceData'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'instance creation' }
MDBEnvironment class >> create [

	| instance result |
	
	result := self primCreate: (instance := self new).
	result = 0
		ifFalse: [ self error: '' ].
		
	instance autoRelease.

	^instance
]

{ #category : #cleanup }
MDBEnvironment class >> finalizeResourceData: aResourceData [

	aResourceData cleanup
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

{ #category : #'instance creation' }
MDBEnvironment class >> openReadonly: aPath [

	^self open: aPath flags: MDB_RDONLY
]

{ #category : #primitives }
MDBEnvironment class >> primClose: aHandle [
	^ self ffiCall: #( int mdb_env_close ( void *aHandle ) )
]

{ #category : #primitives }
MDBEnvironment class >> primCreate: aMDBEnvironment [
	^ self ffiCall: #( int mdb_env_create ( MDBEnvironment *aMDBEnvironment ) )
]

{ #category : #primitives }
MDBEnvironment class >> primMDBVersion: major minor: minor patch: patch [
	^ self ffiCall: #( String mdb_version (MDB_INT_HOLDER major, MDB_INT_HOLDER minor, MDB_INT_HOLDER patch ) ) 
]

{ #category : #public }
MDBEnvironment class >> version [

	| major minor patch |
	
	major := MDB_INT_HOLDER new.
	minor := MDB_INT_HOLDER new.
	patch := MDB_INT_HOLDER new.

	^self primMDBVersion: major minor: minor patch: patch
]

{ #category : #actions }
MDBEnvironment >> beginReadTransaction [

	^MDBTransaction begin: self parent: nil flags: MDB_RDONLY
]

{ #category : #actions }
MDBEnvironment >> beginTransaction [

	^MDBTransaction begin: self parent: nil flags: 0
]

{ #category : #'initialize-release' }
MDBEnvironment >> close [

	self primClose.
	self handle beNull
]

{ #category : #accessing }
MDBEnvironment >> flags [

	| buf |
	
	buf := ByteArray new: 4.
	self primGetFlags: buf.
	^buf nbUInt32AtOffset: 0
]

{ #category : #testing }
MDBEnvironment >> isReadonly [

	^(self flags bitAnd: MDB_RDONLY) ~= 0
]

{ #category : #accessing }
MDBEnvironment >> maxkeysize [

	^self primGetMaxkeysize
]

{ #category : #opening }
MDBEnvironment >> open: aPath [

	self open: aPath flags: 0
]

{ #category : #opening }
MDBEnvironment >> open: aPath flags: aFlagsInt [

	self open: aPath flags: aFlagsInt mode: 8r664
]

{ #category : #opening }
MDBEnvironment >> open: aPath flags: aFlagsInt mode: aModeInt [

	| result |
	
	result := self primOpen: aPath flags: aFlagsInt mode: aModeInt.
	result = 0
		ifFalse: [ self mdbError: result ].
]

{ #category : #primitives }
MDBEnvironment >> primClose [
	
	^ self ffiCall: #( int mdb_env_close ( MDBEnvironment self ) )
]

{ #category : #primitives }
MDBEnvironment >> primDbiClose: aMDBDbi [
	
	^ self ffiCall: #( void mdb_dbi_close ( MDBEnvironment self, MDB_dbi aMDBDbi ) )
]

{ #category : #primitives }
MDBEnvironment >> primGetFlags: aBuffer [
	
	^ self ffiCall: #( int mdb_env_get_flags( MDBEnvironment self, uint* aBuffer ) )
]

{ #category : #primitives }
MDBEnvironment >> primGetMaxkeysize [
	
	^ self ffiCall: #( int mdb_env_get_maxkeysize ( MDBEnvironment self ) )
]

{ #category : #primitives }
MDBEnvironment >> primOpen: aPath flags: aFlagsInt mode: aModeInt [
	
	^ self ffiCall: #( int mdb_env_open ( MDBEnvironment self, String aPath, uint aFlagsInt, uint aModeInt) )
]

{ #category : #primitives }
MDBEnvironment >> primSetMapsize: anInteger [
	
	^ self ffiCall: #( int mdb_env_set_mapsize ( MDBEnvironment self, size_t anInteger ) )
]

{ #category : #primitives }
MDBEnvironment >> primSetMaxdbs: anInteger [
	
	^ self ffiCall: #( int mdb_env_set_maxdbs ( MDBEnvironment self, uint anInteger ) )
]

{ #category : #primitives }
MDBEnvironment >> primStat: aMDBStat [
	
	^ self ffiCall: #( int mdb_env_stat ( MDBEnvironment self, MDBStat *aMDBStat ) )
]

{ #category : #'initialize-release' }
MDBEnvironment >> resourceData [

	^resourceData ifNil: [ resourceData := MDBEnvironmentResourceData new initWithHandle: handle ]
]

{ #category : #'initialize-release' }
MDBEnvironment >> setMapsize: anInteger [
	"Set the size of the memory map to use for this environment."

	| result |
	
	result := self primSetMapsize: anInteger.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'initialize-release' }
MDBEnvironment >> setMaxdbs: anInteger [

	| result |
	
	result := self primSetMaxdbs: anInteger.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #accessing }
MDBEnvironment >> stat [
	"Return statistics about this MDB environment."

	| struct |
	
	struct := MDBStat new.
	self primStat: struct.
	^struct
]
