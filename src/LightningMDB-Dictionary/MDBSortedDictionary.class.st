Class {
	#name : #MDBSortedDictionary,
	#superclass : #Object,
	#instVars : [
		'environment',
		'dbi',
		'databaseName',
		'valueSerializer',
		'valueMaterializer'
	],
	#category : #'LightningMDB-Dictionary'
}

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName environment: anEnvironment [

	^self basicNew initializeEnvironment: anEnvironment databaseName: aDatabaseName
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName in: aPath [

	| ref |

	ref := FileSystem disk referenceTo: aPath.
	ref isDirectory
		ifFalse: [ ref createDirectory ].
		
	^self open: aDatabaseName environment: (
		MDBEnvironment create
			setMaxdbs: 1;
			setMapsize: 100 * 1024 * 4096; 
			open: ref asAbsolute pathString ;
			yourself)
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
	valueData := tx getData: (self keyDataFromObject: key) database: dbi ifNotFound: [ 
		self releaseReadTransaction: tx.
		^aBlock value ].
	self releaseReadTransaction: tx.

	^self valueDataAsObject: valueData
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

	| writeTransaction valueData |
	
	valueData := self valueDataFromObject: anObject.

	writeTransaction := environment beginTransaction.
	writeTransaction put: (self keyDataFromObject: key) data: valueData database: dbi.
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

{ #category : #'as yet unclassified' }
MDBSortedDictionary >> getBuffer: minByteSize [

	^ByteArray new: minByteSize
]

{ #category : #private }
MDBSortedDictionary >> getReadTransaction [

	^environment beginReadTransaction
]

{ #category : #'initialize-release' }
MDBSortedDictionary >> initializeEnvironment: anEnvironment databaseName: aStringOrNil [

	| writeTransaction |

	environment := anEnvironment.
	databaseName := aStringOrNil.

	writeTransaction := anEnvironment beginTransaction.
	dbi := writeTransaction openDatabase: databaseName.
	writeTransaction commit.
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

{ #category : #serialization }
MDBSortedDictionary >> keyDataAsObject: aValueData [
	"Convert the key bytes to a key object"

	^aValueData dataAsByteString
]

{ #category : #serialization }
MDBSortedDictionary >> keyDataFromObject: anObject [
	"Convert the key <anObject> to some ByteArray like object."

	^anObject
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
			value: (self keyDataAsObject: keyValue)
			value: (self valueDataAsObject: dataValue) ].
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
		aBlock value: (self keyDataAsObject: keyValue) ].
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
MDBSortedDictionary >> removeKey: key ifAbsent: aBlock [ 
	"Remove key (and its associated value) from the receiver. If key is not in 
	the receiver, answer the result of evaluating aBlock. Otherwise, answer 
	the value externally named by key."


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

{ #category : #serialization }
MDBSortedDictionary >> valueDataAsObject: aValueData [

	| buf |
	
	buf := self getBuffer: aValueData mvSize.
	aValueData copyDataTo: buf.
	^(self valueMaterializer materializeFrom: buf readStream) root
]

{ #category : #serialization }
MDBSortedDictionary >> valueDataFromObject: anObject [

	^ByteArray streamContents: [ :stream |
		self valueSerializer serialize: anObject on: stream ]
]

{ #category : #accessing }
MDBSortedDictionary >> valueMaterializer [
	^ valueMaterializer ifNil: [ valueMaterializer := FLMaterializer new ]
]

{ #category : #'initialize-release' }
MDBSortedDictionary >> valueMaterializer: anObject [
	^ valueMaterializer := anObject
]

{ #category : #accessing }
MDBSortedDictionary >> valueSerializer [
	^ valueSerializer ifNil: [ valueSerializer := FLSerializer new ]
]

{ #category : #'initialize-release' }
MDBSortedDictionary >> valueSerializer: anObject [
	valueSerializer := anObject
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
		aBlock value: (self valueDataAsObject: dataValue) ].
	cursor close.
	self releaseReadTransaction: tx
]
