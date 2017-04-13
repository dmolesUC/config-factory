## 0.1.10 (next)

- Update to Ruby 2.2.5

## 0.0.9 (9 August 2016)

- Add `AbstractFactory#env_name` and inject the environment name, if available, on construction,
  in case factories need to know their environments. The default value is `Environments::DEFAULT_ENVIRONMENT`.

## 0.0.8 (4 April 2016)

- Support looking up implementation classes based on an argument
  filter

## 0.0.7 (31 March 2016)

- Support direct instantiation of implementation classes without
  product keys

## 0.0.6 (16 March 2016)

- Better error messages for missing keys, configs, etc.

## 0.0.5 (2 March 2016)

- Add `AbstractFactory#from_file`

## 0.0.4 (27 January 2016)

- Make gemspec smart enough to handle SSH checkouts

## 0.0.3 (5 January 2016)

- Additional error checking in `Environment#load_file` and `Environments#load_file`

## 0.0.2 (5 January 2016)

- Additional error checking in `Environment#initialize()`

## 0.0.1 (5 January 2016)

- Initial release
