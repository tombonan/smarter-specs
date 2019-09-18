# Smarter Rspec Runner
Script that runs specs for Spectra Rails projects based off of dependencies and perforce changelists

### Rubrowser Dependency Graph
In the script I utilize the [Rubrowser](https://github.com/emad-elsaid/rubrowser) gem to create a dependency graph for our code. The gem wont work with our specified
ruby versions so I created a separate build of the gem. For each version of Ruby you are using, you will have to install it via:

```
gem install /path/to/rubrowser-2.7.1.gem
```

### Rails Projects
Currently this works for all of our Rails projects. The Rubrowser gem won't work with Ruby 2.2.5 in Bargen so it will run a 'lite' version that only checks
modified files and not all dependencies.

### Installation
First clone this repo into your local files
```
git clone git@github.com:tombonan/smarter-specs.git
```
then navigate to your project and install the gem locally
```
gem install /path/to/repo/builds/specs-0.1.0.gem
```

If your projects use different Ruby versions, then each one will require this step
