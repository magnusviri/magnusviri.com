---
layout:     default
title:      AutoPkg notes
date:       2021-12-02
editdate:   2021-12-02
categories:
disqus_id:  autopkg-notes.html
---

These are my [AutoPkg](https://github.com/autopkg/autopkg/) notes.

- [My autopkg recipes](https://github.com/magnusviri/magnusviri-recipes)

## Mass Verify

	autopkg verify-trust-info -v $(<AutoPkgr/All.txt)

## Getting png files from icns files:

	sips -s format png "path/to/file.icns" --out "path/to/file.png"

## Yaml formatted plists

- [Yaml formatted plists](https://grahamrpugh.com/2021/03/02/autopkg-native-yaml-recipes.html)
- [file extension requirement for YAML-formatted recipes](https://github.com/autopkg/autopkg/issues/767)
- [AutoPkgr issue 667](https://github.com/lindegroup/autopkgr/issues/667)
- [AutoPkgr issue 672](https://github.com/lindegroup/autopkgr/issues/672)

Convert plist to yaml

	find .. -name "*.recipe" -exec ./[plistyamlplist.py](https://github.com/grahampugh/plist-yaml-plist) \{\} \{\} \;

## AutoPkg in the cloud notes

I really want to do this.

- [JNUC 2021 video](https://www.youtube.com/watch?v=0CoXfhHqdEY)
- [MSA 2021 video](https://www.macsysadmin.se/video/day1session3.mp4)
- [MSA 2021 Slides](https://drive.google.com/file/d/1L-MPtE1KtC2jGUaU7332nfZMABuuQX-a/edit)

## Download Recipe Patterns

### Specify the Recipe dir path

Say you just want to put the item in the Recipe directory.

	<string>%RECIPE_DIR%</string>

### Just specify a URL

	<dict>
		<key>Arguments</key>
		<dict>
			<key>filename</key>
			<string>%NAME%.dmg</string>
			<key>url</key>
			<string>%DOWNLOAD_URL%</string>
		</dict>
		<key>Processor</key>
		<string>URLDownloader</string>
	</dict>

### Search a webpage for text

	<dict>
		<key>Arguments</key>
		<dict>
			<key>url</key>
			<string>%URL%</string>
			<key>re_pattern</key>
			<string>a href="(?P&lt;path&gt;.*zip)".MacOS</string>
		</dict>
		<key>Processor</key>
		<string>URLTextSearcher</string>
	</dict>

### Ignore self signed certs (curl -k)

	<dict>
		<key>Arguments</key>
		<dict>
			<key>curl_opts</key>
			<array>
				<string>-k</string>
			</array>
		</dict>
		<key>Processor</key>
		<string>URLTextSearcher</string>
	</dict>

### Download from Github

		<dict>
			<key>Arguments</key>
			<dict>
				<key>asset_regex</key>
				<string>.*dmg</string>
				<key>github_repo</key>
				<string>name/repo</string>
			</dict>
			<key>Processor</key>
			<string>GitHubReleasesInfoProvider</string>
		</dict>
		<dict>
			<key>Arguments</key>
			<dict>
				<key>filename</key>
				<string>%NAME%-%version%.dmg</string>
			</dict>
			<key>Processor</key>
			<string>URLDownloader</string>
		</dict>

### Download from Sparkle

	<key>Input</key>
	<dict>
		<key>SPARKLE_FEED_URL</key>
		<string>https://1234-567890.ssl.cf1.rackcdn.com/something_appcast.xml</string>
	</dict>
	<key>Process</key>
	<array>
		<dict>
			<key>Arguments</key>
			<dict>
				<key>appcast_url</key>
				<string>%SPARKLE_FEED_URL%</string>
			</dict>
			<key>Processor</key>
			<string>SparkleUpdateInfoProvider</string>
		</dict>
		<dict>
			<key>Arguments</key>
			<dict>
				<key>filename</key>
				<string>%NAME%-%version%.dmg</string>
			</dict>
			<key>Processor</key>
			<string>URLDownloader</string>
		</dict>

Get the appcast_url:

	grep -A1 SUFeedURL /Applications/Name.app/Contents/Info.plist

### [EndOfCheckPhase](https://github.com/autopkg/autopkg/wiki/Processor-EndOfCheckPhase)

This "serves as a marker to signal where AutoPkg should stop when the -c/--check options are used."

		<dict>
			<key>Processor</key>
			<string>EndOfCheckPhase</string>
		</dict>

### Verify signature

		<dict>
			<key>Arguments</key>
			<dict>
				<key>input_path</key>
				<string>%RECIPE_CACHE_DIR%/downloads/%NAME%-%version%.dmg/*.app</string>
				<key>requirement</key>
				<string>identifier some-name and anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.6] /* exists */ and certificate leaf[field.1.2.840.113635.100.6.1.13] /* exists */ and certificate leaf[subject.OU] = "ASDFASDF"</string>
			</dict>
			<key>Processor</key>
			<string>CodeSignatureVerifier</string>
		</dict>

Get the [signature](https://github.com/autopkg/autopkg/wiki/Using-CodeSignatureVerification)

```
codesign -d -r- /Applications/iTerm.app/Contents/MacOS/iTerm2
Executable=/Applications/iTerm.app/Contents/MacOS/iTerm2
designated => anchor apple generic and identifier "com.googlecode.iterm2" and (certificate leaf[field.1.2.840.113635.100.6.1.9] /* exists */ or certificate 1[field.1.2.840.113635.100.6.2.6] /* exists */ and certificate leaf[field.1.2.840.113635.100.6.1.13] /* exists */ and certificate leaf[subject.OU] = H7V7XYVQ7D)
```

Or

	codesign --display -r- --deep -v /path/to/.appBundle

### Unzip

		<dict>
			<key>Arguments</key>
			<dict>
				<key>archive_path</key>
				<string>%pathname%</string>
				<key>destination_path</key>
				<string>%RECIPE_CACHE_DIR%/%NAME%/Applications/directory</string>
				<key>purge_destination</key>
				<true/>
			</dict>
			<key>Processor</key>
			<string>Unarchiver</string>
		</dict>

## Pkg Creation Patterns

### Get Version from DMG

		<dict>
			<key>Arguments</key>
			<dict>
				<key>dmg_path</key>
				<string>%pathname%</string>
			</dict>
			<key>Processor</key>
			<string>AppDmgVersioner</string>
		</dict>

### Get Version from path

        <dict>
            <key>Arguments</key>
            <dict>
                <key>input_path</key>
                <string>%pathname%</string>
                <key>re_pattern</key>
                <string>name-([\d\.]+).*.dmg</string>
                <key>result_output_var_name</key>
                <string>version</string>
            </dict>
            <key>Processor</key>
			<string>com.github.magnusviri.processors/VariableFromPath</string>
		</dict>

### Get Version from Plist File

        <dict>
            <key>Arguments</key>
            <dict>
                <key>input_plist_path</key>
                <string>%RECIPE_CACHE_DIR%/name.app/Contents/Info.plist</string>
            </dict>
            <key>Processor</key>
            <string>Versioner</string>
        </dict>

### Create pkg root

		<dict>
			<key>Arguments</key>
			<dict>
				<key>pkgdirs</key>
				<dict>
					<key>Applications</key>
					<string>0755</string>
				</dict>
				<key>pkgroot</key>
				<string>%RECIPE_CACHE_DIR%/%NAME%</string>
			</dict>
			<key>Processor</key>
			<string>PkgRootCreator</string>
		</dict>

### Copy files

		<dict>
			<key>Arguments</key>
			<dict>
				<key>destination_path</key>
				<string>%pkgroot%/Applications/%NAME%.app</string>
				<key>source_path</key>
				<string>%pathname%/%NAME%.app</string>
			</dict>
			<key>Processor</key>
			<string>Copier</string>
		</dict>

### Create package

		<dict>
			<key>Arguments</key>
			<dict>
				<key>pkg_request</key>
				<dict>
					<key>chown</key>
					<array>
						<dict>
							<key>group</key>
							<string>admin</string>
							<key>path</key>
							<string>Applications</string>
							<key>user</key>
							<string>root</string>
						</dict>
					</array>
					<key>id</key>
					<string>%BUNDLE_ID%</string>
					<key>options</key>
					<string>purge_ds_store</string>
					<key>pkgname</key>
					<string>%NAME%-%version%</string>
				</dict>
			</dict>
			<key>Processor</key>
			<string>PkgCreator</string>
		</dict>

If I deploy a downloaded pkg I need to also specify pkgroot.

					<key>pkgroot</key>
					<string>%RECIPE_CACHE_DIR%/%NAME%</string>

## Other interesting processors

These might come in handy someday

		<dict>
			<key>Processor</key>
			<string>com.github.dataJAR-recipes.Shared Processors/DistributionPkgInfo</string>
			<key>Arguments</key>
			<dict>
				<key>pkg_path</key>
				<string>%pathname%</string>
			</dict>
		</dict>

		<dict>
			<key>Processor</key>
			<string>FileMover</string>
			<key>Arguments</key>
			<dict>
				<key>source</key>
				<string>%pathname%</string>
				<key>target</key>
				<string>%RECIPE_CACHE_DIR%/%NAME%-%version%.pkg</string>
			</dict>
		</dict>

		<dict>
			<key>Arguments</key>
			<dict>
				<key>pathname</key>
				<string>%RECIPE_CACHE_DIR%/%NAME%</string>
				<key>sourcelist</key>
				<array>
					<string>/Applications/GarageBand.app</string>
					<string>/Library/Application Support/GarageBand</string>
					<string>/Library/Application Support/Logic</string>
					<string>/Library/Audio/Apple Loops</string>
				</array>
			</dict>
			<key>Processor</key>
			<string>com.scriptingosx.processors/PathListCopier</string>
		</dict>

		<dict>
			<key>Arguments</key>
			<dict>
				<key>info_path</key>
				<string>%pathname%/Applications/GarageBand.app</string>
				<key>plist_keys</key>
				<dict>
					<key>CFBundleIdentifier</key>
					<string>bundleid</string>
					<key>CFBundleShortVersionString</key>
					<string>version</string>
				</dict>
			</dict>
			<key>Processor</key>
			<string>PlistReader</string>
		</dict>

		<dict>
			<key>Arguments</key>
			<dict>
				<key>app_path</key>
				<string>%pathname%/Applications/GarageBand.app</string>
				<key>mas_action</key>
				<string>dummy</string>
			</dict>
			<key>Processor</key>
			<string>com.scriptingosx.processors/MASReceipt</string>
		</dict>
		<dict>
			<key>Arguments</key>
			<dict>
				<key>input_plist_path</key>
				<string>%pathname%/Applications/GarageBand.app/Contents/Info.plist</string>
			</dict>
			<key>Processor</key>
			<string>com.github.autopkg.novaksam-recipes.Processors/MinimumOSExtractor</string>
		</dict>

		<dict>
			<key>Arguments</key>
			<dict>
				<key>cask_name</key>
				<string>jamovi</string>
			</dict>
			<key>Processor</key>
			<string>com.github.ahousseini-recipes.SharedProcessors/HomebrewCaskURL</string>
		</dict>