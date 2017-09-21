Red/System [
	Title:   "Red/System - crossplaform Sockets binding"
	Author:  "Oldes"
	File:    %sockets.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https:;//github.com/red/red/blob/master/BSD-3-License.txt"
	Note: {Based on tutorial: http://www.binarytides.com/udp-socket-programming-in-winsock/}
]

#include %sockets-core.reds

sockets: context [
	error: 0 ;just a variable to hold last returned error code

	#if OS = 'Windows [

		wsa: as WSAData! allocate 400 ;= declare WSAData!
		wsa/version: 0 ; not initialized yet
		
		init: func[
			major [integer!]
			minor [integer!]
			return: [logic!]
			/local version
		][
			version: declare integer16! ;@@ TODO: change once we will have real int16! type
			version/lo: as byte! major
			version/hi: as byte! minor
			;print "Initialising Winsock... "
			error: WSAStartup version wsa
			error = 0
		]
		;automatic initialization...
		if not init 2 2 [;version 2.2
			print-line ["*** Failed Winsock initialization. Error: " error]
		]
	]

	make-socket: func[
		"Create socket of specified type"
		family   [integer!]
		type     [integer!]
		protocol [integer!]
		return:  [SOCKET!]
	][
		#either OS = 'Windows [
			WSASocket family type protocol NULL 0 0
		][
			socket family type protocol
		]
	]

	get-error: func[return: [integer!]][
		#either OS = 'Windows [WSAGetLastError][error]
	]

	dispose: does[
		#if OS = 'Windows [
			WSACleanup
			wsa/version: 0
		]
	]
]
