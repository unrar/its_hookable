## it's hookable!
This is a very simple approach to using hooks. It will be used in midb, but this project as it is is pretty useless. It's
not a gem, not a standalone app, just a collection of code!

### How to hook, bro?
Using this approach, all an end-user (aka developer who wants to customize everything) has to do is:

```ruby
require 'my_stuff'
def announce(x)
  puts "Boys n gals, i'm announcing you that #{x}!"
end
hooks = MyStuff::Hooks.new
hooks.register("do_something_with", :announce)

ayy = MyStuff::Tabloid.new("everybody is dead")
ayy.do_hooked_stuff
```

That code, we presume, would yield something like "Boys n gals, i'm announcing you that everybody is dead!" Ouch!