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
