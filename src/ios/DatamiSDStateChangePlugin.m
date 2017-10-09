//
//  DatamiSDStateChangePlugin.m
//  GAIntegration
//
//  Created by Damandeep Singh on 09/10/17.
//

#import "DatamiSDStateChangePlugin.h"
#import "SmiSdk.h"
#import "AppDelegate+datami.h"

@implementation DatamiSDStateChangePlugin


- (void)pluginInitialize {
    NSLog(@"TES skvmnsdfkvndofsv T");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedStateChage:)
                                                 name:SDSTATE_CHANGE_NOTIF object:nil];
}

- (void)getSDState:(CDVInvokedUrlCommand*)command
{
    NSLog(@"TEST 2eweqw");
    _callbackId = command.callbackId;
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if (app.smiResult.sdState == SD_AVAILABLE) {
        sdStatus = @"SD_AVAILABLE";
    }
    else if (app.smiResult.sdState == SD_WIFI) {
        sdStatus = @"SD_WIFI";
    }
    else {
        sdStatus = [NSString stringWithFormat:@"SD_NOT_AVAILABLE, Reason: %@",[self getSDReasonAsString:app.smiResult.sdReason]];
    }
   // [self sendPluginResult];
}

- (void)sendPluginResult
{
    NSLog(@"TEST");
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: sdStatus];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
}

-(void)receivedStateChage:(NSNotification*)notif {
    SmiResult* sr =  notif.object;
    NSLog(@"receivedStateChag jnjjnljkn e, sdState: %ld", (long)sr.sdState);
    if (sr.sdState == SD_AVAILABLE) {
        sdStatus = @"SD_AVAILABLE";
    }
    else if (sr.sdState == SD_WIFI) {
        sdStatus = @"SD_WIFI";
    }
    else {
        sdStatus = [NSString stringWithFormat:@"SD_NOT_AVAILABLE, Reason: %@",[self getSDReasonAsString:sr.sdReason]];
    }
    [self sendPluginResult];
}


- (NSString *) getSDReasonAsString:(SdReason) reason {
    switch (reason) {
        case SD_REASON_NONE:
            return @"SD_REASON_NONE";
        case SD_REASON_DUPLICATE_API_CALL:
            return @"SD_REASON_DUPLICATE_API_CALL";
        case SD_NOT_AVAILABLE_FOR_OPERATOR:
            return @"SD_NOT_AVAILABLE_FOR_OPERATOR";
        case SD_NOT_AVAILABLE_FOR_APPLICATION:
            return @"SD_NOT_AVAILABLE_FOR_APPLICATION";
        case SD_NOT_AVAILABLE_FOR_URL:
            return @"SD_NOT_AVAILABLE_FOR_URL";
        case SD_NOT_AVAILABLE_FOR_DEVICE_OR_USER:
            return @"SD_NOT_AVAILABLE_FOR_DEVICE_OR_USER";
        case SD_NOT_AVAILABLE_PROMOTION_EXPIRED:
            return @"SD_NOT_AVAILABLE_PROMOTION_EXPIRED";
        case SD_NOT_AVAILABLE_PROMOTION_SUSPENDED:
            return @"SD_NOT_AVAILABLE_PROMOTION_SUSPENDED";
        case SD_NOT_AVAILABLE_PROMOTION_LIMIT_EXCEEDED:
            return @"SD_NOT_AVAILABLE_PROMOTION_LIMIT_EXCEEDED";
        case SD_NOT_AVAILABLE_USER_LIMIT_EXCEEDED:
            return @"SD_NOT_AVAILABLE_USER_LIMIT_EXCEEDED";
        case SD_NOT_AVAILABLE_PROMOTION_NOT_FOUND:
            return @"SD_NOT_AVAILABLE_PROMOTION_NOT_FOUND";
        case SD_NOT_AVAILABLE_SDK_INTERNAL_ERROR:
            return @"SD_NOT_AVAILABLE_SDK_INTERNAL_ERROR";
        case SD_NOT_AVAILABLE_SDK_VERSION_NOT_SUPPORTED:
            return @"SD_NOT_AVAILABLE_SDK_VERSION_NOT_SUPPORTED";
        case SD_NOT_AVAILABLE_SDK_REGISTRATION_NOT_DONE:
            return @"SD_NOT_AVAILABLE_SDK_REGISTRATION_NOT_DONE";
        case SD_NOT_AVAILABLE_SDK_NOT_SUPPORTED_FOR_APP_OR_CARRIER:
            return @"SD_NOT_AVAILABLE_SDK_NOT_SUPPORTED_FOR_APP_OR_CARRIER";
        case SD_NOT_AVAILABLE_URAM_NO_HEADER_INJECTED:
            return @"SD_NOT_AVAILABLE_URAM_NO_HEADER_INJECTED";
        case SD_NOT_AVAILABLE_SD_NOT_SUPPORTED_IN_ROAMING:
            return @"SD_NOT_AVAILABLE_SD_NOT_SUPPORTED_IN_ROAMING";
        case SD_NOT_AVAILABLE_SD_TESTING:
            return @"SD_NOT_AVAILABLE_SD_TESTING";
        case SD_NOT_AVAILABLE_REASON_UNKNOWN:
            return @"SD_NOT_AVAILABLE_REASON_UNKNOWN";
        default:
            return @"";
    }
}

@end
