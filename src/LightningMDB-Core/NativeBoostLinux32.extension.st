Extension { #name : #NativeBoostLinux32 }

{ #category : #'*LightningMDB-Core' }
NativeBoostLinux32 >> lightningMDBModule [
	" Answer the name of the LMDB library for this platform."

	^'liblmdb.so'
]
