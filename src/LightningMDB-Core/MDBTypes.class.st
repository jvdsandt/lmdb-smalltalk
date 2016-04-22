"
A MDBTypes is a pool dictionary with varius MDB related constants.
"
Class {
	#name : #MDBTypes,
	#superclass : #SharedPool,
	#classVars : [
		'MDB_CREATE',
		'MDB_DUPFIXED',
		'MDB_DUPSORT',
		'MDB_FIRST',
		'MDB_FIRST_DUP',
		'MDB_GET_BOTH',
		'MDB_GET_BOTH_RANGE',
		'MDB_GET_CURRENT',
		'MDB_GET_MULTIPLE',
		'MDB_INTEGERDUP',
		'MDB_INTEGERKEY',
		'MDB_INT_HOLDER',
		'MDB_LAST',
		'MDB_LAST_DUP',
		'MDB_NEXT',
		'MDB_NEXT_DUP',
		'MDB_NEXT_MULTIPLE',
		'MDB_NEXT_NODUP',
		'MDB_NOSUBDIR',
		'MDB_NOTFOUND',
		'MDB_PREV',
		'MDB_PREV_DUP',
		'MDB_PREV_NODUP',
		'MDB_RDONLY',
		'MDB_REVERSEDUP',
		'MDB_REVERSEKEY',
		'MDB_SET',
		'MDB_SET_KEY',
		'MDB_SET_RANGE',
		'MDB_dbi'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'class initialization' }
MDBTypes class >> initialize [
	"self initialize"
	
	self initializeValueHolders.
	
	MDB_dbi := #uint.
	
	MDB_REVERSEKEY := 16r02.
	MDB_DUPSORT := 16r04.
	MDB_INTEGERKEY := 16r08.
	MDB_DUPFIXED := 16r10.
	MDB_INTEGERDUP := 16r20.
	MDB_REVERSEDUP := 16r40.
	MDB_CREATE := 16r40000.

	MDB_NOSUBDIR := 16r4000.
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

{ #category : #'class initialization' }
MDBTypes class >> initializeValueHolders [

	MDB_INT_HOLDER := FFIExternalValueHolder ofType: 'int'.
]
