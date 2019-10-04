# Smarter Rspec Runner
Script that runs specs for Rails and other Ruby projects based off of perforce status

### Installation
This gem is publicly available on RubyGems. 

```
gem install specss
```

If your projects use different Ruby versions, then each one will require this step in order to run.

### Use
Navigate to the root of your rails app or ruby project and simply run:

``` 
specss
```

By default, it only runs the 'condensed' version that executes specs based on files opened for edit from your p4 status. To run specs on all 
changed files and all dependents of those changed files, run:

```
specss -e
```

For other information, print the help after running the executable:

```
[~]$ specss -h
Usage: specss [option]
    -c, --condensed                  Run specs of files opened for edit only
    -e, --extended                   Run specs of files opened for edit and dependents
    -l, --list                       Prints a list of specs for files opened for edit
    -v, --version                    Smarter Specs Version
    -h, --help                       Prints this help
```

### Development
```
git clone git@github.com:tombonan/smarter-specs.git && cd smarter-specs
rake console
```

### Gathering Dependents
In the script I utilize the [Rubrowser](https://github.com/emad-elsaid/rubrowser) gem to create a dependency graph for the code. 
