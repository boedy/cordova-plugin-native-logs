
#import <Cordova/CDV.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface CDVNativeLogs : CDVPlugin

- (void)pluginInitialize;
- (NSString*) getPath;
- (void) getLog:(CDVInvokedUrlCommand*)command;
- (void) setLogLevel:(CDVInvokedUrlCommand*)command;

@property DDFileLogger *fileLogger;

@end
