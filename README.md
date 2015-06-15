# GHUpdate

This framework helps to manage update process of OS X applications via the GitHub release API.

## Limitations

At this time GHUpdate only supports releases, not prereleases.

At this time, the system shows an NSAlert when an update is available and offers the user to open the GitHub release web page. No automatic installation supported yet.

## Sample code

### Requirements

You must add two keys into your Info.plist: `GHUpdateOwner` (your GitHub username) and `GHUpdateRepos` (your project's name on GitHub).

### Simple testing

```
[GHUpdater checkAndUpdate];
```

This will get info from `[[NSBundle mainBundle] infoDictionary]`. The `CFBundleShortVersionString` will be compared to release tag (leading 'v' char will be stripped).

### Advanced testing

```
NSDictionary *infos = [[NSBundle bundleWithIdentifier:@"com.example.bundleid"] infoDictionary];
[GHUpdater checkAndUpdateWithBundleInfo:infos];

```

Your info must have `GHUpdateOwner`, `GHUpdateRepos` and `CFBundleShortVersionString` keys.

The `CFBundleShortVersionString` will be compared to the release tag (leading 'v' char will be stripped).

This scenario is useful when you want to provide a mechanism for updating bundles like prefpanes.

## Contribution

Feel free to contribute!

But please, avoid as much as possible adding ressources like xib, image, alternate binaries, etc. This will add too much complexity with bundle-based scenarios.
