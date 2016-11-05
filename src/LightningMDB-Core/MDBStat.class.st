"
A MDBStat is a structure class for the MDB_stat C structure. Used to report statistics for a database in the environment.
"
Class {
	#name : #MDBStat,
	#superclass : #FFIExternalStructure,
	#category : #'LightningMDB-Core'
}

{ #category : #'fields description' }
MDBStat class >> fieldsDesc [
	^#(
		uint psize ;
		uint depth ;
		size_t branchPages ;
		size_t leafPages ;
		size_t overflowPages ;
		size_t entries 
	)
]

{ #category : #'accessing structure variables' }
MDBStat >> branchPages [
	"This method was automatically generated"
	^handle unsignedLongLongAt: 9
]

{ #category : #'accessing structure variables' }
MDBStat >> branchPages: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: 9 put: anObject
]

{ #category : #'accessing structure variables' }
MDBStat >> depth [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #'accessing structure variables' }
MDBStat >> depth: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #'accessing structure variables' }
MDBStat >> entries [
	"This method was automatically generated"
	^handle unsignedLongLongAt: 33
]

{ #category : #'accessing structure variables' }
MDBStat >> entries: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: 33 put: anObject
]

{ #category : #'accessing structure variables' }
MDBStat >> leafPages [
	"This method was automatically generated"
	^handle unsignedLongLongAt: 17
]

{ #category : #'accessing structure variables' }
MDBStat >> leafPages: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: 17 put: anObject
]

{ #category : #'accessing structure variables' }
MDBStat >> overflowPages [
	"This method was automatically generated"
	^handle unsignedLongLongAt: 25
]

{ #category : #'accessing structure variables' }
MDBStat >> overflowPages: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: 25 put: anObject
]

{ #category : #'accessing structure variables' }
MDBStat >> psize [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #'accessing structure variables' }
MDBStat >> psize: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
