1.0 -   2016/02/02 @levigroker - Initial release  
2.0 -   2016/05/03 @levigroker - Adding Google Analytics provider and removing weak linking.  
3.0 -   2017/01/03 @levigroker - Removing much of the CocoaPod magic in favor of manual
        install due to static library incompatibilities with the `use_frameworks!`
        directive.  
3.0.1 - 2017/01/03 @levigroker - Addressing documentation warnings. Updating licensing.  
3.1 -   2017/10/10 @levigroker - Adding Firebase provider, delegate capabilities, and some refactoring.  
3.1.1 - 2018/03/01 @levigroker - Addressing NSNumber as BOOL issues.  
3.1.2 - 2018/04/09 @jpetrich - Fixed `substringToIndex:` bug in `GRKFirebaseProvider` 
        that cut off last character of strings for user properties. @levigroker - Added
        new test case for said issue.  
3.2   - 2018/04/19 @levigroker - Adding user identification flag to enable/disable the
		`identifyUserWithID:andEmailAddress:` method from sending user-identifiable
		information to the individual providers. This flag **disables** the
		`identifyUserWithID:andEmailAddress:` method by default. Previous users of this
		framework should be aware this will break user identification if not explicitly
		enabled. This change is inspired by the
		[GDPR legislation](https://techblog.bozho.net/gdpr-practical-guide-developers/).
		Anyone considering enabling this feature must get the user’s *explicit* consent.
4.0  -  2018/05/15 @levigroker - Fixing import for Firebase 5.0. Updating
		copyright/license. Updating deployment targets to iOS 9, macOS 10.12.
4.1 -   2019/03/21 @levigroker - Adding Microsoft App Center Analytics provider.