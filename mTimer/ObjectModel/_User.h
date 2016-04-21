// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Tag;
@class Task;
@class Year;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID*objectID;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSSet<Tag*> *tags;
- (nullable NSMutableSet<Tag*>*)tagsSet;

@property (nonatomic, strong, nullable) NSSet<Task*> *tasks;
- (nullable NSMutableSet<Task*>*)tasksSet;

@property (nonatomic, strong, nullable) NSSet<Year*> *years;
- (nullable NSMutableSet<Year*>*)yearsSet;

@end

@interface _User (TagsCoreDataGeneratedAccessors)
- (void)addTags:(NSSet<Tag*>*)value_;
- (void)removeTags:(NSSet<Tag*>*)value_;
- (void)addTagsObject:(Tag*)value_;
- (void)removeTagsObject:(Tag*)value_;

@end

@interface _User (TasksCoreDataGeneratedAccessors)
- (void)addTasks:(NSSet<Task*>*)value_;
- (void)removeTasks:(NSSet<Task*>*)value_;
- (void)addTasksObject:(Task*)value_;
- (void)removeTasksObject:(Task*)value_;

@end

@interface _User (YearsCoreDataGeneratedAccessors)
- (void)addYears:(NSSet<Year*>*)value_;
- (void)removeYears:(NSSet<Year*>*)value_;
- (void)addYearsObject:(Year*)value_;
- (void)removeYearsObject:(Year*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;

- (NSMutableSet<Tag*>*)primitiveTags;
- (void)setPrimitiveTags:(NSMutableSet<Tag*>*)value;

- (NSMutableSet<Task*>*)primitiveTasks;
- (void)setPrimitiveTasks:(NSMutableSet<Task*>*)value;

- (NSMutableSet<Year*>*)primitiveYears;
- (void)setPrimitiveYears:(NSMutableSet<Year*>*)value;

@end

@interface UserAttributes: NSObject 
+ (NSString *)userId;
@end

@interface UserRelationships: NSObject
+ (NSString *)tags;
+ (NSString *)tasks;
+ (NSString *)years;
@end

NS_ASSUME_NONNULL_END
