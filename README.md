# Collate
_Backup and restore system to manageable configurations._

Create basic configuration backup, modify collection and add post-install instruction.

Steps:
1. OS Bootstrap
2. Cleanup
3. Playbook
4. Configuration
5. Post-cleanup

# Sample
```
Scleros
    Partitioning
        EFI => FAT32 500MB

        Windows => 280GB
            MSR => FAT32 650MB
            Windows => NTFS 80GB
            WinApps => NTFS 200GB

        Linux => 196GB
            Arch => EXT4 180GB
            Swap => SWP 16GB

        OSX
            Macintosh => HFS+ 150GB
            Recovery => HFS+ 100GB

        Development => NTFS(interop) 50GB
        VM => NTFS(interop) 100GB
        Warehouse => NTFS(interop) <Leftover>

    Installation
        Linux -> Windows -> OSX

    Windows
        Bootstrapping
            Apps
                Chocolatey
                    Android SDK
                    Vc redistributable
                    Directx9
                    Audacity
                    ADB
                    Virtualbox
                    Firefox
                    XMBC
                    Mongodb
                    Yarn
                    rust
                    Xampp
                    VLC
                    PowerISO
                    ShareX
                    Ruby
                    Atom
                    7Zip
                    Git
                    Git LFS
                    Cmake
                    GoLang
                    NodeJS
                    Heroku-cli
                    Flutter
                    GLFW
                    Python3

                Generic
                    Office
                    Illustrator
                    Sublime text 3
                    Steam
                    Utorrent web
                    Visual Studio
                    Tor
                    Adobe Suite
                    Ableton

    Arch

    OSX
```
