// In Xcode, add -DDEBUG=1 to:
// Edit Project Settings >> GCC 4.0 - Language >> Other C Flags

#ifdef DEBUG

    // DLog(): Prints location and whatever value(s) passed to it
    #define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])

#else

    #define DLog(...) do { } while (0)
    #ifndef NS_BLOCK_ASSERTIONS
        #define NS_BLOCK_ASSERTIONS
    #endif

#endif
