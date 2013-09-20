Extension { #name : #NativeBoostWin32 }

{ #category : #'*LightningMDB-Core' }
NativeBoostWin32 >> lightningMDBModule [
	" Answer the name of the LMDB library for this platform."

	^'liblmdb.dll'
]
