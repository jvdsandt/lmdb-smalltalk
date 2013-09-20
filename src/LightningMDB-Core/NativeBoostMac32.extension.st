Extension { #name : #NativeBoostMac32 }

{ #category : #'*LightningMDB-Core' }
NativeBoostMac32 >> lightningMDBModule [
	" Answer the name of the LMDB library for this platform."

	^'liblmdb.dylib'
]
