# urls_bro

another url shortener plugin for weechat

## manual installation

"Just give me the commands, chief."

```bash
wget -O urls_bro.rb https://raw.github.com/komidore64/urls_bro/master/urls_bro.rb
mv urls_bro.rb ~/.weechat/ruby/
pushd ~/.weechat/ruby/autoload/
ln -s ../urls_bro.rb
popd
```

## help me help you

If you've come across a bug or error in `urls_bro`, please submit a [Github issue](https://github.com/komidore64/urls_bro/issues) describing the problem, and what version of `urls_bro` you're using.
