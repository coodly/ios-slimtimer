// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Tag;
@class SyncStatus;
@class TimeEntry;
@class User;

@interface TaskID : NSManagedObjectID {}
@end

@interface _Task : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TaskID*objectID;

@property (nonatomic, strong) NSNumber* complete;

@property (atomic) BOOL completeValue;
- (BOOL)completeValue;
- (void)setCompleteValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* hidden;

@property (atomic) BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* taskId;

@property (atomic) int32_t taskIdValue;
- (int32_t)taskIdValue;
- (void)setTaskIdValue:(int32_t)value_;

@property (nonatomic, strong) NSNumber* temporary;

@property (atomic) BOOL temporaryValue;
- (BOOL)temporaryValue;
- (void)setTemporaryValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSDate* touchedAt;

@property (nonatomic, strong, nullable) NSSet<Tag*> *defaultTags;
- (nullable NSMutableSet<Tag*>*)defaultTagsSet;

@property (nonatomic, strong, nullable) SyncStatus *syncStatus;

@property (nonatomic, strong, nullable) NSSet<TimeEntry*> *timeEntry;
- (nullable NSMutableSet<TimeEntry*>*)timeEntrySet;

@property (nonatomic, strong, nullable) User *user;

@end

@interface _Task (DefaultTagsCoreDataGeneratedAccessors)
- (void)addDefaultTags:(NSSet<Tag*>*)value_;
- (void)removeDefaultTags:(NSSet<Tag*>*)value_;
- (void)addDefaultTagsObject:(Tag*)value_;
- (void)removeDefaultTagsObject:(Tag*)value_;

@end

@interface _Task (TimeEntryCoreDataGeneratedAccessors)
- (void)addTimeEntry:(NSSet<TimeEntry*>*)value_;
- (void)removeTimeEntry:(NSSet<TimeEntry*>*)value_;
- (void)addTimeEntryObject:(TimeEntry*)value_;
- (void)removeTimeEntryObject:(TimeEntry*)value_;

@end

@interface _Task (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveComplete;
- (void)setPrimitiveComplete:(NSNumber*)value;

- (BOOL)primitiveCompleteValue;
- (void)setPrimitiveCompleteValue:(BOOL)value_;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveTaskId;
- (void)setPrimitiveTaskId:(NSNumber*)value;

- (int32_t)primitiveTaskIdValue;
- (void)setPrimitiveTaskIdValue:(int32_t)value_;

- (NSNumber*)primitiveTemporary;
- (void)setPrimitiveTemporary:(NSNumber*)value;

- (BOOL)primitiveTemporaryValue;
- (void)setPrimitiveTemporaryValue:(BOOL)value_;

- (NSDate*)primitiveTouchedAt;
- (void)setPrimitiveTouchedAt:(NSDate*)value;

- (NSMutableSet<Tag*>*)primitiveDefaultTags;
- (void)setPrimitiveDefaultTags:(NSMutableSet<Tag*>*)value;

- (SyncStatus*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(SyncStatus*)value;

- (NSMutableSet<TimeEntry*>*)primitiveTimeEntry;
- (void)setPrimitiveTimeEntry:(NSMutableSet<TimeEntry*>*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

@interface TaskAttributes: NSObject 
+ (NSString *)complete;
+ (NSString *)hidden;
+ (NSString *)name;
+ (NSString *)taskId;
+ (NSString *)temporary;
+ (NSString *)touchedAt;
@end

@interface TaskRelationships: NSObject
+ (NSString *)defaultTags;
+ (NSString *)syncStatus;
+ (NSString *)timeEntry;
+ (NSString *)user;
@end

NS_ASSUME_NONNULL_END
