//
//  DatamiSDStateChangePlugin.h
//  GAIntegration
//
//  Created by Damandeep Singh on 09/10/17.
//

#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

@interface DatamiSDStateChangePlugin : CDVPlugin {
    
    NSString* sdStatus;
    NSString* prevSdStatus;
    NSString* _callbackId;

}
- (void)getSDState:(CDVInvokedUrlCommand*)command;

@end
