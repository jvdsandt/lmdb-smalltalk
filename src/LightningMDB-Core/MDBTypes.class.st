"
A MDBTypes is a pool dictionary with varius MDB related constants.
"
Class {
	#name : #MDBTypes,
	#superclass : #SharedPool,
	#classVars : [
		'MDB_CREATE',
		'MDB_FIRST',
		'MDB_FIRST_DUP',
		'MDB_GET_BOTH',
		'MDB_GET_BOTH_RANGE',
		'MDB_GET_CURRENT',
		'MDB_GET_MULTIPLE',
		'MDB_LAST',
		'MDB_LAST_DUP',
		'MDB_NEXT',
		'MDB_NEXT_DUP',
		'MDB_NEXT_MULTIPLE',
		'MDB_NEXT_NODUP',
		'MDB_NOTFOUND',
		'MDB_PREV',
		'MDB_PREV_DUP',
		'MDB_PREV_NODUP',
		'MDB_RDONLY',
		'MDB_SET',
		'MDB_SET_KEY',
		'MDB_SET_RANGE',
		'MDB_dbi'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'as yet unclassified' }
MDBTypes class >> initialize [
	"self initialize"
	
	MDB_dbi := #uint.
	
	"Translating to pointer"
	
	"Translating to inner classes"


	MDB_CREATE := 16r40000.
	MDB_RDONLY := 16r20000.


	MDB_NOTFOUND := -30798.
	
	MDB_FIRST := 0.
	MDB_FIRST_DUP := 1.
	MDB_GET_BOTH := 2.
	MDB_GET_BOTH_RANGE := 3.
	MDB_GET_CURRENT := 4.
	MDB_GET_MULTIPLE := 5.
	MDB_LAST := 6.
	MDB_LAST_DUP := 7.
	MDB_NEXT := 8.
	MDB_NEXT_DUP := 9.
	MDB_NEXT_MULTIPLE := 10.
	MDB_NEXT_NODUP := 11.
	MDB_PREV := 12.
	MDB_PREV_DUP := 13.
	MDB_PREV_NODUP := 14.
	MDB_SET := 15.
	MDB_SET_KEY := 16.
	MDB_SET_RANGE := 17.	

]
