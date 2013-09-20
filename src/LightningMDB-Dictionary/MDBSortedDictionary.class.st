Class {
	#name : #MDBSortedDictionary,
	#superclass : #Object,
	#instVars : [
		'environment',
		'dbi',
		'databaseName',
		'keyConverter',
		'valueConverter'
	],
	#category : #'LightningMDB-Dictionary'
}

{ #category : #defaults }
MDBSortedDictionary class >> defaultKeyConverter [

	^MDBByteStringConverter new
]

{ #category : #defaults }
MDBSortedDictionary class >> defaultValueConverter [

	^MDBFuelConverter new
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName environment: anEnvironment [

	^self open: aDatabaseName 
		environment: anEnvironment 
		keyConverter: self defaultKeyConverter 
		valueConverter: self defaultValueConverter
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName environment: anEnvironment keyConverter: aKeyConverter valueConverter: aValueConverter [

	^self basicNew initializeEnvironment: anEnvironment 
		databaseName: aDatabaseName
		keyConverter: aKeyConverter
		valueConverter: aValueConverter
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName in: aPath [

	^self open: aDatabaseName
		in: aPath
		keyConverter: self defaultKeyConverter
		valueConverter: self defaultValueConverter
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName in: aPath keyConverter: aKeyConverter valueConverter: aValueConverter [

	| ref |

	ref := FileSystem disk referenceTo: aPath.
	ref isDirectory
		ifFalse: [ ref createDirectory ].
		
	^self open: aDatabaseName 
		environment: (
			MDBEnvironment create
				setMaxdbs: 1;
				setMapsize: 100 * 1024 * 4096; 
				open: ref asAbsolute pathString ;
				yourself)
		keyConverter: aKeyConverter 
		valueConverter: aValueConverter
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> addAll: aKeyedCollection [

	| writeTransaction |

	aKeyedCollection == self 
		ifFalse: [
			writeTransaction := environment beginTransaction.
			aKeyedCollection keysAndValuesDo: [ :key :value | 
				writeTransaction 
					put: (keyConverter serialize: key) 
					data: (valueConverter serialize: value)
					database: dbi ].
			writeTransaction commit ].

	^aKeyedCollection
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> at: key [ 
	"Answer the value associated with the key."

	^ self at: key ifAbsent: [self errorKeyNotFound: key]
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> at: key ifAbsent: aBlock [ 
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock."
	
	| tx valueData |
	
	tx := self getReadTransaction.
	valueData := tx getData: (keyConverter serialize: key) database: dbi ifNotFound: [ 
		self releaseReadTransaction: tx.
		^aBlock value ].
	self releaseReadTransaction: tx.

	^valueConverter deserialize: valueData
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> at: key ifPresent: aBlock [
	"Lookup the given key in the receiver. If it is present, answer the value of evaluating the given block with the value associated with the key. Otherwise, answer nil."

	^aBlock value: (self at: key ifAbsent: [ ^nil ])
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> at: key put: anObject [ 
	"Set the value at key to be anObject.  If key is not found, create a
	new entry for key and set is value to anObject. Answer anObject."

	| writeTransaction |
	
	writeTransaction := environment beginTransaction.
	writeTransaction put: (keyConverter serialize: key) data: (valueConverter serialize: anObject) database: dbi.
	writeTransaction commit
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> empty [
	"Remove all key-value pairs from this dictionary."

	| writeTransaction |
	
	writeTransaction := environment beginTransaction.
	writeTransaction empty: dbi.
	writeTransaction commit
]

{ #category : #accessing }
MDBSortedDictionary >> environment [

	^environment
]

{ #category : #private }
MDBSortedDictionary >> getReadTransaction [

	^environment beginReadTransaction
]

{ #category : #'initialize-release' }
MDBSortedDictionary >> initializeEnvironment: anEnvironment databaseName: aStringOrNil keyConverter: aKeyConverter valueConverter: aValueConterter [

	| writeTransaction |

	environment := anEnvironment.
	databaseName := aStringOrNil.

	writeTransaction := anEnvironment beginTransaction.
	dbi := writeTransaction openDatabase: databaseName.
	writeTransaction commit.
	
	keyConverter := aKeyConverter.
	valueConverter := aValueConterter
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> isEmpty [
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	[ cursor keysAndDataDo: [ :keyValue :dataValue | ^false ] ]
		ensure: [
			cursor close.
			self releaseReadTransaction: tx ].
	^true
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> keys [
	"Answer a collection containing the receivers keys."
	
	| coll |
	
	coll := OrderedCollection new: 200.
	self keysDo: [ :each | coll add: each ].
	^coll
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> keysAndValuesDo: aBlock [
	"Evaluate aBlock for each of the receiver's values."
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	cursor keysAndDataDo: [ :keyValue :dataValue |
		aBlock 
			value: (keyConverter deserialize: keyValue)
			value: (valueConverter deserialize: dataValue) ].
	cursor close.
	self releaseReadTransaction: tx
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> keysDo: aBlock [
	"Evaluate aBlock for each of the receiver's keys."
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	cursor keysAndDataDo: [ :keyValue :dataValue |
		aBlock value: (keyConverter deserialize: keyValue) ].
	cursor close.
	self releaseReadTransaction: tx
]

{ #category : #'initialize-release' }
MDBSortedDictionary >> release [

	environment notNil
		ifTrue: [ 
			environment close.
			environment := nil ]
]

{ #category : #private }
MDBSortedDictionary >> releaseReadTransaction: aTransaction [

	aTransaction abort
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> removeKey: key [
	"Remove key from the receiver.
	If key is not in the receiver, notify an error."

	^self removeKey: key ifAbsent: [ self errorKeyNotFound: key ]
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> removeKey: key ifAbsent: aBlock [ 
	"Remove key (and its associated value) from the receiver. If key is not in 
	the receiver, answer the result of evaluating aBlock. Otherwise, answer 
	the value externally named by key."
	
	| keyData valueData transaction |
	
	keyData := keyConverter serialize: key.
	
	transaction := environment beginTransaction.
	valueData := transaction getData: keyData database: dbi ifNotFound: [ 
		transaction abort.
		^aBlock value ].
	transaction delete: keyData database: dbi.
	transaction commit.
	^valueConverter deserialize: valueData


]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> size [
	
	| tx cursor size |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	size := 0.
	cursor keysAndDataDo: [ :keyValue :dataValue | size := size + 1 ].
	cursor close.
	self releaseReadTransaction: tx.
	^size
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> values [
	"Answer a collection containing the receivers keys."
	
	| coll |
	
	coll := OrderedCollection new: 200.
	self valuesDo: [ :each | coll add: each ].
	^coll
]

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> valuesDo: aBlock [
	"Evaluate aBlock for each of the receiver's values."
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	cursor keysAndDataDo: [ :keyValue :dataValue |
		aBlock value: (valueConverter deserialize: dataValue) ].
	cursor close.
	self releaseReadTransaction: tx
]
