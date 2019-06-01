# lmdb-smalltalk
LMDB binding for Pharo Smalltalk

A Smalltalk driver for the Lightning Memory-Mapped Database (LMDB). This is an embedded database that was developed as part 
of the OpenLDAP project. The database can also be used for other applications as a fast embedded database engine. 
This project makes it easy to use the database engine from Smalltalk applications.

Highlights:
* FFI is used to access the liblmdb library
* Works on Linux, OSX and Windows
* A database can be accessed by multiple processes (Smalltalk images) simultaneously but not by multiple hosts
* The driver includes a high level interface: MDBSortedDictionary
