# SecureArchive

Need to backup a tree of files but can't trust the storage?

This gem provides a `gpg-archiver` command that can be used to build and
maintain an encrypted copy of a directory tree using
[GnuPG](https://www.gnupg.org/).  The encrypted directory can be backed-up
to untrusted storage using your regular backup solution.

## Installation

If you plan to build an application embedding SecureArchive, add this line to
your application's Gemfile:

```ruby
gem 'secure_archive'
```

And then execute:

    $ bundle

If you plan to use the `gpg-archiver` utility, simply run:

    $ gem install secure_archive

## Usage

The `gpg-archiver` utility requires at least a GnuPG recipient (provided using the `-r` argument), followed by the source and target directories.  If the source directory has a trailing `/`, the directory content (and not the directory itself) will be archived, so the following commands are equivalent:

~~~
gpg-archiver -r user@example.com /var/www/example.com/uploads  /var/backup/example.com
gpg-archiver -r user@example.com /var/www/example.com/uploads/ /var/backup/example.com/uploads
~~~

## Contributing

1. Fork it ( https://github.com/sante-link/secure_archive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
