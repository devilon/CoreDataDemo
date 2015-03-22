//
//  ViewController.m
//  CoreData
//
//  Created by tony on 15/3/22.
//  Copyright (c) 2015年 tony. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface ViewController ()
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContext];
    
}

#pragma mark - 设置上下文的方法
- (void)setupContext {
    
    // 1. 上下文 关联Company.xcdatamodeld 模型文件
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    // 2. 关联模型文件
    // 2.1 创建一个模型对象 (传一个nil 会把 bundle下的所有模型文件 关联起来)
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 3. 持久化存储调度器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 4. 获取docment目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 5. 数据库保存的路径
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
    
    // fileURLWithPath:本地路径用。
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    
    context.persistentStoreCoordinator = store;
    
    _context = context;
}

#pragma mark 添加员工信息
- (IBAction)addEmployee {
    Employee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
    
    emp.name = @"tom";
    emp.age = @25;
    emp.height = @1.73;
    
    [_context save:nil];
}
#pragma mark 读取员工信息
- (IBAction)readEmployee {
    // 1. 分页查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    request.fetchLimit = 5;
    request.fetchOffset = 0;
    
    // 2. 读取信息
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    for (Employee *emp in emps) {
        NSLog(@"%@---%@----%@", emp.name, emp.age, emp.height);
    }
}
#pragma mark 删除员工
- (IBAction)deleteEmployee {
    [self deleteEmployeeWithName:@"tom"];
}

- (void)deleteEmployeeWithName:(NSString *)name {
    /*
    // 1.查找
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@", name];
    request.predicate = pre;
    
    // 2.删除
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    for (Employee *emp in emps) {
        NSLog(@"删除了员工 %@", emp.name);
        [_context deleteObject:emp];
    }
    */
    
    // 1.查找
    NSArray *emps = [self findEmployeeWithName:@"tom"];
    
    // 2.删除
    for (Employee *emp in emps) {
        NSLog(@"删除了员工 %@", emp.name);
        [_context deleteObject:emp];
    }
    
    // 3.用context同步数据库
    [_context save:nil];
}

#pragma mark 更新员工信息
- (IBAction)updateEmployee {
    NSArray *emps = [self findEmployeeWithName:@"tom"];
    
    if (emps.count == 1) {
        Employee *emp = emps[0];
        emp.height = @1.85;
    }
    
    [_context save:nil];
}

- (NSArray *)findEmployeeWithName:(NSString *)name {
    // 1. 查找
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@", name];
    request.predicate = pre;
    
    // 2. 返回数组
    return [_context executeFetchRequest:request error:nil];
}

#pragma mark 模糊查询
- (IBAction)likeSearch {
    // 1. 名字包含查找
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"O"];
    request.predicate = pre;
    
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    for (Employee *emp in emps) {
        NSLog(@"%@---%@----%@", emp.name, emp.age, emp.height);
    }
}

@end
