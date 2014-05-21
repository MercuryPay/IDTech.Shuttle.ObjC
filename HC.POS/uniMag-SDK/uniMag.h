/* Copyright 2010-2012 ID TECH. All rights reserved.
*/

#import <Foundation/Foundation.h>

//Versioning
#define UMSDK_VERSION @"7.3"
#define UMSDK_CUSTOMIZATION 0

//Notification identifiers used with NSNotificationCenter
  //physical attachment related
extern NSString * const uniMagAttachmentNotification;
extern NSString * const uniMagDetachmentNotification;
  //connection related
extern NSString * const uniMagInsufficientPowerNotification;
extern NSString * const uniMagPoweringNotification;
extern NSString * const uniMagTimeoutNotification;
extern NSString * const uniMagDidConnectNotification;
extern NSString * const uniMagDidDisconnectNotification;
  //swipe related
extern NSString * const uniMagSwipeNotification;
extern NSString * const uniMagTimeoutSwipeNotification;
extern NSString * const uniMagDataProcessingNotification;
extern NSString * const uniMagInvalidSwipeNotification;
extern NSString * const uniMagDidReceiveDataNotification;
  //command related
extern NSString * const uniMagCmdSendingNotification;
extern NSString * const uniMagCommandTimeoutNotification;
extern NSString * const uniMagDidReceiveCmdNotification;
  //misc
extern NSString * const uniMagSystemMessageNotification;

//SDK async task types
typedef enum {
    UMTASK_NONE,       //no async task running. SDK idle.
    UMTASK_CONNECT,    //connection task
    UMTASK_SWIPE,      //swipe task
    UMTASK_CMD,        //command task
    UMTASK_FW_UPDATE,  //firmware update task
} UmTask;

//async task methods return value
                            //Description               |Applicable task
                            //                          |Connect|Swipe|Cmd|Update
typedef enum {              //--------------------------+-------+-----+---+------
    UMRET_SUCCESS,          //no error, beginning task  | *     | *   | * | *
    UMRET_NO_READER,        //no reader attached        | *     | *   | * | *
    UMRET_SDK_BUSY,         //SDK is doing another task | *     | *   | * | *
    UMRET_MONO_AUDIO,       //mono audio is enabled     | *     |     | * |
    UMRET_ALREADY_CONNECTED,//did connection already    | *     |     |   |
    UMRET_LOW_VOLUME,       //audio volume is too low   | *     |     |   |
    UMRET_NOT_CONNECTED,    //did not do connection     |       | *   |   |
    UMRET_UF_INVALID_STR,   //UF wrong string format    |       |     |   | *
    UMRET_UF_NO_FILE,       //UF file not found         |       |     |   | *
    UMRET_UF_INVALID_FILE,  //UF wrong file format      |       |     |   | *
} UmRet;

static inline NSString* UmRet_lookup(UmRet c) {
#define URLOOK(a) case a: return @#a;
    switch (c) {
    URLOOK(UMRET_SUCCESS          )
    URLOOK(UMRET_NO_READER        )
    URLOOK(UMRET_SDK_BUSY         )
    URLOOK(UMRET_MONO_AUDIO       )
    URLOOK(UMRET_ALREADY_CONNECTED)
    URLOOK(UMRET_LOW_VOLUME       )
    URLOOK(UMRET_NOT_CONNECTED    )
    URLOOK(UMRET_UF_INVALID_STR   )
    URLOOK(UMRET_UF_NO_FILE       )
    URLOOK(UMRET_UF_INVALID_FILE  )
    default: return @"<unknown code>";
    }
#undef URLOOK
}

//updateFirmware: codes return from notifications identifying their type
typedef enum {
    UMUFCODE_SENDING_BLOCK=21,
    UMUFCODE_VERIFYING_CHECKSUM=30,
    UMUFCODE_RESENDING_BLOCK=40,
    UMUFCODE_FAILED_TO_ENTER_BOOTLOADER_MODE=303,
    UMUFCODE_FAILED_TO_SEND_BLOCK=305,
    UMUFCODE_FAILED_TO_VERIFY_CHECKSUM=306,
    UMUFCODE_CANCELED=307,
} UmUfCode;

//updateFirmware: dict key for block number from applicable notifications
extern NSString * const UmUfBlockNumberKey;

//tag used by SDK internally when logging
// look for NSLog entries with these tags
#define UMLOG_ERROR    @"[UM Error] "
#define UMLOG_WARNING  @"[UM Warning] "
#define UMLOG_INFO     @"[UM Info] "


@interface uniMag : NSObject

//version
+(NSString*) SDK_version;

//status
-(BOOL) isReaderAttached;
-(BOOL) getConnectionStatus;
-(UmTask) getRunningTask;
-(float) getVolumeLevel;

//config
-(void) setAutoConnect:(BOOL)autoConnect;
-(BOOL) setSwipeTimeoutDuration:(NSInteger) seconds;
-(BOOL) setCmdTimeoutDuration:(NSInteger) seconds;
-(void) setAutoAdjustVolume:(BOOL) b;
-(void) setDeferredActivateAudioSession:(BOOL) b;

//task
-(void) cancelTask;

//connect
-(UmRet) startUniMag:(BOOL)start;

//swipe
-(UmRet) requestSwipe;
-(NSData*) getFlagByte;

//commands
-(UmRet) sendCommandGetVersion;
-(UmRet) sendCommandGetSettings;
-(UmRet) sendCommandEnableTDES;
-(UmRet) sendCommandEnableAES;
-(UmRet) sendCommandDefaultGeneralSettings;
-(UmRet) sendCommandGetSerialNumber;
-(UmRet) sendCommandGetNextKSN;
-(UmRet) sendCommandEnableErrNotification;
-(UmRet) sendCommandDisableErrNotification;
-(UmRet) sendCommandEnableExpDate;
-(UmRet) sendCommandDisableExpDate;
-(UmRet) sendCommandEnableForceEncryption;
-(UmRet) sendCommandDisableForceEncryption;
-(UmRet) sendCommandSetPrePAN: (NSInteger) prePAN;
-(UmRet) sendCommandClearBuffer;

// firmware updating
-(UmRet) getAuthentication;
-(BOOL) setFirmwareFile:(NSString*) location;
-(UmRet) updateFirmware: (NSString*) encrytedBytes;
-(UmRet) updateFirmware2:(NSString*) string withFile:(NSString*) path;

// troubleshooting
+(void) enableLogging:(BOOL) enable;
-(NSData*) getWave;
-(BOOL) setWavePath:(NSString*) path;

//deprecated
//  This API now does nothing
-(void) autoDetect:(BOOL)autoDetect;
//  Equivalent to '-setAutoConnect: ! prompt'
-(void) promptForConnection:(BOOL)prompt;
//  Equivalent to '-startUniMag: proceedPowerUp'
-(UmRet) proceedPoweringUp:(BOOL) proceedPowerUp;
//  Equivalent to '-startUniMag:FALSE'
-(void) closeConnection;
//  Equivalent to '-cancelTask'
-(void) cancelSwipe;

@end

