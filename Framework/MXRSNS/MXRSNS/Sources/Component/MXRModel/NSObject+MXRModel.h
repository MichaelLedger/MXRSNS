//
//  NSObject+MXRModel.h
//  MTNLibrary
//
//  Created by Martin.Liu on 16/11/29.
//  Copyright © 2016年 MAR. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MXRModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self mxr_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self mxr_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self mxr_modelCopy]; } \
- (NSUInteger)hash { return [self mxr_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self mxr_modelIsEqual:object]; }

#define YYModelSynthCoderAndHash MXRModelSynthCoderAndHash

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some data-model method:
 
 * Convert json to any object, or convert any object to json.
 * Set object properties with a key-value dictionary (like KVC).
 * Implementations of `NSCoding`, `NSCopying`, `-hash` and `-isEqual:`.
 
 See `MXRModel` protocol for custom methods.
 
 
 Sample Code:
 
 ********************** json convertor *********************
 @interface MXRAuthor : NSObject
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, assign) NSDate *birthday;
 @end
 @implementation MXRAuthor
 @end
 
 @interface MXRBook : NSObject
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, assign) NSUInteger pages;
 @property (nonatomic, strong) MXRAuthor *author;
 @end
 @implementation MXRBook
 @end
 
 int main() {
 // create model from json
 MXRBook *book = [MXRBook modelWithJSON:@"{\"name\": \"Harry Potter\", \"pages\": 256, \"author\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" }}"];
 
 // convert model to json
 NSString *json = [book modelToJSONString];
 // {"author":{"name":"J.K.Rowling","birthday":"1965-07-31T00:00:00+0000"},"name":"Harry Potter","pages":256}
 }
 
 ********************** Coding/Copying/hash/equal *********************
 @interface MXRShadow :NSObject <NSCoding, NSCopying>
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, assign) CGSize size;
 @end
 
 @implementation MXRShadow
 - (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
 - (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
 - (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
 - (NSUInteger)hash { return [self modelHash]; }
 - (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
 @end
 
 */
@interface NSObject (MXRModel)

+ (NSDictionary *)mxr_dictionaryWithJSON:(id)json;

/**
 Creates and returns a new instance of the receiver from a json.
 This method is thread-safe.
 
 @param json  A json object in `NSDictionary`, `NSString` or `NSData`.
 
 @return A new instance created from the json, or nil if an error occurs.
 */
+ (nullable instancetype)mxr_modelWithJSON:(id)json;

/**
 Creates and returns a new instance of the receiver from a key-value dictionary.
 This method is thread-safe.
 
 @param dictionary  A key-value dictionary mapped to the instance's properties.
 Any invalid key-value pair in dictionary will be ignored.
 
 @return A new instance created from the dictionary, or nil if an error occurs.
 
 @discussion The key in `dictionary` will mapped to the reciever's property name,
 and the value will set to the property. If the value's type does not match the
 property, this method will try to convert the value based on these rules:
 
 `NSString` or `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
 `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
 `NSString` -> NSURL.
 `NSValue` -> struct or union, such as CGRect, CGSize, ...
 `NSString` -> SEL, Class.
 */
+ (nullable instancetype)mxr_modelWithDictionary:(NSDictionary *)dictionary;

/**
 Set the receiver's properties with a json object.
 
 @discussion Any invalid data in json will be ignored.
 
 @param json  A json object of `NSDictionary`, `NSString` or `NSData`, mapped to the
 receiver's properties.
 
 @return Whether succeed.
 */
- (BOOL)mxr_modelSetWithJSON:(id)json;

/**
 Set the receiver's properties with a key-value dictionary.
 
 @param dic  A key-value dictionary mapped to the receiver's properties.
 Any invalid key-value pair in dictionary will be ignored.
 
 @discussion The key in `dictionary` will mapped to the reciever's property name,
 and the value will set to the property. If the value's type doesn't match the
 property, this method will try to convert the value based on these rules:
 
 `NSString`, `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
 `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
 `NSString` -> NSURL.
 `NSValue` -> struct or union, such as CGRect, CGSize, ...
 `NSString` -> SEL, Class.
 
 @return Whether succeed.
 */
- (BOOL)mxr_modelSetWithDictionary:(NSDictionary *)dic;

/**
 Generate a json object from the receiver's properties.
 
 @return A json object in `NSDictionary` or `NSArray`, or nil if an error occurs.
 See [NSJSONSerialization isValidJSONObject] for more information.
 
 @discussion Any of the invalid property is ignored.
 If the reciver is `NSArray`, `NSDictionary` or `NSSet`, it just convert
 the inner object to json object.
 */
- (nullable id)mxr_modelToJSONObject;

/**
 Generate a json string's data from the receiver's properties.
 
 @return A json string's data, or nil if an error occurs.
 
 @discussion Any of the invalid property is ignored.
 If the reciver is `NSArray`, `NSDictionary` or `NSSet`, it will also convert the
 inner object to json string.
 */
- (nullable NSData *)mxr_modelToJSONData;

/**
 Generate a json string from the receiver's properties.
 
 @return A json string, or nil if an error occurs.
 
 @discussion Any of the invalid property is ignored.
 If the reciver is `NSArray`, `NSDictionary` or `NSSet`, it will also convert the
 inner object to json string.
 */
- (nullable NSString *)mxr_modelToJSONString;

/**
 Copy a instance with the receiver's properties.
 
 @return A copied instance, or nil if an error occurs.
 */
- (nullable id)mxr_modelCopy;

/**
 Encode the receiver's properties to a coder.
 
 @param aCoder  An archiver object.
 */
- (void)mxr_modelEncodeWithCoder:(NSCoder *)aCoder;

/**
 Decode the receiver's properties from a decoder.
 
 @param aDecoder  An archiver object.
 
 @return self
 */
- (id)mxr_modelInitWithCoder:(NSCoder *)aDecoder;

// 排除不需要的encode字端
+(NSArray*)mxr_exceptEncodeKeys;

/**
 Get a hash code with the receiver's properties.
 
 @return Hash code.
 */
- (NSUInteger)mxr_modelHash;

/**
 Compares the receiver with another object for equality, based on properties.
 
 @param model  Another object.
 
 @return `YES` if the reciever is equal to the object, otherwise `NO`.
 */
- (BOOL)mxr_modelIsEqual:(id)model;

/**
 Description method for debugging purposes based on properties.
 
 @return A string that describes the contents of the receiver.
 */
- (NSString *)mxr_modelDescription;

@end



/**
 Provide some data-model method for NSArray.
 */
@interface NSArray (MXRModel)

/**
 Creates and returns an array from a json-array.
 This method is thread-safe.
 
 @param cls  The instance's class in array.
 @param json  A json array of `NSArray`, `NSString` or `NSData`.
 Example: [{"name","Mary"},{name:"Joe"}]
 
 @return A array, or nil if an error occurs.
 */
+ (nullable NSArray *)mxr_modelArrayWithClass:(Class)cls json:(id)json;

@end



/**
 Provide some data-model method for NSDictionary.
 */
@interface NSDictionary (MXRModel)

/**
 Creates and returns a dictionary from a json.
 This method is thread-safe.
 
 @param cls  The value instance's class in dictionary.
 @param json  A json dictionary of `NSDictionary`, `NSString` or `NSData`.
 Example: {"user1":{"name","Mary"}, "user2": {name:"Joe"}}
 
 @return A dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)mxr_modelDictionaryWithClass:(Class)cls json:(id)json;
@end



/**
 If the default model transform does not fit to your model class, implement one or
 more method in this protocol to change the default key-value transform process.
 There's no need to add '<MXRModelDelegate>' to your class header.
 */
@protocol MXRModelDelegate <NSObject>
@optional

/**
 Custom property mapper.
 
 @discussion If the key in JSON/Dictionary does not match to the model's property name,
 implements this method and returns the additional mapper.
 
 Example:
 
 json:
 {
 "n":"Harry Pottery",
 "p": 256,
 "ext" : {
 "desc" : "A book written by J.K.Rowling."
 },
 "ID" : 100010
 }
 
 model:
 @interface MXRBook : NSObject
 @property NSString *name;
 @property NSInteger page;
 @property NSString *desc;
 @property NSString *bookID;
 @end
 
 @implementation MXRBook
 + (NSDictionary *)mxr_modelCustomPropertyMapper {
 return @{@"name"  : @"n",
 @"page"  : @"p",
 @"desc"  : @"ext.desc",
 @"bookID": @[@"id", @"ID", @"book_id"]};
 }
 @end
 
 @return A custom mapper for properties.
 */
+ (nullable NSDictionary<NSString *, id> *)mxr_modelCustomPropertyMapper;

/**
 The generic class mapper for container properties.
 
 @discussion If the property is a container object, such as NSArray/NSSet/NSDictionary,
 implements this method and returns a property->class mapper, tells which kind of
 object will be add to the array/set/dictionary.
 
 Example:
 @class MXRShadow, MXRBorder, MXRAttachment;
 
 @interface MXRAttributes
 @property NSString *name;
 @property NSArray *shadows;
 @property NSSet *borders;
 @property NSDictionary *attachments;
 @end
 
 @implementation MXRAttributes
 + (NSDictionary *)mxr_modelContainerPropertyGenericClass {
 return @{@"shadows" : [MXRShadow class],
 @"borders" : MXRBorder.class,
 @"attachments" : @"MXRAttachment" };
 }
 @end
 
 @return A class mapper.
 */
+ (nullable NSDictionary<NSString *, id> *)mxr_modelContainerPropertyGenericClass;

/**
 If you need to create instances of different classes during json->object transform,
 use the method to choose custom class based on dictionary data.
 
 @discussion If the model implements this method, it will be called to determine resulting class
 during `+modelWithJSON:`, `+modelWithDictionary:`, conveting object of properties of parent objects
 (both singular and containers via `+mxr_modelContainerPropertyGenericClass`).
 
 Example:
 @class MXRCircle, MXRRectangle, MXRLine;
 
 @implementation MXRShape
 
 + (Class)mxr_modelCustomClassForDictionary:(NSDictionary*)dictionary {
 if (dictionary[@"radius"] != nil) {
 return [MXRCircle class];
 } else if (dictionary[@"width"] != nil) {
 return [MXRRectangle class];
 } else if (dictionary[@"y2"] != nil) {
 return [MXRLine class];
 } else {
 return [self class];
 }
 }
 
 @end
 
 @param dictionary The json/kv dictionary.
 
 @return Class to create from this dictionary, `nil` to use current class.
 
 */
+ (nullable Class)mxr_modelCustomClassForDictionary:(NSDictionary *)dictionary;

/**
 All the properties in blacklist will be ignored in model transform process.
 Returns nil to ignore this feature.
 
 @return An array of property's name.
 */
+ (nullable NSArray<NSString *> *)mxr_modelPropertyBlacklist;

/**
 If a property is not in the whitelist, it will be ignored in model transform process.
 Returns nil to ignore this feature.
 
 @return An array of property's name.
 */
+ (nullable NSArray<NSString *> *)mxr_modelPropertyWhitelist;

/**
 This method's behavior is similar to `- (BOOL)mxr_modelCustomTransformFromDictionary:(NSDictionary *)dic;`,
 but be called before the model transform.
 
 @discussion If the model implements this method, it will be called before
 `+modelWithJSON:`, `+modelWithDictionary:`, `-modelSetWithJSON:` and `-modelSetWithDictionary:`.
 If this method returns nil, the transform process will ignore this model.
 
 @param dic  The json/kv dictionary.
 
 @return Returns the modified dictionary, or nil to ignore this model.
 */
- (NSDictionary *)mxr_modelCustomWillTransformFromDictionary:(NSDictionary *)dic;

/**
 If the default json-to-model transform does not fit to your model object, implement
 this method to do additional process. You can also use this method to validate the
 model's properties.
 
 @discussion If the model implements this method, it will be called at the end of
 `+modelWithJSON:`, `+modelWithDictionary:`, `-modelSetWithJSON:` and `-modelSetWithDictionary:`.
 If this method returns NO, the transform process will ignore this model.
 
 @param dic  The json/kv dictionary.
 
 @return Returns YES if the model is valid, or NO to ignore this model.
 */
- (BOOL)mxr_modelCustomTransformFromDictionary:(NSDictionary *)dic;

/**
 If the default model-to-json transform does not fit to your model class, implement
 this method to do additional process. You can also use this method to validate the
 json dictionary.
 
 @discussion If the model implements this method, it will be called at the end of
 `-modelToJSONObject` and `-modelToJSONString`.
 If this method returns NO, the transform process will ignore this json dictionary.
 
 @param dic  The json dictionary.
 
 @return Returns YES if the model is valid, or NO to ignore this model.
 */
- (BOOL)mxr_modelCustomTransformToDictionary:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
