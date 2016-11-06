Class {
	#name : #MDBFunctionalTest,
	#superclass : #MDBTest,
	#instVars : [
		'env'
	],
	#category : #'LightningMDB-Tests-Core'
}

{ #category : #running }
MDBFunctionalTest >> createEnvironment [

	^ MDBEnvironment create
			setMaxdbs: 12;
			setMapsize: 100 * 1024 * 4096; 					"400MB"
			open: self path flags: 0 ;
			yourself
]

{ #category : #accessing }
MDBFunctionalTest >> env [

	^ env ifNil: [ env := self createEnvironment ]
]

{ #category : #running }
MDBFunctionalTest >> tearDown [

	env notNil
		ifTrue: [ 
			env close.
			env := nil ].
		
	super tearDown
	
]

{ #category : #tests }
MDBFunctionalTest >> test01Bulk [

	| db1 tx data cursor |
	
	db1 := self env openDatabase: 'db1'.
	tx := self env beginTransaction.
	tx empty: db1.
	data := ByteArray new: 40 * 1024.
	1 to: 1000 do: [ :index |
		1 to: data size do: [ :di | data at: di put: (index \\ 256) ].
		tx 
			put: 'key-', (index printStringLength: 20 padded: true)
			data: data
			database: db1 ].
	tx commit.
	
	tx := self env beginReadTransaction.
	self assert: (tx stat: db1) entries equals: 1000.
	cursor := tx openCursor: db1.
	1 to: 1000 do: [ :index |
		| assoc |
		assoc := cursor next.
		self assert: assoc key dataAsByteString equals: 'key-', (index printStringLength: 20 padded: true).
		data := assoc value dataAsByteArray.
		self assert: data size equals: 40 * 1024.
		self assert: (data allSatisfy: [ :b | b = (index \\ 256) ]) ].
	self assert: cursor next isNil.
	tx abort.
]

{ #category : #tests }
MDBFunctionalTest >> testKeyTooBig [

	| db1 tx key |
	
	db1 := self env openDatabase: 'db1'.

	key := ByteArray new: env maxkeysize + 1.
	1 to: key size do: [ :i | key at: i put: (i \\ 256) ].
	
	tx := self env beginTransaction.
	self should: [ tx 	put: key 	data: 'test-data' database: db1 ] raise: Error.
	tx commit
	
]
