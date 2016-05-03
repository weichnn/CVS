//
//  NSString+StdString.h
//  OpenCV Tutorial
//
//  Created by BloodAxe on 7/9/12.
//  Copyright (c) 2012 computer-vision-talks.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StdString)

+ (NSString*) stringWithStdString: (const std::string&) str;

//- (std::string) toStdString;

@end
