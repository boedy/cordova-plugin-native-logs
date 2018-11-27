#import "CDVNativeLogs.h"
#import <Cordova/CDV.h>

static DDLogLevel ddLogLevel = DDLogLevelDebug;


@implementation CDVNativeLogs

// this is a test log line
- (void)pluginInitialize
{   
    // lumberjack code
    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log
    
    self.fileLogger = [[DDFileLogger alloc] init]; // File Logger
    self.fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:self.fileLogger];
}

- (NSString*) getPath {
    NSArray *filePaths = [[self.fileLogger logFileManager] sortedLogFilePaths];
    return filePaths.count > 0 ? filePaths[0] : @"";
}

- (void) setLogLevel:(CDVInvokedUrlCommand *)command {
    
    if (command.arguments.count != 1)
    {
        NSString* error = @"missing logLevel argument";
        DDLogError(@"CDVNativeLogs: %@",error);
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return ;
    }
    
    NSString *value = [command argumentAtIndex:0];
    DDLogLevel logLevel;
    
    if([value isEqualToString:@"info"]){
        logLevel = DDLogLevelInfo;
    }else if([value isEqualToString:@"verbose"]){
        logLevel = DDLogLevelVerbose;
    }else if([value isEqualToString:@"debug"]){
        logLevel = DDLogLevelDebug;
    }else if([value isEqualToString:@"error"]){
        logLevel = DDLogLevelError;
    }else if([value isEqualToString:@"warning"]){
        logLevel = DDLogLevelWarning;
    }else{
        NSString* error = @"Invalid logLevel";
        DDLogError(@"CDVNativeLogs: %@",error);
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return ;
    }
    
    for ( NSString *class in [DDLog registeredClassNames])
    {
//        DDLogVerbose(@"Enable logs for class: %@", class);
        [DDLog setLevel:logLevel forClassWithName:class];
    }
}

- (void)getLog:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
      if (command.arguments.count != 1)
      {
          NSString* error = @"missing arguments in getLog";
          NSLog(@"CDVNativeLogs: %@",error);
          CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
          return ;
      }

      int nbLines = 1000;  // maxline
    
      id value = [command argumentAtIndex:0];
      if ([value isKindOfClass:[NSNumber class]]) {
          nbLines = [value intValue];
      }

      value = [command argumentAtIndex:1];

      NSString* pathForLog = [self getPath];
      NSString *stringContent = [NSString stringWithContentsOfFile:pathForLog encoding:NSUTF8StringEncoding error:nil];

      NSString* log = @"";
      NSArray *brokenByLines=[stringContent componentsSeparatedByString:@"\n"];

      NSRange endRange = NSMakeRange(brokenByLines.count >= nbLines ?
                                     brokenByLines.count - nbLines
                                  : 0, MIN(brokenByLines.count, nbLines));

      for(id line in [brokenByLines subarrayWithRange:endRange])
      {
          if ([line length]==0) {
              continue ;
          }

          log = [log stringByAppendingString:line];
          log = [log stringByAppendingString:@"\n"];
      }

      CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:log];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}



@end
