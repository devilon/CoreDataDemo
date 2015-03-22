//
//  Employee.h
//  CoreData
//
//  Created by tony on 15/3/22.
//  Copyright (c) 2015年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * height;

@end
