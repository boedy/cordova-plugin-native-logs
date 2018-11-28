
#import <Cordova/CDV.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "CDVLogFormatter.h"

@interface CDVNativeLogs : CDVPlugin

- (void)pluginInitialize;
- (NSString*) getPath;
- (void) getLog:(CDVInvokedUrlCommand*)command;
- (void) setLogLevel:(CDVInvokedUrlCommand*)command;
- (void) identify:(CDVInvokedUrlCommand*)command;

@property DDFileLogger *fileLogger;
@property CDVLogFormatter *formatter;

@end
