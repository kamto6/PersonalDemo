//
//  RDBaseLogicModel.m
//  Reindeer
//
//  Created by Wayde Sun on 3/26/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "RDBaseLogicModel.h"
#import "iHValidationKit.h"
#import "ServiceBaseModel.h"
#import "RDAlertView.h"

@interface RDBaseLogicModel () {
    RKObjectManager *_objectManager;
}

@end

@implementation RDBaseLogicModel

- (id)init {
    self = [super init];
    if (self) {
        _objectManager = [RKObjectManager sharedManager];
        [self doMapping];
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)doMapping {
    SHOULDOVERRIDE_M(@"RDBaseLogicModel:doMapping", NSStringFromClass([self class]), @"子类必须重写此方法");
}

- (RKObjectManager *)getSharedObjectManager {
    return _objectManager;
}

- (ServiceBaseModel*)serviceBaseModelFromMappingResult:(RKMappingResult *)mappingResult {
    ServiceBaseModel *serviceModel = [mappingResult firstObject];
    if ([serviceModel isKindOfClass:[ServiceBaseModel class]]) {
        return serviceModel;
    }
    else {
        for (id object in [mappingResult array]) {
            if ([object isKindOfClass:[ServiceBaseModel class]]) {
                return object;                
            }
        }
    }
    return nil;
}

- (void)doCallGetService:(NSString *)keyPath
              parameters:(NSDictionary *)parameters
                 success:(SuccessCompletionBlock)successBlock
                 failure:(FailureCompletionBlock)failureBlock {
    
    
    if (!DATA_ENV.networkAvailable) {
        if (_noNetworkFailureBlock) {
            _noNetworkFailureBlock();
        }
        return;
    }
    if (DATA_ENV.networkAvailable) {
        if (_removeNetworkFailureViewBlock) {
            _removeNetworkFailureViewBlock();
        }
    }
    
    [_objectManager getObject:nil path:keyPath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
       // Handle common access
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ServiceBaseModel *serviceModel = [self serviceBaseModelFromMappingResult:mappingResult];
            if (![serviceModel isSuccess]) {
                //serviceModel.message
               // [[iToast makeText:[RDUtils localizableString:@"rd_server_error_message"]] show];
            }
            [_baseVC hideLoading];
            successBlock(operation, mappingResult);
        });
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Handle common error
        RKErrorMessage *errorMessage = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            ITTDINFO(@"--- %@", errorMessage);
            [_baseVC hideLoading];
            if (!errorMessage) {
//                [[iToast makeText:[error localizedDescription]] show];
                //网络原因和系统原因
   //             [self showAlertView:[RDUtils localizableString:@"rd_server_error_message2"]];
            }
            else {
                //[[iToast makeText:errorMessage.errorMessage] show];
            }
            failureBlock(operation, error);
          
        });
    }];
}

- (void)doCallPostService:(NSString *)keyPath
               parameters:(NSDictionary *)parameters
                  success:(SuccessCompletionBlock)successBlock
                  failure:(FailureCompletionBlock)failureBlock {
    
    if (!DATA_ENV.networkAvailable) {
        if (_noNetworkFailureBlock) {
            _noNetworkFailureBlock();
        }
        return;
    }
    if (DATA_ENV.networkAvailable) {
        if (_removeNetworkFailureViewBlock) {
            _removeNetworkFailureViewBlock();
        }
    }

    
    [_objectManager postObject:nil path:keyPath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // Handle common access
        dispatch_async(dispatch_get_main_queue(), ^{
            ServiceBaseModel *serviceModel = [self serviceBaseModelFromMappingResult:mappingResult];
            if (![serviceModel isSuccess]) {
                //[[iToast makeText:serviceModel.message] show];
                //[self showAlertView:[RDUtils localizableString:@"rd_server_error_message"]];
            }
           
            successBlock(operation, mappingResult);
        });

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
       
        // Handle common error
        RKErrorMessage *errorMessage =  [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!errorMessage) {
//                [[iToast makeText:[error localizedDescription]] show];
//                [self showAlertView:[RDUtils localizableString:@"rd_server_error_message2"]];
            }
            else {
                //[[iToast makeText:errorMessage.errorMessage] show];
            }
            failureBlock(operation, error);
        });
    }];
}
- (void)doCallPostService:(NSString *)keyPath Url:(NSString *)url parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFRKMultipartFormData> formData))block success:(SuccessCompletionBlock)successBlock failure:(FailureCompletionBlock)failureBlock{
    RKObjectManager  *objectManager  = [RKObjectManager sharedManager];
    
    NSMutableURLRequest *request = [objectManager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:keyPath parameters:parameters constructingBodyWithBlock:block];
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request success:successBlock failure:failureBlock];
    [operation setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    [objectManager enqueueObjectRequestOperation:operation];
}

//根据AFHTTPRequestOperationManager 修改
- (void)doCallPostService:(NSString *)keyPath parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFRKMultipartFormData> formData))block success:(SuccessCompletionBlock)successBlock failure:(FailureCompletionBlock)failureBlock
{
    //创建新的objectManager对象
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SERVICE_OBS_URL]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ServiceBaseModel class]];
    [errorMapping addAttributeMappingsFromDictionary:@{
                                                       @"code" : @"code",
                                                       @"cost" : @"cost",
                                                       @"msg" : @"message",
                                                       @"data" : @"data"
                                                       }];
    
    RKResponseDescriptor *errorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@""
                                            statusCodes:statusCodes];
     [objectManager addResponseDescriptor:errorDescriptor];
    //AFRKMultipartFormData  --  AFMultipartFormData
    NSMutableURLRequest *request = [objectManager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:keyPath parameters:parameters constructingBodyWithBlock:block];
    RKObjectRequestOperation *operation = [objectManager objectRequestOperationWithRequest:request success:successBlock failure:failureBlock];
    [operation setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    [objectManager enqueueObjectRequestOperation:operation];
}


- (void)showAlertView:(NSString *)message {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSInteger alertTag = 1120;
    RDAlertView *alertView = (RDAlertView *)[keyWindow viewWithTag:alertTag];
    if (!alertView) {
        alertView = [RDAlertView loadFromXib];
        alertView.messageLabel.text = message;
        alertView.tag = alertTag;
        [alertView showInView:keyWindow disappearDelay:2.0 hiddenCancelButton:TRUE];
    }
}

- (void)showMakePlanError
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSInteger alertTag = 1150;
    RDAlertView *alertView = (RDAlertView *)[keyWindow viewWithTag:alertTag];
    if (!alertView) {
        alertView = [RDAlertView loadFromXib];
        alertView.messageLabel.text = [RDUtils localizableString:@"rd_server_error_message"];
        alertView.tag = alertTag;
        [alertView showInView:keyWindow];
        
    }
    
}
- (void)showMakePlanError:(NSString *)message
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSInteger alertTag = 1150;
    RDAlertView *alertView = (RDAlertView *)[keyWindow viewWithTag:alertTag];
    if (!alertView) {
        alertView = [RDAlertView loadFromXib];
        if (message) {
            alertView.messageLabel.text = message;
        }else{
            alertView.messageLabel.text = [RDUtils localizableString:@"rd_server_error_message"];
        }
        
        alertView.tag = alertTag;
        [alertView showInView:keyWindow];
        
    }
    
}

//- (void)showMakePlanMessage:(NSString *)message cancleTitle:(NSString *)cancle commitTitle:(NSString *)commit

- (void)alertShowWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    [alertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
        
    });
    
}

#pragma mark - Private Methods
- (NSString *)getServiceURLByKeyPath:(NSString *)keyPath withParameters:(NSDictionary *)paras {
    NSMutableString *mutStr = [keyPath mutableCopy];
    
    BOOL isFirstOne = YES;
    for (NSString *key in paras) {
        NSString *value = paras[key];
        if (isFirstOne) {
            [mutStr appendString:[NSString stringWithFormat:@"?%@=%@", key, value]];
            isFirstOne = NO;
        } else {
            [mutStr appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
    }
    
    return [NSString stringWithFormat:@"%@", mutStr];
}

@end
