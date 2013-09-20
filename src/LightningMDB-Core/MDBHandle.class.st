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

{ #category : #internal }
MDBHandle class >> mdbError: anInteger [

	self error: 'MDB Error: ', (self strerror: anInteger)
]

{ #category : #resources }
MDBHandle class >> nbLibraryNameOrHandle [

	^NativeBoost forCurrentPlatform lightningMDBModule
]

{ #category : #internal }
MDBHandle class >> strerror: err [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^ self nbCall: #( String mdb_strerror (int err ) ) 
]

{ #category : #internal }
MDBHandle >> mdbError: anInteger [

	self class mdbError: anInteger
]

{ #category : #resources }
MDBHandle >> nbLibraryNameOrHandle [

	^self class nbLibraryNameOrHandle 
]
