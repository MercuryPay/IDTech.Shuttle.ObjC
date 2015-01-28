IDTech.Shuttle.ObjC
====================

* More documentation?  http://developer.mercurypay.com
* Questions?  integrationteam@mercurypay.com
* **Feature request?** Open an issue.
* Feel like **contributing**?  Submit a pull request.


## Overview

This is a sample Xcode iOS application demonstrating the capture of an encrypted credit card swipe from an IDTECH device and then processing a test transaction through the Mercury SOAP WebServices platform.

>There are 6 steps to this process

##Step 1: Retrieve the IDTECH sdk from the IDTECH site.  Please contact your Integration Team member for more details.

##Step 2: Setup the IDTECH device

The code below assumes the device was attached before the code executes.  The example code provides better definition of how to handle other cases.

```
[uniMag enableLogging:true];
self.uniMag = [[uniMag alloc] init];
[self.uniMag setAutoConnect:false];
[self.uniMag setSwipeTimeoutDuration:0];
[self.uniMag setAutoAdjustVolume:true];
[self.uniMag setWavePath: [NSHomeDirectory() stringByAppendingPathComponent: @"/Documents/audio.caf"]];
[self.uniMag startUniMag:true];

//usually called in the attached event
[self uniMag_activate];

//usually called in the connected event
[self.uniMag requestSwipe];
```

##Step 3: Register Observers

```
NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

[nc addObserver:self selector:@selector(umDevice_attachment:) name:uniMagAttachmentNotification object:nil];
[nc addObserver:self selector:@selector(umDevice_detachment:) name:uniMagDetachmentNotification object:nil];
[nc addObserver:self selector:@selector(umConnection_lowVolume:) name:uniMagInsufficientPowerNotification object:nil];
[nc addObserver:self selector:@selector(umConnection_starting:) name:uniMagPoweringNotification object:nil];
[nc addObserver:self selector:@selector(umConnection_timeout:) name:uniMagTimeoutNotification object:nil];
[nc addObserver:self selector:@selector(umConnection_connected:) name:uniMagDidConnectNotification object:nil];
[nc addObserver:self selector:@selector(umConnection_disconnected:) name:uniMagDidDisconnectNotification object:nil];
[nc addObserver:self selector:@selector(umSwipe_starting:) name:uniMagSwipeNotification object:nil];
[nc addObserver:self selector:@selector(umSwipe_timeout:) name:uniMagTimeoutSwipeNotification object:nil];
[nc addObserver:self selector:@selector(umDataProcessing:) name:uniMagDataProcessingNotification object:nil];
[nc addObserver:self selector:@selector(umSwipe_invalid:) name:uniMagInvalidSwipeNotification object:nil];
[nc addObserver:self selector:@selector(umSwipe_receivedSwipe:) name:uniMagDidReceiveDataNotification object:nil];
[nc addObserver:self selector:@selector(umCommand_starting:) name:uniMagCmdSendingNotification object:nil];
[nc addObserver:self selector:@selector(umCommand_timeout:) name:uniMagCommandTimeoutNotification object:nil];
[nc addObserver:self selector:@selector(umCommand_receivedResponse:) name:uniMagDidReceiveCmdNotification object:nil];
[nc addObserver:self selector:@selector(umSystemMessage:) name:uniMagSystemMessageNotification object:nil];
```

##Step 4: Parse Swipe Data

This code is verbose so instead of listing it here please look at the umSwipe_receivedSwipe method in SwipeViewController.m. 

##Step 5: Send Request to Mercury

You will find this code in the transactionFromDictionary method of MercuryHelper.m

##Step 6: Parse Response

The response from Mercury is also processed and stored in a Dictionary in the DidEndElement method of MercuryHelper.m.  Essentially this works as two NSXMLParser passes.  The first pass parses the CreditTransactionResult data out of the response and then the second pass parses the Transaction XML into a Dictionary.

###©2014 Mercury Payment Systems, LLC - all rights reserved.

Disclaimer:
This software and all specifications and documentation contained herein or provided to you hereunder (the "Software") are provided free of charge strictly on an "AS IS" basis. No representations or warranties are expressed or implied, including, but not limited to, warranties of suitability, quality, merchantability, or fitness for a particular purpose (irrespective of any course of dealing, custom or usage of trade), and all such warranties are expressly and specifically disclaimed. Mercury Payment Systems shall have no liability or responsibility to you nor any other person or entity with respect to any liability, loss, or damage, including lost profits whether foreseeable or not, or other obligation for any cause whatsoever, caused or alleged to be caused directly or indirectly by the Software. Use of the Software signifies agreement with this disclaimer notice.


