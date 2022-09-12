#  File storage like dictionary, with caching to disk

# Usage
1. Add project
2. Make dependencies
3. Embedd binary
4. Use code like this:
```
@import FileStorage;
FileStorage *fileStorage = [[FileStorage alloc] initWithStorageName:storageName];
fileStorage[key] = value;
value = fileStorage[key];
```
