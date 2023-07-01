# picoCTF

for fun with nix flakes and haskell, where possible

https://play.picoctf.org

## What I've learned
* downloading binaries and running them won't work
    * theyll have some hardcoded path somewhere
    * use the magic of autoPatchElfBook
* common pattern
    * move files to nix store
    * write shell script to invoke it
    * best as 1 package, or 2?
