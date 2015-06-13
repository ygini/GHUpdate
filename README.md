# GHUpdate
This framework is made to manage update process of OS X application via Github release API.

Feel free to contribute!

#Limitations

At this time it only support release, not prerelease.

At this time, the system show a NSAlert when an update is available and offer the user to open the Github release web page. No automatic installation supported at this time.

# Sample code

## Requierements

You must add two keys in your Info.plist: GHUpdateOwner and GHUpdateRepos with your github name as owner your project name on github.

## Simple testing

```
[GHUpdater checkAndUpdate];
```

This will get info from [[NSBundle mainBundle] infoDictionary]. The CFBundleShortVersionString will be compared to release tag (leading 'v' char will be striped).

## Advanced testing

```
NSDictionary *infos = [[NSBundle bundleWithIdentifier:@"com.example.bundleid"] infoDictionary];
[GHUpdater checkAndUpdateWithBundleInfo:infos];

```

Your info must have GHUpdateOwner, GHUpdateRepos and CFBundleShortVersionString keys.

The CFBundleShortVersionString will be compared to release tag (leading 'v' char will be striped).

This scenario is useful when you want to provide update mechanism to bundle like prefpane.
