---
layout: post
title: "What's in a Rakefile?"
date: 2012-09-15 13:42
comments: true
categories: ruby rake albacore
---

I switched to Ruby and Rake for [my .NET build][sln] over the last few months and it's been freakin' awesome! I came from msbuild `.targets` and "programming in XML". I've basically stumbled upon a successful rake build along the way (and copied liberally from other projects). You can reference the [whole thing][gist] and I'll snip in each section as I explain it.

## Running on the Windows command line
For .NET projects, having a Ruby environment on your workstation or on the build agent is probably uncommon. I recommend checking in a [complete Ruby environment][ruby] (use one of the zip archives). You should make a few batch files to invoke the Ruby/Rake toolset *really* easily.

    CALL "%~dp0\ruby\bin\rake.bat" %*

This will call the Rake batch file in your Ruby environment, which is setup to invoke the Rake application. It defaults to using `rakefile.rb` and the `default` task. You can make other batch files to easily invoke other tasks/configurations. For example, a `Debug` build of the `CI` tasks...

    CALL "%~dp0\build.bat" configuration=Debug ci %*

Let's jump into the rakefile to see how some of those parameters are handled.

    configuration = ENV['configuration'] || 'Release'
    version       = ENV['version'] || '0.0.5.0'

These lines will check the environment variables, including anything passed in on the command line, **or** use the default. Here I'm allowing a 'configuration' (for an msbuild task, more on that later) and a 'version' to come in from the outside world (my build engine).

### Safe paths for Windows
Unfortunately, a lot of Windows applications, even native commands, do not handle relative file paths well. It certainly adds extra code every time you work with a path, but it's going to save you in the long run.

I start by defining the solution root, which is where my `rakefile` lives. And any other paths that will be commonly used throughout this build. I also put any static paths that might need to be changed per-branch front and center so they're easier to change.

    solution_root = File.expand_path(File.dirname(__FILE__))
    output_path   = File.join(solution_root, "bin/#{configuration}")
    drop_root     = '//development-nas/my-project/trunk'

Some Windows applications don't even respect the POSIX forward-slash directory separator. A helper method like this goes a long way in a Windows build.

    def windows_path(path)
        path.gsub('/', '\\')
    end

We have this method because we have some files, `CommonAssemblyInfo` and others (coming up), that need to be modified. But, because we're using TFS, the files on the build agent are read-only. And I have no intention of checking these back in, so `tf checkout #{path}` is overkill (and requires undo or checkin, not interested).

    def un_tfs(path)
        if File.exists?(path)
            File.chmod(644, path)
            puts "Making #{path} writeable"
        end
    end

## Clean/Clobber and FileLists
The [`FileList`][fl] is a lazy file collection defined by "[glob][gl]", or wildcard, patterns. And it supports a ton of great [transformations][pm]. They're great when you need to use a list in multiple tasks. If you define a regular list for, say, the `specs` and `publish_specs` tasks... this will execute immediately, before running the `build` task.

    spec_assemblies = Dir.glob("./#{output_path}/*.Specifications.dll")

You'll get a list of 0 items, or worse, if you didn't clobber the last build's output, you could get the last build's list. And that can wreak havoc when your next build adds/removes expected spec assemblies. Define it instead with `FileList` and it won't be resolved until you iterate over it.

    spec_assemblies = FileList["./#{output_path}/*.Specifications.dll"]

The `rake/clean` file defines two built-in `FileList`s, `CLEAN` & `CLOBBER`, used in built-in tasks, `clean` & `clobber`. Read [the documentation][clean] and understand the difference. Clobber is dead simple when you have a single `OutputPath` (in msbuild parlance).

    CLOBBER = FileList["./#{output_path}/*"]

## Finally, the tasks!
The `default` task must be defined and is used when you run `rake` without any parameters. I like this to be quick, but useful, usually a simple build & test. I'll define the *exact* TeamCity build tasks here, too, so that my configuration is one step: Rake runner; task = 'ci' or 'release'.

    task :default => [ :clean, :build, :test ]
    task :ci      => [ :clobber, :assemblyinfo, :build, :test,                :xmlupdate, :deploy ]
    task :release => [ :clobber, :assemblyinfo, :build, :test, :verification, :xmlupdate, :deploy, :msi ]

I'm doing a lot of common .NET build tasks. You can reference the [Albacore][alb] [wiki][alb-wiki] for information on the build, assemblyinfo, and test tasks. I'm using a [custom task][fut] of my own for rewriting the VC++ application resource and C# application configuration files. And the deploy & prune task is [another package][ldt] I maintain.

Let's look at one tricky task, made possibly by Ruby dynamism, the `verification_tests` task. Notice how it depends on (`=>`) an array of strings defined earlier? Those correspond to mspec tags that we use to categorize special tests. We need to provide a test results report for each tag... we could try to define each task individually

    mspec :lct_tests => :build do |mspec|
      results_path = File.join(output_path, "LCT_#{version}.verificationresults.html")
      mspec.options ["--html \"#{results_path}\"", "--include \"LCT\""]
      mspec.assemblies mspec_assemblies
    end

    mspec :fat_tests => :build do |mspec|
      results_path = File.join(output_path, "FAT_#{version}.verificationresults.html")
      mspec.options ["--html \"#{results_path}\"", "--include \"FAT\""]
      mspec.assemblies mspec_assemblies
    end
    
But, look at the duplication! Instead, because we know that we want the same exact task parameters, we'll loop through the array and dynamically create a task per `name`!

    verification_test_tags.each do |name|
      mspec name => :build do |mspec|
        results_path = File.join(output_path, "#{name}_#{version}.verificationresults.html")
        mspec.options ["--html \"#{results_path}\"", "--include \"#{name}\""]
        mspec.assemblies mspec_assemblies
      end
    end
    
## What's next?
You should dive headfirst into Albacore! And stay tuned, because I'll post some enhancements in the coming weeks/months...

* Commit the `apprc` and `appconfig` tasks to Albacore
* Manage and publish the version from *inside* this build
* Extract the TeamCity methods into a gem
* Wrap the InstallShield stuff into a gem


 [sln]: /blog/a-successful-solution-structure
 [gist]: https://gist.github.com/3729081
 [ruby]: http://rubyinstaller.org/downloads/
 [fl]: http://rake.rubyforge.org/classes/Rake/FileList.html
 [gl]: http://www.ruby-doc.org/core-1.9.3/Dir.html#method-c-glob
 [pm]: http://rake.rubyforge.org/classes/String.html#M000017
 [clean]: http://rake.rubyforge.org/files/lib/rake/clean_rb.html
 [alb]: https://github.com/Albacore/albacore
 [alb-wiki]: https://github.com/Albacore/albacore/wiki/_pages
 [fut]: https://github.com/anthonymastrean/fileupdatetasks
 [ldt]: https://github.com/anthonymastrean/localdroptasks