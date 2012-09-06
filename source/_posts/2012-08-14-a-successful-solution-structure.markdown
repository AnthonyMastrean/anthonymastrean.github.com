---
layout: post
title: "A Successful Solution Structure"
date: 2011-10-20 00:00
comments: true
categories: msbuild tfs teamcity vcs
---

*I'm writing specifically about .NET solution/project structure, but the principals probably apply to other languages/platforms.*

----

I've recently developed a really good solution structure for Visual Studio/.NET projects. I think this works for any source control. This is the filesystem structure and should be mirrored exactly in source control. I'll review each decision and its advantages.

    bin\
      Debug\
      Release\
    docs\
    install\
    packages\
    source\
      project-1\
      project-2\
      project-n\
    build.targets
    CommonAssembyInfo.cs
    Solution.sln

## source
All projects should go under this directory, one layer deep. Every project in your solution should be uniquely named (by namespace, if possible) in its own folder. There's no reason for arbitrary categorization or organization by sub-folder. The advantage is that every project is the same distance from each other and the branch root. So, you can create common build events that operate effectively for every project.

## packages
I use NuGet for package management and it's a blast. This is the default convention. The advantage is that all packages are the same distance from every project.

## bin
The output path for every project should point here. There is [good mojo][out] for moving all your output to one location. The advantage is that the output directory is the same distance for every project, which is easy to script or share. The MSBuild lingo would be

    <PropertyGroup>
      <OutputPath>$(MSBuildProjectDirectory)\..\..\bin\$(Configuration)</OutputPath>
    </PropertyGroup>

Notice that I use the uncommon, but automatic, msbuild project path, not the solution path. This is useful if you ever want to operate on a single project outside of a solution context (otherwise, you have to arbitrarily pass in `/p:SolutionDir=<blah>` in your command). Also, this is a convenient location for CI build steps like "drop output to a network share" or "build an installer from this junk".

## install
This is where an installer project or files would go (shortcuts, icons, etc). The advantage is that it sits above the source code, packages, and output. And, again, that everything is an equal distance from the installer.

## build.targets
I don't like MSBuild ([why?][msb]). I use isolated targets that [accept variables][var] from the caller and never chain tasks together.

    <Target Name="CopyBuildOutput">
      <CreateItem Include="$(OutputPath)\**\*">
        <Output TaskParameter="Include" ItemName="OutputFiles" />
      </CreateItem>
      <MakeDir Directories="$(DropRoot)" />
      <Copy SourceFiles="@(OutputFiles)" 
            DestinationFiles="@(OutputFiles->'$(DropRoot)\$(Version)\%(RecursiveDir)%(Filename)%(Extension)')"
            ContinueOnError="true" />
    </Target>

I use TeamCity and the configurable build steps for the rest. If my project needed to build/deploy from the command line, then I would follow the same pattern in a batch/PowerShell file. I still wouldn't chain MSBuild tasks together. I try to have my solution be buildable (ignore unit tests, assembly version updating, etc) from the command line from a simple MSBuild command. This command executes the default platform/configuration/target against a solution in this directory.

    cmd\project-root> msbuild

## Specific Recommendations for TFS
If you're going to use TFS, realize that it views branches in a [funky way][tfs]. Luckily, this directory structure works well with that perspective. The project structure above should be completely self-contained in a folder per branch. It's up to you if you want to sub-folder `releases` and `branches`, but I'm moving away from that style and would do them all directly under `my-project`.

    $/
      my-project
        trunk/
        release/
          0.9.0/
          1.0.0-beta.1/
        branch/
          some_broken_feature/
          my_crazy_rewrite/
                
This allows you to parameterize the source control root, `$/my-project/%vcs.branch%`. You can specify a property, `%vcs.branch% = "trunk"`. And override it in the release build, `%vcs.branch% = "release/1.0.0-beta.1"`.

## Conclusions
It took a fair amount of practice to get this right. And Visual Studio/TFS don't really lead you down this path by default. There is a fair bit of MSBuild/csproj customization required to get some of these things right. Practice, reduce friction, and iterate.

## NEW! Dump MSBuild for Rake!
I've really taken to using the [Rake build system][rake] from the Ruby world. It's easy to get started. If you're in a .NET ecosystem, it helps to drop the entire [Ruby environment][ruby] into source control (get the archive instead of the installer). And create a `rakefile.rb` instead of an msbuild targets file.

    bin\
    docs\
    install\
    packages\
    ruby\        <-- NEW
    source\
    rakefile.rb  <-- NEW
    build.bat    <-- NEW
    CommonAssembyInfo.cs
    Solution.sln

In Windows environments, I recommend creating helper scripts so you can easily start your build from the explorer and to simplify the command line syntax. A `build.bat` file might look like this.

    @ECHO OFF
    :: Call the local rake environment, passing in all command line args
    CALL "%~dp0\ruby\bin\rake.bat" %*
    PAUSE
    
Definitely check out the [Albacore][alb] Rake tasks for common .NET tools.

 [out]: http://codebetter.com/patricksmacchia/2009/01/11/lessons-learned-from-the-nunit-code-base/
 [msb]: http://martinfowler.com/bliki/BuildLanguage.html
 [var]: http://stackoverflow.com/questions/6218486/teamcity-says-to-use-build-parameters-instead-of-property-in-an-msbuild-st
 [tfs]: http://stackoverflow.com/questions/5129959/how-do-i-use-git-tfs-and-idiomatic-git-branching-against-a-tfs-repository
 [rake]: http://rake.rubyforge.org/
 [ruby]: http://rubyinstaller.org/downloads/
 [alb]: https://github.com/derickbailey/Albacore