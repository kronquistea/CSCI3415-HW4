## Part 1: 5 Short Answer Questions
1. How does the new language handle variable memory allocation, and what impact does this have on performance and memory safety?
   1. Lua has automatic memory management using garbage collection. There are two garbage collection modes that Lua support, *incremental* and *generational* (Lua 5.4 Reference Manual).
      1. Incremental garbage collection works by performing a mark-and-sweep collection like we learned in class. Meaning that as the program executes, the garbage collector marks dead objects and then sweeps them (clears them) (Lua 5.4 Reference Manual).
      2. Generational garbage collection works by having *minor* and *major* collections. Minor collections work by only traversing recently created objects. Then if the usage of memory is still above a limit, a major collection occurs. Major collections traverse all objects, meaning this mode is much better for programs that would otherwise waste a large amount of time allocating and freeing memory (Lua 5.4 Reference Manual).
   2. Of course because Lua has automatic memory management, there is no concern with dangling pointers or objects, however runtime efficiency could be slower because of garbage collection execution (Lua 5.4 Reference Manual). Most of the memory management and leak issues happen not because of the garbage collector but more likely due to the developers creating memory issues themselves. This can happen through many reasons and are not specific to Lua, such as unintended object retention, large tables growing unbounded, excessive temporary allocations, etc (ChatGPT).
2. Describe the language's approach to type systems and type binding time. Is the language statically or dynamically typed, and how does that affect error detection and program flexibility?
   1. Lua is a dynamically typed language and has runtime type binding and type checking. Dynamic languages allow for more "polymorphic" code because instead of having to create a generic class and implement the function with the generic class as a parameter for the function you can just pass the values in and the program will handle the input accordingly. However, this can also lead to issues for exactly this reason. If two parameters for a function are expected to do addition in the function but the arguments passed in are an int and string, there will be error detection until the code is actually run. This is similar to all dynamically typed languages, not just Lua. This means there could be reliability issues with checking of value types.
3. How does the language manage variable scope and lifetime - particularly for local, global, and any other static or non-local variables, if any?
   1. According to the Lua 5.4 Reference Manual, Lua is a lexically scoped language, meaning the visibility of the variable is from just after declaration to the last non-void statement of the innermost block that contains the declaration of the variable.
   2. Local variables are declared with the `local` keyword and are only visible to the block where they are defined. In my first code snippet the `local` keyword in `foo` tell Lua that the x value for that entire function should be equal to 10 instead of the global x which is equal to 5. The lifetime of these local variables is as long as the enclosing block is executing. However, local variables can live longer if they are captured by a `closure`. Closures are interesting because they allow local variables to continue to exist even when the function that delcared the local variable stops running. An example of closures is below. Because count was referenced inside the returning anonymous function, it was captured and that anonymous function is considered a `closure` and count is known as an `upvalue`. This kind of acts like a static variable in other languages as the reference to the variable is maintained and can be updated and modified.
        ```
        x = 5

        function foo()
        local x = 10
        print(x)
        end

        foo() --> 10
        print(x) --> 5
        ```
        ```
        function increment_counter()
            local count = 0

            return function()
                count = count + 1
                return count
            end
        end

        counter = increment_counter()
        print(counter()) --> 1
        print(counter()) --> 2
        ```
4. What are the subprogram calling conventions in the language? How are parameters passed (by value, by reference, etc), and how does the return mechanism work?
   1. All values in Lua are first-class values and functions are first-class values. Lua passes parameters by value. Tables, functions, threads, and full userdata are unique though, because they are all objects the variables do not actually contain values but instead references to values. So if Tables, functions, threads, or full userdata are passed as parameters then they are technically being passed by value but the actual values are mutable because they are actually references. A bit confusing, but these values are not copied and are instead directly modified just like a parameter passed by reference in Java for example.
   2. Lua supports multiple return values. Extra returned values are discarded and missing values become `nil`. In this first example, getCoord returns two separate values, but when we call getCoords we assign x, y, and z. Because getCoords returns less values than we are attempting to assign, the last variable will get set as `nil`.
        ```
        function getCoord()
            return 10, 20
        end

        x, y, z = getCoords()
        -- x = 10, y = 20, z = nil
        ```
    3. Lua uses a call stack. By default variables are global unless stated explicitly as `local` and each function call creates a frame containing:
       1. Local Variables
       2. Arguments
       3. Return Address
       4. Temporary Values
    4. Lua supports variable-length parameter lists using `...` notation. Lua does not support default arguments but they can be simulated like so:
        ```
        function foo(var)
            var = var or "no var"
            print("Var is" .. var)
        end
        ```
        The `..` notation in the previous example is simply string concatentation.
5. Identify any unique or innovative features that are very specific to the language and explain how they affect the way programmers write and structure code.
   1. I think the most unique thing about Lua is that there is only one default data structure - the table. A table can be an array (without being a dictionary/map), it can be a dictionary/map, it can be like a struct, etc. This means the language has much simpler implementation and allows for more flexbility. However, because there is no enforced schema it can be easier to make mistakes.
   2. Lua also does not support classes. If you want to create classes you instead have to create a table and metatables. So tables are objects and metatables defined behavior for the objects just as inheritance and operator overloading. This leads to more flexibility as classes can be whatever you want them to be. It also allows for a much more lightweight language design - which is the main purpose of Lua, to be embedded as a scripting language. However because there are no traditional templates for classes, you must create all classes from "scratch".
   3. Lua also supports coroutines through the standard library. This makes Lua especially applicable for video game development where code may need to be run every time a frame is updated or when something happens and the code should continue from where it left off.
   4. Lua's ideology of being as simple and small as possible have allowed it to thrive as an embeddable language and also for game development on its own. As the developers of Lua say "Mechanisms over Policies".
   5. Also the only "false" values are `nil` and `false`. The developers of Lua said that if they could go back in time they would change `nil` to not be a false value, however because `nil` is already written in much code and interpreted as false it is too late to make the change.