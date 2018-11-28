#import "CDVLogFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation CDVLogFormatter

- (void) identify:(NSString *) identity {
    _identity = identity;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    int timestamp = (int) [logMessage->_timestamp timeIntervalSince1970];
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"error"; break;
        case DDLogFlagWarning  : logLevel = @"warning"; break;
        case DDLogFlagInfo     : logLevel = @"info"; break;
        case DDLogFlagDebug    : logLevel = @"debug"; break;
        default                : logLevel = @"verbose"; break;
    }
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"%d",timestamp], @"timestamp",
                                    logLevel, @"log_level",
                                    logMessage->_message, @"message",
                                 nil];
    
    if(_identity){
        [messageDict setObject:_identity forKey:@"identity"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDict options:0 error:&error];
    
    if (! jsonData) {
        return [NSString stringWithFormat:@"%d %@", timestamp, logMessage->_message];
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end

