Class {
	#name : #MDBTest,
	#superclass : #TestCase,
	#category : #'LightningMDB-Tests-Core'
}

{ #category : #accessing }
MDBTest >> path [

	^ '/Users/jvdsandt/Stuff/mytestdb'
]

{ #category : #running }
MDBTest >> setUp [

	| ref |

	ref := FileSystem disk referenceTo: self path.
	ref isDirectory
		ifFalse: [ ref createDirectory ]
]

{ #category : #tests }
MDBTest >> testBeginTransaction [

	| env tx |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	
	tx abort.

	env close
]

{ #category : #tests }
MDBTest >> testCreateAndCloseEnvironment [

	| env |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env close
]

{ #category : #tests }
MDBTest >> testCursor [

	| env tx dbi cursor data |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	dbi := tx openDatabase: nil.
	cursor := tx openCursor: dbi.
	
	data := cursor associations.

	cursor close.
	tx abort.
	env close
]

{ #category : #tests }
MDBTest >> testGet [

	| env tx dbi data |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	dbi := tx openDatabase: nil.

	data := tx getByteString: 'key' database: dbi ifNotFound: [ nil ].
	self assert: data = 'value'.

	data := tx getByteString: 'nokey' database: dbi ifNotFound: [ nil ].
	self assert: data isNil.

	env close
]

{ #category : #tests }
MDBTest >> testOpenAndCloseEnvironment [

	| env |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path flags: 0 mode: 8r664.
	
	env close
]

{ #category : #tests }
MDBTest >> testOpenDatabase [

	| env tx dbi |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env setMaxdbs: 8.
	env open: self path.
	
	tx := env beginTransaction.
	dbi := tx openDatabase: 'db1'.
.	
	tx abort.

	env close
]

{ #category : #tests }
MDBTest >> testPut [

	| env tx dbi data |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	dbi := tx openDatabase: nil.
	tx put: 'key' data: 'value' database: dbi.
	tx commit.
	
	tx := env beginReadTransaction.
	dbi := tx openDatabase: nil.
	data := tx getByteString: 'key' database: dbi.
	tx abort.

	self assert: data = 'value'.

	env close
]
