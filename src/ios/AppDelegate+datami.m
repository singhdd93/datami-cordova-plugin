#import "AppDelegate+datami.h"
#import "SmiSdk.h"
#import "AppDelegate.h"
#import "DatamiCordovaPlugin.h"
#import <objc/runtime.h>

@implementation AppDelegate (notification)


- (id) getCommandInstance:(NSString*)className
{
    return [self.viewController getCommandInstance:className];
}

+ (void)load
{
    Method original, swizzled;

    original = class_getInstanceMethod(self, @selector(init));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_init));
    method_exchangeImplementations(original, swizzled);
}

- (AppDelegate *)swizzled_init
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:)
               name:@"UIApplicationDidFinishLaunchingNotification" object:nil];

	// This actually calls the original init method over in AppDelegate. Equivilent to calling super
	// on an overrided method, this is not recursive, although it appears that way. neat huh?
	return [self swizzled_init];
}

- (void)finishLaunching:(NSNotification *)notification
{
    // Call the Datami API at the beginning of didFinishLaunchingWithOptions, before other initializations.
    // IMPORTANT: If Datami API is not the first API called in the application then any network
    // connection made before Datami SDK initialization will be non-sponsored and will be
    // charged to the user.

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedStateChage:)
                                                 name:SDSTATE_CHANGE_NOTIF object:nil];

    DatamiCordovaPlugin *datamiPlugin = [self getCommandInstance:@"DatamiCordovaPlugin"];

    NSString* apiKey = [datamiPlugin.commandDelegate.settings objectForKey:[@"api_key" lowercaseString]];
    NSString* useSdkMessagin = [datamiPlugin.commandDelegate.settings objectForKey:[@"sdk_messaging" lowercaseString]];

    if([apiKey length] == 0) {
        apiKey = @"noApiKeySpecified";
    }

    if([useSdkMessagin length] == 0) {
        useSdkMessagin = @"NO";
    }

    Boolean sdkMessaging;

    if ([useSdkMessagin isEqualToString:@"YES"]){
        sdkMessaging = YES;
    }else {
        sdkMessaging = NO;
    }

    NSString* myUserId = @"";

    [SmiSdk initSponsoredData: apiKey userId: myUserId showSDMessage:sdkMessaging];
}

-(void)receivedStateChage:(NSNotification*)notif {
    SmiResult* sr =  notif.object;
    NSLog(@"receivedStateChage, sdState: %ld", (long)sr.sdState);
    if(sr.sdState == SD_AVAILABLE) {
        // TODO: show a banner or message to user, indicating that the data usage is sponsored and charges do not apply to user data plan
    } else if(sr.sdState == SD_NOT_AVAILABLE) {
        // TODO: show a banner or message to user, indicating that the data usage is NOT sponsored and charges apply to user data plan
        NSLog(@"receivedStateChage, sdReason %ld", (long)sr.sdReason);
    } else if(sr.sdState == SD_WIFI) {
        // wifi connection
    }
}

@end
