// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Year.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Month;
@class User;

@interface YearID : NSManagedObjectID {}
@end

@interface _Year : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) YearID*objectID;

@property (nonatomic, strong, nullable) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSSet<Month*> *months;
- (nullable NSMutableSet<Month*>*)monthsSet;

@property (nonatomic, strong, nullable) User *user;

@end

@interface _Year (MonthsCoreDataGeneratedAccessors)
- (void)addMonths:(NSSet<Month*>*)value_;
- (void)removeMonths:(NSSet<Month*>*)value_;
- (void)addMonthsObject:(Month*)value_;
- (void)removeMonthsObject:(Month*)value_;

@end

@interface _Year (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

- (NSMutableSet<Month*>*)primitiveMonths;
- (void)setPrimitiveMonths:(NSMutableSet<Month*>*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

@interface YearAttributes: NSObject 
+ (NSString *)value;
@end

@interface YearRelationships: NSObject
+ (NSString *)months;
+ (NSString *)user;
@end

NS_ASSUME_NONNULL_END
