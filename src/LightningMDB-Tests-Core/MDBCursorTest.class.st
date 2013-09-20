Class {
	#name : #MDBCursorTest,
	#superclass : #MDBTest,
	#instVars : [
		'environment'
	],
	#category : #'LightningMDB-Tests-Core'
}

{ #category : #running }
MDBCursorTest >> createEnvironment [

	| env |

	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env setMaxdbs: 8.
	env open: self path.

	^env
]

{ #category : #running }
MDBCursorTest >> createTestData [

	| tx dbi |
	
	tx := self environment beginTransaction.
	dbi := tx openDatabase: nil.
	self createTestData: tx dbi: dbi.
	tx commit
]

{ #category : #running }
MDBCursorTest >> createTestData: aTransaction dbi: aDbiHandle [

	1 to: 300 by: 3 do: [ :index |
		aTransaction put: (index printPaddedWith: $0 to: 10) data: 'data-', index printString database: aDbiHandle ]
]

{ #category : #accessing }
MDBCursorTest >> environment [

	^environment ifNil: [ environment := self createEnvironment ]
]

{ #category : #running }
MDBCursorTest >> tearDown [

	environment notNil 
		ifTrue: [ 
			environment close.
			environment := nil ]
]

{ #category : #running }
MDBCursorTest >> testCursor [

	| tx dbi cursor data |
	
	self createTestData.
	
	tx := self environment beginTransaction.
	dbi := tx openDatabase: nil.
	cursor := tx openCursor: dbi.
	
	data := cursor associations.

	cursor close.
	tx abort
]

{ #category : #running }
MDBCursorTest >> testSet [

	| tx dbi cursor result |
	
	self createTestData.
	
	tx := self environment beginTransaction.
	dbi := tx openDatabase: nil.
	cursor := tx openCursor: dbi.
	
	result := cursor setRange: '0000000002'.
	
	result := cursor getAll: [ :key :data | key dataAsByteString -> data dataAsByteString ].

	cursor close.
	tx abort
]
