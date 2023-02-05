# Lintalist Alternative Update methods

During the Lintalist update process it creates a backup in the tmpscripts folder
including all bundles. It may happen there will be an error message:

    Compressed (zipped) Folders Error

    'path' cannot be compressed because it includes characters
    that cannot be used in a compressed folder, such as [...].
    You should rename this file or directory.

At that moment the Lintalist update process is stopped and you manually need
to close `Update.ahk` in the tray menu (Green H-icon), right click, Exit. 

Note: Discussion on GH @ https://github.com/lintalist/lintalist/issues/154

## Solutions:

1. Start Lintalist again - check for updates, and bypass the backup when asked, or
2. Manually update Lintalist by downloading it from https://github.com/lintalist/lintalist/releases, or
3. Or use 7-zip by following these instructions:

You will need to download the standalone console version from the 7-Zip website - available on the Downloads page:

https://www.7-zip.org/download.html

Look for "7-Zip Extra: standalone console version" 

All you need is `7za.exe`  - copy that file to the Lintalist `include` folder.

Now start Lintalist again, check for updates. Now Lintalist will use 7-zip
to prepare the backup and continue the update process.

