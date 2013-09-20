Class {
	#name : #MDBTransactionTest,
	#superclass : #MDBTest,
	#category : #'LightningMDB-Tests-Core'
}

{ #category : #tests }
MDBTransactionTest >> testBeginTransaction [

	| env tx |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	
	tx abort.

	env close
]

{ #category : #tests }
MDBTransactionTest >> testCursor [

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
MDBTransactionTest >> testDelete [

	| env tx dbi data |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	dbi := tx openDatabase: nil.

	tx put: 'key' data: 'value' database: dbi.

	data := tx getByteString: 'key' database: dbi ifNotFound: [ nil ].
	self assert: data = 'value'.

	tx delete: 'key' database: dbi ifNotFound: [ self fail ].
	data := tx getByteString: 'key' database: dbi ifNotFound: [ nil ].
	self assert: data isNil.
	
	data := 0.
	tx delete: 'nokey' database: dbi ifNotFound: [ data := 1 ].
	self assert: data = 1.

	tx abort.
	env close
]

{ #category : #tests }
MDBTransactionTest >> testGet [

	| env tx dbi data |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path.
	
	tx := env beginTransaction.
	dbi := tx openDatabase: nil.

	tx put: 'key' data: 'value' database: dbi.

	data := tx getByteString: 'key' database: dbi ifNotFound: [ nil ].
	self assert: data = 'value'.

	data := tx getByteString: 'nokey' database: dbi ifNotFound: [ nil ].
	self assert: data isNil.

	tx abort.
	env close
]

{ #category : #tests }
MDBTransactionTest >> testOpenDatabase [

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
MDBTransactionTest >> testPut [

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
