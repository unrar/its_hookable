# it's hookable! (v0.0.1)
# @author unrar
# This is a project that aims to develop expansion techniques that will be applied to midb.
# These series of scripts by themselves have no use; however you can apply the techniques
# used and documented here to your own project!


# This is the file where the methods that will be registered are contained.
# This can be any collection of methods. No special syntax is used; just plain methods.
require_relative "./custom"

# This module represents the whole thing you want to add hooks to. The developer has access to this code,
# but he doesn't need to alter it in order to add custom behavior thanks to hooks.

module Hookable
  
  # This class controlls the behavior of the hooks, as well as their registration. 
  class Hooks
    attr_accessor :hooks
    def initialize()
      # We need a hash that contains all the hooks existing in our module, plus an array with references
      # to what functions will be applied to that hook.
      # Example: (runtime) @hooks["constructor"] = [:say_hi, :tell_everyone, :say_bye]

      @hooks = Hash.new
      @hooks["constructor"] = []
      @hooks["format"] = []
    end

    # This method adds a method _reference_ (:whatever) to the hash defined above.
    def register(hook, method)
      @hooks[hook].push method
    end

    # These are the methods that are ran when the hook is called from the main class.
    # The code can be slightly modified depending on the arguments that each hook takes,
    # but that's up to the original developer - not the one who does the customization.
    def constructor()
      @hooks["constructor"].each do |f|
        # Just run :f whenever this method is called, no arguments.
        Object.send(f)
      end
    end

    def format(what)
      @hooks["format"].each do |f|
        # Since the hook will be called like format("14"), we pass that argument to each
        # function. Note that since we're returning a value, only the first hook to be
        # registered will be ran. (this is not a bug, you can't load 3 hooks to format a string).
        return Object.send(f, what)
      end
    end
  end

  # This is the main class, where the hooks will be ran.
  class Thing
    # Notice the :h; this contains our Hooks object
    attr_accessor :name, :h
    # NOTICE the hooks parameter. It's a Hookable::Hooks object, null by default.
    def initialize(name, hooks=nil)
      if hooks == nil
        # Add support for hooks
        @h = Hookable::Hooks.new
        # This hook is loaded automatically, because no hooks can be manually loaded before 
        # the constructor is ran!
        @h.register("constructor", :say_hi)
      else
        @h = hooks
      end

      # Run the hook for the constructor
      @h.constructor()
      @name = name
    end

    # VERY IMPORTANT! This allows developers to register hooks without editing the actual code.
    def register_hook(hook, function)
      @h.register(hook, function)
    end


    def get_name()
      # Format the output
      puts @h.format(@name)
    end
  end
end
# Register them hooks
box = Hookable::Thing.new("box")
box.register_hook("format", :product)
box.get_name

## ALTERNATIVE! Probably to be used in midb because it's easier than altering every object.
my_hooks = Hookable::Hooks.new
# This allows you to add custom constructor hooks!
my_hooks.register("constructor", :special)
my_hooks.register("format", :money)

chair = Hookable::Thing.new("chair", my_hooks)
chair.get_name
