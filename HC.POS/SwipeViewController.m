//
//  SwipeViewController.m
//  Shuttle.Mobile.Starter.Kit
//
//  Created by agharris73 on 9/18/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "SwipeViewController.h"
#import "AppDelegate.h"

@implementation SwipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.magTek = [[MTSCRA alloc] init];
    [self.magTek listenForEvents:(TRANS_EVENT_OK|TRANS_EVENT_START|TRANS_EVENT_ERROR)];
    [self.magTek setDeviceProtocolString:(@"com.magtek.idynamo")];
    
    // Enable info level NSLogs inside SDK
    // Here we turn on before initializing SDK object so the act of initializing is logged
    [uniMag enableLogging:true];
    
    // Initialize the SDK by creating a uniMag class object
    self.uniMag = [[uniMag alloc] init];
    
    // Set SDK to perform the connect task automatically when headset is attached
    [self.uniMag setAutoConnect:false];
    
    // Set swipe timeout to infinite. By default, swipe task will timeout after 20 seconds
	[self.uniMag setSwipeTimeoutDuration:0];
    
    // Make SDK maximize the volume automatically during connection
    [self.uniMag setAutoAdjustVolume:true];
    
    // By default, the diagnostic wave file logged by the SDK is stored under the temp directory
    // Here it is set to be under the Documents folder in the app sandbox so the log can be accessed
    // through iTunes file sharing. See UIFileSharingEnabled in iOS doc.
    [self.uniMag setWavePath: [NSHomeDirectory() stringByAppendingPathComponent: @"/Documents/audio.caf"]];
    
    self.simSwipeuDynamoSwitch.on = false;
    self.simSwipeiDynamoSwitch.on = false;
    self.simSwipeUniMagIISwitch.on = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)simSwipeuDynamoButtonPressed:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:!self.simSwipeuDynamoSwitch.on animated:true];
    [self.simSwipeiDynamoSwitch setOn:false animated:true];
    [self.simSwipeUniMagIISwitch setOn:false animated:true];
    
    [self uniMag_deactivate];
    [self magTek_deactivate];
    
    if (self.simSwipeuDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKAUDIOREADER];
    }
}

- (IBAction)simSwipeduDynamoSwitchFlipped:(id)sender {
    [self.simSwipeiDynamoSwitch setOn:false animated:true];
    [self.simSwipeUniMagIISwitch setOn:false animated:true];
    
    [self uniMag_deactivate];
    [self magTek_deactivate];
    
    if (self.simSwipeuDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKAUDIOREADER];
    }
}

- (IBAction)simSwipeiDynamoButtonPressed:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:false animated:true];
    [self.simSwipeiDynamoSwitch setOn:!self.simSwipeiDynamoSwitch.on animated:true];
    [self.simSwipeUniMagIISwitch setOn:false animated:true];
    
    [self uniMag_deactivate];
    [self magTek_deactivate];
    
    if (self.simSwipeiDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKIDYNAMO];
    }
}

- (IBAction)simSwipeiDynamoSwitchFlipped:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:false animated:true];
    [self.simSwipeUniMagIISwitch setOn:false animated:true];
    
    [self uniMag_deactivate];
    [self magTek_deactivate];
    
    if (self.simSwipeiDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKIDYNAMO];
    }
}

- (IBAction)simSwipeUniMagIIButtonPressed:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:false animated:true];
    [self.simSwipeiDynamoSwitch setOn:false animated:true];
    [self.simSwipeUniMagIISwitch setOn:!self.simSwipeUniMagIISwitch.on animated:true];
    
    [self uniMag_deactivate];
    [self magTek_deactivate];
    
    if (self.simSwipeUniMagIISwitch.on) {
        [self uniMag_activate];
    }
}

- (IBAction)simSwipeUniMagIISwitchFlipped:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:false animated:true];
    [self.simSwipeiDynamoSwitch setOn:false animated:true];
    
    [self uniMag_deactivate];
    [self magTek_deactivate];
    
    if (self.simSwipeUniMagIISwitch.on) {
        [self uniMag_activate];
    }
}

//-----------------------------------------------------------------------------
#pragma mark - MagTek SDK activation/deactivation -
//-----------------------------------------------------------------------------

- (void)magtek_activateWithDeviceType:(UInt32)deviceType
{
    [self.magTek setDeviceType:deviceType];
    [self.magTek openDevice];
    [self magtek_registerObservers:true];
    [self displayDeviceStatus];
}

-(void)magTek_deactivate {
    [self magtek_registerObservers:false];
    [self disconnected];
    
    if (self.magTek != NULL && self.magTek.isDeviceOpened)
    {
        [self.magTek closeDevice];
    }
    
}

//-----------------------------------------------------------------------------
#pragma mark - MagTek SDK observers -
//-----------------------------------------------------------------------------

- (void)magtek_registerObservers:(BOOL) reg {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    if (reg) {
        [nc addObserver:self selector:@selector(trackDataReady:) name:@"trackDataReadyNotification" object:nil];
        [nc addObserver:self selector:@selector(devConnStatusChange) name:@"devConnectionNotification" object:nil];
    }
    else {
        [nc removeObserver:self];
    }
}


- (void)trackDataReady:(NSNotification *)notification
{
    NSNumber *status = [[notification userInfo] valueForKey:@"status"];
    
    [self performSelectorOnMainThread:@selector(onDataEvent:)
                           withObject:status
                        waitUntilDone:NO];
}

- (void)onDataEvent:(id)status
{
    switch ([status intValue]) {
        case TRANS_STATUS_OK:
            NSLog(@"TRANS_STATUS_OK");
            self.encryptedSwipeData = [[EncryptedSwipeData alloc] init];
            self.encryptedSwipeData.track1Masked = self.magTek.getTrack1Masked;
            self.encryptedSwipeData.track2Masked = self.magTek.getTrack2Masked;
            self.encryptedSwipeData.track1Encrypted = self.magTek.getTrack1;
            self.encryptedSwipeData.track2Encrypted = self.magTek.getTrack2;
            self.encryptedSwipeData.ksn = self.magTek.getKSN;
            [self determineNextStep];
            break;
        case TRANS_STATUS_ERROR:
            NSLog(@"TRANS_STATUS_ERROR");
            break;
        default:
            break;
    }
}

- (void)devConnStatusChange
{
    [self displayDeviceStatus];
}

//-----------------------------------------------------------------------------
#pragma mark - UniMag SDK activation/deactivation -
//-----------------------------------------------------------------------------

- (void)uniMag_activate {
    [self.uniMag startUniMag:true];
    [self uniMag_registerObservers:true];
    [self displayDeviceStatus];
}

-(void)uniMag_deactivate {
    if (self.uniMag != NULL && self.uniMag.getConnectionStatus)
    {
        [self.uniMag startUniMag:false];
    }
    
    [self uniMag_registerObservers:false];
    [self displayDeviceStatus];
}

//-----------------------------------------------------------------------------
#pragma mark - UniMag SDK observers -
//-----------------------------------------------------------------------------

-(void) uniMag_registerObservers:(BOOL) reg {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    if (reg) {
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
    }
    else {
        [nc removeObserver:self];
    }
    
}

//called when uniMag is physically attached
- (void)umDevice_attachment:(NSNotification *)notification {
    if (self.simSwipeUniMagIISwitch.on) {
        [self uniMag_activate];
    }
    
    [self displayDeviceStatus];
}

//called when uniMag is physically detached
- (void)umDevice_detachment:(NSNotification *)notification {
    if (!self.simSwipeUniMagIISwitch.on) {
        [self uniMag_deactivate];
    }
    
    [self displayDeviceStatus];
}

#pragma mark connection task

//called when attempting to start the connection task but iDevice's headphone playback volume is too low
- (void)umConnection_lowVolume:(NSNotification *)notification {
}

//called when successfully starting the connection task
- (void)umConnection_starting:(NSNotification *)notification {
}

//called when SDK failed to handshake with reader in time. ie, the connection task has timed out
- (void)umConnection_timeout:(NSNotification *)notification {
}

////called when the connection task is successful. SDK's connection state changes to true
- (void)umConnection_connected:(NSNotification *)notification {
    [self.uniMag requestSwipe];
    [self displayDeviceStatus];
}

//called when SDK's connection state changes to false. This happens when reader becomes
// physically detached or when a disconnect API is called
- (void)umConnection_disconnected:(NSNotification *)notification {
    [self displayDeviceStatus];
}

#pragma mark swipe task

//called when the swipe task is successfully starting, meaning the SDK starts to
// wait for a swipe to be made
- (void)umSwipe_starting:(NSNotification *)notification {
}

//called when the SDK hasn't received a swipe from the device within a configured
// "swipe timeout interval".
- (void)umSwipe_timeout:(NSNotification *)notification {
}

//called when the SDK has read something from the uniMag device
// (eg a swipe, a response to a command) and is in the process of decoding it
// Use this to provide an early feedback on the UI
- (void)umDataProcessing:(NSNotification *)notification {
}

//called when SDK failed to read a valid card swipe
- (void)umSwipe_invalid:(NSNotification *)notification {
    [self.uniMag requestSwipe];
}

//called when SDK received a swipe successfully
- (void)umSwipe_receivedSwipe:(NSNotification *)notification {
    
    @try {
    
	NSData *data = [notification object];
    int index = 0;
    char *ptr = (char *)[data bytes]; // Set a pointer to the beginning of the bytes
    
    char stx = *ptr;
    ptr++;
    index++;
    
    Byte lowByte = *ptr;
    ptr++;
    index++;
    
    Byte highByte = *ptr;
    ptr++;
    index++;
    
    char cardEncodeType = *ptr;
    ptr++;
    index++;
    
    char trackStatus = *ptr;
    ptr++;
    index++;
    
    int track1MaskedLength = *ptr;
    int track1EncryptedLength = [self encryptedLengthFromMasked: track1MaskedLength];
    ptr++;
    index++;
    
    int track2MaskedLength = *ptr;
    int track2EncryptedLength = [self encryptedLengthFromMasked: track2MaskedLength];
    ptr++;
    index++;
    
    int track3MaskedLength = *ptr;
    int track3EncryptedLength = [self encryptedLengthFromMasked: track3MaskedLength];
    ptr++;
    index++;
    
    char fieldByte1 = *ptr;
    ptr++;
    index++;
    
    char fieldByte2 = *ptr;
    ptr++;
    index++;
    
    NSData *track1MaskedData = [data subdataWithRange:NSMakeRange(index, track1MaskedLength)];
    NSString *track1MaskedString = [[NSString alloc] initWithData:track1MaskedData encoding:NSASCIIStringEncoding];
    ptr += track1MaskedLength;
    index += track1MaskedLength;
    
    NSData *track2MaskedData = [data subdataWithRange:NSMakeRange(index, track2MaskedLength)];
    NSString *track2MaskedString = [[NSString alloc] initWithData:track2MaskedData encoding:NSASCIIStringEncoding];
    ptr += track2MaskedLength;
    index += track2MaskedLength;
    
    NSData *track3MaskedData = [data subdataWithRange:NSMakeRange(index, track3MaskedLength)];
    NSString *track3MaskedString = [[NSString alloc] initWithData:track3MaskedData encoding:NSASCIIStringEncoding];
    ptr += track3MaskedLength;
    index += track3MaskedLength;
    
    NSData *track1EncryptedData = [data subdataWithRange:NSMakeRange(index, track1EncryptedLength)];
    NSString *track1EncryptedHex = [self hexFromData:track1EncryptedData];
    ptr += track1EncryptedLength;
    index += track1EncryptedLength;
    
    NSData *track2EncryptedData = [data subdataWithRange:NSMakeRange(index, track2EncryptedLength)];
    NSString *track2EncryptedHex = [self hexFromData:track2EncryptedData];;
    ptr += track2EncryptedLength;
    index += track2EncryptedLength;
    
    NSData *track3EncryptedData = [data subdataWithRange:NSMakeRange(index, track3EncryptedLength)];
    NSString *track3EncryptedHex = [self hexFromData:track3EncryptedData];
    ptr += track3EncryptedLength;
    index += track3EncryptedLength;
    
    NSData *serailNumberData = [data subdataWithRange:NSMakeRange(index, 10)];
    NSString *serailNumberHex = [self hexFromData:serailNumberData];
    ptr += 10;
    index += 10;
    
    NSData *ksnData = [data subdataWithRange:NSMakeRange(index, 10)];
    NSString *ksnHex = [self hexFromData:ksnData];
    ptr += 10;
    index += 10;
    
    char lrc = *ptr;
    ptr++;
    index++;
    
    char checksum = *ptr;
    ptr++;
    index++;
    
    char etx = *ptr;
    ptr++;
    index++;
    
    self.encryptedSwipeData = [[EncryptedSwipeData alloc] init];
    self.encryptedSwipeData.track1Masked = track1MaskedString;
    self.encryptedSwipeData.track2Masked = track2MaskedString;
    self.encryptedSwipeData.track1Encrypted = track1EncryptedHex;
    self.encryptedSwipeData.track2Encrypted = track2EncryptedHex;
    self.encryptedSwipeData.ksn = ksnHex;
    
	NSString *text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        self.encryptedSwipeData = [[EncryptedSwipeData alloc] init];
    }
    @finally {
        [self.uniMag requestSwipe];
        [self determineNextStep];
    }
    
}

#pragma mark command task

//called when SDK successfully starts to send a command. SDK starts the command
// task
- (void)umCommand_starting:(NSNotification *)notification {
}

//called when SDK failed to receive a command response within a configured
// "command timeout interval"
- (void)umCommand_timeout:(NSNotification *)notification {
}

//called when SDK successfully received a response to a command
- (void)umCommand_receivedResponse:(NSNotification *)notification {
}

//-----------------------------------------------------------------------------
#pragma mark - Infinite SDK observers -
//-----------------------------------------------------------------------------

-(void)connectionState:(int)state {
    [self displayDeviceStatus];
//    switch (state) {
//		case CONN_DISCONNECTED: {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle: @"Disconnected"
//                                  message: @"Disconnected"
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles: nil];
//            
//            [alert show];
//            break;
//        }
//		case CONN_CONNECTING: {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle: @"Conencting"
//                                  message: @"Connecting"
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles: nil];
//            
//            [alert show];
//            break;
//        }
//		case CONN_CONNECTED: {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle: @"Connected"
//                                  message: @"Connected"
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles: nil];
//            
//            [alert show];
//			break;
//        }
//	}
}

-(void)deviceButtonPressed:(int)which {
    
}

-(void)deviceButtonReleased:(int)which {
    
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    
}

-(void)barcodeNSData:(NSData *)barcode type:(int)type {
    
}

-(void)barcodeNSData:(NSData *)barcode isotype:(NSString *)isotype {
    
}

-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3 {
    
    self.encryptedSwipeData = [[EncryptedSwipeData alloc] init];
    self.encryptedSwipeData.track1Masked = @"%*549999******6781^TEST/MPS^1512*************?";
    self.encryptedSwipeData.track2Masked = @";549999******6781=1512****************?";
    self.encryptedSwipeData.track1Encrypted = @"a2d0940f14e58ebed9cdc09872eabaf2f94247682980a770c16e2299670af6106e026a8c219b1ee8d35488635be8e5e6";
    self.encryptedSwipeData.track2Encrypted = @"520adcb857b219800fe7f37a81dd4f43a8f782bd0d66614ec1fb32c48131e59fb2f7f2bd6668ec49";
    self.encryptedSwipeData.ksn = @"62994910450002000102";
    [self determineNextStep];

//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle: @"magneticCardData"
//                          message: @"magneticCardData"
//                          delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles: nil];
//    
//    [alert show];
    
}

-(void)magneticCardEncryptedData:(int)encryption tracks:(int)tracks data:(NSData *)data {
    
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle: @"magneticCardEncryptedData"
//                          message: @"magneticCardEncryptedData"
//                          delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles: nil];
//    
//    [alert show];
    
}

-(void)magneticCardEncryptedData:(int)encryption tracks:(int)tracks data:(NSData *)data track1masked:(NSString *)track1masked track2masked:(NSString *)track2masked track3:(NSString *)track3 {
    
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle: @"magneticCardEncryptedData (with masked data)"
//                          message: @"magneticCardEncryptedData (with masked data)"
//                          delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles: nil];
//
//    [alert show];
    
}

-(void)magneticCardRawData:(NSData *)tracks {
    
}

-(void)magneticCardEncryptedRawData:(int)encryption data:(NSData *)data {
}

-(void)firmwareUpdateProgress:(int)phase percent:(int)percent {
    
}

-(void)bluetoothDiscoverComplete:(BOOL)success {
    
}

-(void)bluetoothDeviceDiscovered:(NSString *)address name:(NSString *)name{
    
}

-(void)bluetoothDeviceConnected:(NSString *)address {
    
}

-(void)bluetoothDeviceDisconnected:(NSString *)address {
    
}

-(BOOL)bluetoothDeviceRequestedConnection:(NSString *)address name:(NSString *)name {
    return true;
}

-(NSString *)bluetoothDevicePINCodeRequired:(NSString *)address name:(NSString *)name {
    return @"";
}

-(void)magneticJISCardData:(NSString *)data {
    
}

-(void)rfCardRemoved:(int)cardIndex {
    
}

-(void)deviceFeatureSupported:(int)feature value:(int)value {
    
}

-(void)PINEntryCompleteWithError:(NSError *)error {
    
}

-(void)paperStatus:(BOOL)present {
    
}
//-----------------------------------------------------------------------------
#pragma mark - Methods -
//-----------------------------------------------------------------------------

- (IBAction)disconnected {
    
    self.imageCardState.image = [UIImage imageNamed:@"ccStaticState.png"];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade; // there are other types but this is the nicest
    transition.duration = 0.34; // set the duration that you like
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.imageCardState.layer addAnimation:transition forKey:nil];
}

- (IBAction)connected {
    self.imageCardState.image = [UIImage imageNamed:@"ccSwipeState.png"];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade; // there are other types but this is the nicest
    transition.duration = 0.34; // set the duration that you like
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.imageCardState.layer addAnimation:transition forKey:nil];
}

- (void)displayDeviceStatus
{
    BOOL isMagTekDeviceConnected = [self.magTek isDeviceConnected];
    BOOL isMagTekDeviceOpen = [self.magTek isDeviceOpened];
    BOOL isUniMagReaderAttached = [self.uniMag isReaderAttached];
    BOOL isUniMagReaderConnected = self.uniMag.getConnectionStatus;
    
    if ((self.magTek && isMagTekDeviceConnected && isMagTekDeviceOpen)
        || (self.uniMag && isUniMagReaderAttached && isUniMagReaderConnected)){
        [self connected];
    }
    else {
        [self disconnected];
    }
}

- (int) encryptedLengthFromMasked: (int)maskedLength {
    int value = maskedLength;
    
    if (value > 0) {
        value = abs(8-(maskedLength % 8)) + maskedLength;
    }
    
    return value;
}

- (NSString*) hexFromData:(NSData*) data
{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength  = data.length;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02x", (unsigned int)dataBuffer[i]]];
    }
    
    return [NSString stringWithString:hexString];
}

- (void)determineNextStep {
    
    [self magTek_deactivate];
    [self uniMag_deactivate];
    
    if (self.encryptedSwipeData != nil
        && self.encryptedSwipeData.track2Masked != nil
        && [self.encryptedSwipeData.track2Masked rangeOfString:@"="].location != NSNotFound)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.encryptedSwipeData = self.encryptedSwipeData;
        [self performSegueWithIdentifier:@"segueSwipeResults" sender:self];
    }
    else if (self.simSwipeiDynamoSwitch.on) {
        [self magtek_activateWithDeviceType: MAGTEKIDYNAMO];
    }
    else if(self.simSwipeuDynamoSwitch.on) {
        [self magtek_activateWithDeviceType: MAGTEKAUDIOREADER];
    }
    else if (self.simSwipeUniMagIISwitch.on) {
        [self uniMag_activate];
    }
}

@end
