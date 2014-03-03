//
//  XMG8tracksConnector.m
//  MixGallery
//
//  Created by Camille  Kander on 01/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import "XMG8tracksConnector.h"
#import "XMGMix.h"

@interface XMG8tracksConnector ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation XMG8tracksConnector

- (id)init {
    
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

+ (instancetype)sharedConnector {
    
    static XMG8tracksConnector *sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnector = [[self alloc] init];
    });
    
    return sharedConnector;
}

- (NSDictionary *)dictionaryWithData:(NSData *)responseData {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (error) {
        return nil;
    } else {
        return jsonObject;
    }
}

- (void)grabSomeMixesWithCompletionBlock:(void (^)(NSArray *mixes))completionBlock {
    
    NSURL *url = [NSURL URLWithString:@"http://8tracks.com/mix_sets/all.json?include=mixes"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:XMG8tracksAPIKey forHTTPHeaderField:@"X-Api-Key"];
    NSLog(@"%@", [request allHTTPHeaderFields]);
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            NSDictionary *mixSet = [self dictionaryWithData:data];
            NSArray *mixes = [mixSet objectForKey:@"mixes"];
            NSMutableArray *mixObjects = [[NSMutableArray alloc] initWithCapacity:mixes.count];
            
            for (NSDictionary *mixDictionary in mixes) {
                XMGMix *mix = [XMGMix mixWithDictionary:mixDictionary];
                [mixObjects addObject:mix];
            }
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(mixObjects);
                });
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:connectionError.localizedDescription delegate:nil cancelButtonTitle:@"Welp…" otherButtonTitles:nil] show];
                
                if (completionBlock) {
                    completionBlock(nil);
                }
            });
        }
    }];
}

- (void)grabImageForMix:(XMGMix *)mix withCompletionBlock:(void (^)(UIImage *image))completionBlock {
    
    NSString *urlString = [mix.coverURLs objectForKey:@"sq500"];
    
    if (urlString) {
        NSURL *url = [NSURL URLWithString:urlString];
        
        if (url) {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (!connectionError) {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(image);
                        });
                    }
                } else {
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil);
                        });
                    }
                }
            }];
        }
    }
}

@end
