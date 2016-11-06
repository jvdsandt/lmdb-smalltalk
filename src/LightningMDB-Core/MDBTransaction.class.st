"
A MDBTransaction provides access to MDB_txn related functionality.
"
Class {
	#name : #MDBTransaction,
	#superclass : #MDBHandle,
	#category : #'LightningMDB-Core'
}

{ #category : #'instance creation' }
MDBTransaction class >> begin: aMDBEnvironment parent: aParentTransactionOrNil flags: aFlagsInt [

	| instance result |
	
	instance := self new.
	result := aParentTransactionOrNil isNil 
		ifTrue: [ self primBegin: aMDBEnvironment flags: aFlagsInt transaction: instance ]
		ifFalse: [ self primBegin: aMDBEnvironment parent: aParentTransactionOrNil flags: aFlagsInt transaction: instance ].
	result = 0
		ifFalse: [ self mdbError: result ].
	^instance
]

{ #category : #primitives }
MDBTransaction class >> primBegin: aMDBEnvironment flags: aFlagsInt transaction: aMDBTransaction [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_txn_begin ( MDBEnvironment aMDBEnvironment, nil, uint aFlagsInt, MDBTransaction *aMDBTransaction ) ) 
		options: #( optCoerceNilToNull ) 
]

{ #category : #primitives }
MDBTransaction class >> primBegin: aMDBEnvironment parent: aParentTransaction flags: aFlagsInt transaction: aMDBTransaction [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	
	^ self nbCall: #( int mdb_txn_begin ( MDBEnvironment aMDBEnvironment, MDBTransaction aParentTransaction, uint aFlagsInt, MDBTransaction *aMDBTransaction ) ) 
		options: #( optCoerceNilToNull ) 
]

{ #category : #public }
MDBTransaction >> abort [
	"Abort this transaction"

	self primAbort
]

{ #category : #public }
MDBTransaction >> commit [
	"Commit this transaction."

	| result |
	
	result := self primCommit.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'public-updating' }
MDBTransaction >> delete: aKey data: aValue database: aDbi ifNotFound: aBlock [

	| mdbKey mdbData result |
	
	mdbKey := MDBValue allocateFor: aKey.
	mdbData := aValue isNil
		ifTrue: [ nil ]
		ifFalse: [ MDBValue allocateFor: aValue ].
		
	result := self primDel: aDbi key: mdbKey data: mdbData.
	mdbData notNil 
		ifTrue: [ mdbData freeData ].
	mdbKey freeData.

	result = MDB_NOTFOUND
		ifTrue: [ ^aBlock value ].
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'public-updating' }
MDBTransaction >> delete: aKey database: aDbi [

	self delete: aKey database: aDbi ifNotFound: [ self errorKeyNotFound: aKey ]
]

{ #category : #'public-updating' }
MDBTransaction >> delete: aKey database: aDbi ifNotFound: aBlock [

	| mdbKey result |
	
	mdbKey := MDBValue allocateFor: aKey.
		
	result := self primDel: aDbi key: mdbKey data: nil.
	mdbKey freeData.

	result = MDB_NOTFOUND
		ifTrue: [ ^aBlock value ].
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #public }
MDBTransaction >> drop: aDbiHandle [
	"Delete the database/tabe referenced by <aDbiHandle>."

	| result |
	
	result := self primDrop: aDbiHandle type: 1.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'public-updating' }
MDBTransaction >> empty: aDbiHandle [
	"Delete all entries from the database/tabe referenced by <aDbiHandle>."

	| result |
	
	result := self primDrop: aDbiHandle type: 0.
	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #'public-reading' }
MDBTransaction >> getByteArray: aKey database: aDbiHandle [

	^self getByteArray: aKey database: aDbiHandle ifNotFound: [ self errorKeyNotFound: aKey ]
]

{ #category : #'public-reading' }
MDBTransaction >> getByteArray: aKey database: aDbiHandle ifNotFound: aBlock [

	^(self getData: aKey database: aDbiHandle ifNotFound: [ ^aBlock value ]) dataAsByteArray
]

{ #category : #'public-reading' }
MDBTransaction >> getByteString: aKey database: aDbiHandle [

	^self getByteString: aKey database: aDbiHandle ifNotFound: [ self errorKeyNotFound: aKey ]
]

{ #category : #'public-reading' }
MDBTransaction >> getByteString: aKey database: aDbiHandle ifNotFound: aBlock [

	^(self getData: aKey database: aDbiHandle ifNotFound: [ ^aBlock value ]) dataAsByteString
]

{ #category : #'public-reading' }
MDBTransaction >> getData: aKey database: aDbiHandle ifNotFound: aBlock [

	| mdbKey mdbValue result |
	
	mdbKey := MDBValue allocateFor: aKey.
	result := self primGet: mdbKey data: (mdbValue := MDBValue new) database: aDbiHandle.
	mdbKey freeData.

	result = MDB_NOTFOUND
		ifTrue: [ ^aBlock value ].
	result = 0
		ifFalse: [ self mdbError: result ].
	^mdbValue
]

{ #category : #public }
MDBTransaction >> openCursor: aDbiHandle [

	^MDBCursor open: self dbi: aDbiHandle 
]

{ #category : #public }
MDBTransaction >> openDatabase: aName [
	"Answer a handle to a database/table names <aName> in this database. If <aName> is nil the default
	database will be opened.
	The database handle will be private to the current transaction until the transaction is successfully committed. 
	If the transaction is aborted the handle will be closed automatically."

	^self openDatabase: aName flags: MDB_CREATE
]

{ #category : #public }
MDBTransaction >> openDatabase: aName flags: anInteger [
	"Answer a handle to a database/table names <aName> in this database. If <aName> is nil the default
	database will be opened.
	The database handle will be private to the current transaction until the transaction is successfully committed. 
	If the transaction is aborted the handle will be closed automatically."

	| buf result |
	
	buf := ByteArray new: 4.
	
	result := self primDbiOpen: aName flags: anInteger dbi: buf. 
	result = 0
		ifFalse: [ self mdbError: result ].
		
	^buf nbUInt32AtOffset: 0
]

{ #category : #primitives }
MDBTransaction >> primAbort [
	
	^ self ffiCall: #( void mdb_txn_abort ( MDBTransaction self ) )
]

{ #category : #primitives }
MDBTransaction >> primCommit [
	
	^ self ffiCall: #( int mdb_txn_commit ( MDBTransaction self ) )
]

{ #category : #primitives }
MDBTransaction >> primDbiOpen: aName flags: aFlagsInt dbi: aMDBDbiPointer [
	
	^ self ffiCall: #( int mdb_dbi_open ( MDBTransaction self, String aName, uint aFlagsInt, MDB_dbi *aMDBDbiPointer ) )
]

{ #category : #primitives }
MDBTransaction >> primDel: aDbiHandle key: aKey data: aValue [
	
	^ self ffiCall: #( int mdb_del ( MDBTransaction self, MDB_dbi aDbiHandle, MDBValue *aKey, MDBValue *aValue ) )
]

{ #category : #primitives }
MDBTransaction >> primDrop: aDbiHandle type: anInteger [
	
	^ self ffiCall: #( int mdb_drop ( MDBTransaction self, MDB_dbi aDbiHandle, int anInteger ) )
]

{ #category : #primitives }
MDBTransaction >> primEnvironment [
	
	^ self ffiCall: #( MDBEnvironment mdb_txn_env ( MDBTransaction self ) )
]

{ #category : #primitives }
MDBTransaction >> primGet: aKey data: aValue database: aDbi [
	
	^ self ffiCall: #( int mdb_get ( MDBTransaction self, MDB_dbi aDbi, MDBValue *aKey, MDBValue *aValue ) )
]

{ #category : #primitives }
MDBTransaction >> primPut: aDbi key: aKey data: aValue flags: aFlagsInt [
	
	^ self ffiCall: #( int mdb_put ( MDBTransaction self, MDB_dbi aDbi, MDBValue *aKey, MDBValue *aValue, uint aFlagsInt ) )
]

{ #category : #primitives }
MDBTransaction >> primRenew [
	
	^ self ffiCall: #( int mdb_txn_renew ( MDBTransaction self ) )
]

{ #category : #primitives }
MDBTransaction >> primReset [
	
	^ self ffiCall: #( void mdb_txn_reset ( MDBTransaction self ) )
]

{ #category : #primitives }
MDBTransaction >> primStat: aDbi structure: aStat [
	
	^ self ffiCall: #( int mdb_stat ( MDBTransaction self, MDB_dbi aDbi, MDBStat *aStat ) )
]

{ #category : #'public-updating' }
MDBTransaction >> put: aKey data: aValue database: aDbi [

	| mdbKey mdbData result |
	
	mdbKey := MDBValue allocateFor: aKey.
	mdbData := MDBValue allocateFor: aValue.
		
	result := self primPut: aDbi key: mdbKey data: mdbData flags: 0.
	mdbData freeData.
	mdbKey freeData.

	result = 0
		ifFalse: [ self mdbError: result ]
]

{ #category : #public }
MDBTransaction >> reset [

	self primReset 
]

{ #category : #public }
MDBTransaction >> stat: aDbi [

	| stats |
	
	self check: (self primStat: aDbi structure: (stats := MDBStat new)).
	^stats
]
