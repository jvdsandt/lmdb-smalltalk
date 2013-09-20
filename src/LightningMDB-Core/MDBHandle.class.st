"
A MDBHandle is an abstract base class for all MDB related extrenal objects.
"
Class {
	#name : #MDBHandle,
	#superclass : #NBExternalObject,
	#pools : [
		'MDBTypes'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'as yet unclassified' }
MDBHandle class >> mdbError: anInteger [

	self error: 'MDB Error: ', (self strerror: anInteger)
]

{ #category : #'as yet unclassified' }
MDBHandle class >> nbLibraryNameOrHandle [

	^'/usr/local/Cellar/lmdb/2.4.35/lib/liblmdb.dylib'
]

{ #category : #'as yet unclassified' }
MDBHandle class >> strerror: err [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^ self nbCall: #( String mdb_strerror (int err ) ) 
]

{ #category : #'as yet unclassified' }
MDBHandle >> mdbError: anInteger [

	self class mdbError: anInteger
]

{ #category : #'as yet unclassified' }
MDBHandle >> nbLibraryNameOrHandle [

	^self class nbLibraryNameOrHandle 
]
