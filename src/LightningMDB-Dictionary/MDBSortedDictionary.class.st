"
A MDBSortedDictionary is a high level Dictionary like interface to a LDBM database. Any LDBM database with unique keys can be accessed and updated using an instance of this class.

Converter objects are used to (de)serialize key and value objects to binary data. Note that the length of a serialized key is limited to 511 bytes by default.

Instance Variables
	databaseName:		<String>
	dbi:					<Object> handle to the database/table within the environment
	environment:		<MDBEnvironment>
	keyConverter:		<MDBObjectConverter> converter used to (de)serialize the keys
	valueConverter:	<MDBObjectConverter> converter used to (de)serialize the values


"
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
	#pools : [
		'MDBTypes'
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
		flags: 0
		keyConverter: self defaultKeyConverter
		valueConverter: self defaultValueConverter
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> open: aDatabaseName in: aPath flags: aFlagsInt keyConverter: aKeyConverter valueConverter: aValueConverter [

	| ref |

	ref := FileSystem disk referenceTo: aPath.
	ref isDirectory
		ifFalse: [ ref createDirectory ].
		
	^self open: aDatabaseName 
		environment: (
			MDBEnvironment create
				setMaxdbs: 1;
				setMapsize: 100 * 1024 * 4096; 					"400MB"
				open: ref asAbsolute pathString flags: aFlagsInt ;
				yourself)
		keyConverter: aKeyConverter 
		valueConverter: aValueConverter
]

{ #category : #'instance creation' }
MDBSortedDictionary class >> openReadonly: aDatabaseName in: aPath [

	^self open: aDatabaseName
		in: aPath
		flags: MDB_RDONLY
		keyConverter: self defaultKeyConverter
		valueConverter: self defaultValueConverter
]

{ #category : #adding }
MDBSortedDictionary >> add: anAssociation [

	self at: anAssociation key put: anAssociation value.
	^anAssociation 
]

{ #category : #adding }
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

{ #category : #accessing }
MDBSortedDictionary >> associations [
	"Answer a collection containing the receivers key value pairs."
	
	| coll |
	
	coll := OrderedCollection new: 200.
	self associationsDo: [ :each | coll add: each ].
	^coll
]

{ #category : #enumerating }
MDBSortedDictionary >> associationsDo: aBlock [
	
	self keysAndValuesDo: [ :key :value | aBlock value: key -> value ]
]

{ #category : #accessing }
MDBSortedDictionary >> at: key [ 
	"Answer the value associated with the key."

	^ self at: key ifAbsent: [self errorKeyNotFound: key]
]

{ #category : #accessing }
MDBSortedDictionary >> at: key ifAbsent: aBlock [ 
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock."
	
	| tx |
	
	tx := self getReadTransaction.
	^[ valueConverter deserialize: (
		tx getData: (keyConverter serialize: key) database: dbi ifNotFound: [ ^aBlock value ]) ]
			ensure: [ self releaseReadTransaction: tx ]
]

{ #category : #accessing }
MDBSortedDictionary >> at: key ifAbsentPut: aBlock [ 
	"Return the value at the given key. 
	If key is not included in the receiver store the result 
	of evaluating aBlock as new value."

	| keyValue dataValue value transaction |
	
	keyValue := keyConverter serialize: key.
	
	transaction := environment beginTransaction.
	dataValue := transaction getData: keyValue database: dbi ifNotFound: [ 
		value := aBlock value.
		transaction put: keyValue data: (valueConverter serialize: value) database: dbi.
		transaction commit.
		^value ].
	
	value := valueConverter deserialize: dataValue.
	transaction abort.
	^value
]

{ #category : #accessing }
MDBSortedDictionary >> at: key ifPresent: aBlock [
	"Lookup the given key in the receiver. If it is present, answer the value of evaluating the given block with the value associated with the key. Otherwise, answer nil."

	^aBlock value: (self at: key ifAbsent: [ ^nil ])
]

{ #category : #accessing }
MDBSortedDictionary >> at: key ifPresent: oneArgBlock ifAbsent: absentBlock [
	"Lookup the given key in the receiver. If it is present, answer the value of evaluating the oneArgBlock with the value associated with the key, otherwise answer the value of absentBlock."
	
	self at: key ifPresent: [ :v | ^oneArgBlock value: v ].
	^absentBlock value
]

{ #category : #accessing }
MDBSortedDictionary >> at: key put: anObject [ 
	"Set the value at key to be anObject.  If key is not found, create a
	new entry for key and set is value to anObject. Answer anObject."

	| writeTransaction |
	
	writeTransaction := environment beginTransaction.
	writeTransaction put: (keyConverter serialize: key) data: (valueConverter serialize: anObject) database: dbi.
	writeTransaction commit
]

{ #category : #removing }
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

	| transaction |

	environment := anEnvironment.
	databaseName := aStringOrNil.
	
	environment isReadonly
		ifTrue: [
			transaction := self getReadTransaction.
			[ dbi := transaction openDatabase: databaseName ]
				ensure: [ self releaseReadTransaction: transaction ] ]
		ifFalse: [ 
			transaction := anEnvironment beginTransaction.
			dbi := transaction openDatabase: databaseName.
			transaction commit ].
	
	keyConverter := aKeyConverter.
	valueConverter := aValueConterter
]

{ #category : #testing }
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

{ #category : #testing }
MDBSortedDictionary >> isReadonly [

	^environment isReadonly
]

{ #category : #accessing }
MDBSortedDictionary >> keys [
	"Answer a collection containing the receivers keys."
	
	| coll |
	
	coll := OrderedCollection new: 200.
	self keysDo: [ :each | coll add: each ].
	^coll
]

{ #category : #enumerating }
MDBSortedDictionary >> keysAndValuesDo: aBlock [
	"Evaluate aBlock for each of the receiver's values."
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	[ 
		cursor keysAndDataDo: [ :keyValue :dataValue |
			aBlock 
				value: (keyConverter deserialize: keyValue)
				value: (valueConverter deserialize: dataValue) ]
	] ensure: [ 
		cursor close.
		self releaseReadTransaction: tx ]
]

{ #category : #enumerating }
MDBSortedDictionary >> keysDo: aBlock [
	"Evaluate aBlock for each of the receiver's keys."
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	[ 
		cursor keysAndDataDo: [ :keyValue :dataValue |
			aBlock value: (keyConverter deserialize: keyValue) ]
	] ensure: [ 
		cursor close.
		self releaseReadTransaction: tx ]
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

{ #category : #removing }
MDBSortedDictionary >> removeKey: key [
	"Remove key from the receiver.
	If key is not in the receiver, notify an error."

	^self removeKey: key ifAbsent: [ self errorKeyNotFound: key ]
]

{ #category : #removing }
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

{ #category : #accessing }
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

{ #category : #accessing }
MDBSortedDictionary >> values [
	"Answer a collection containing the receivers keys."
	
	| coll |
	
	coll := OrderedCollection new: 200.
	self valuesDo: [ :each | coll add: each ].
	^coll
]

{ #category : #enumerating }
MDBSortedDictionary >> valuesDo: aBlock [
	"Evaluate aBlock for each of the receiver's values."
	
	| tx cursor |
	
	tx := self getReadTransaction.
	cursor := tx openCursor: dbi.
	[ 
		cursor keysAndDataDo: [ :keyValue :dataValue |
			aBlock value: (valueConverter deserialize: dataValue) ]
	] ensure: [ 
		cursor close.
		self releaseReadTransaction: tx ]
]
