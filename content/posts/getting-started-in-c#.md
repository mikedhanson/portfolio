+++
draft = false
date = 2023-04-22T21:25:31-05:00
title = "Getting Started with C#"
description = "Set up the .NET SDK, create a console app, and learn the C# basics by building and running a small program."
slug = ""
authors = []
tags = ["C#", ".NET", "Programming"]
categories = ["Code"]
externalLink = ""
series = []
+++

C# (pronounced “C sharp”) is a general-purpose programming language commonly used with .NET. You can use it for command-line tools, web services, desktop applications, games, and much more.

This guide walks through creating and running a small console program. You do not need prior experience with C#, but some familiarity with using a terminal will help.

## Install the .NET SDK

Install the **.NET SDK** for your operating system from [dotnet.microsoft.com/download](https://dotnet.microsoft.com/download). The SDK includes the `dotnet` command-line tools needed to create, build, and run projects. It is different from the .NET runtime alone, which is intended for running applications that have already been built.

After installation, open a new terminal and check that the command is available:

```text
dotnet --version
```

The command prints the installed SDK version. If the command is not recognized, reopen the terminal; if it is still missing, check that the SDK installer completed and that `dotnet` is on your `PATH`.

You can write C# in any text editor. [Visual Studio](https://visualstudio.microsoft.com/) and [Visual Studio Code](https://code.visualstudio.com/) are two common choices; the full Visual Studio IDE and the .NET SDK are separate installations.

## Create and run a console app

In a terminal, choose a directory where you keep projects and run:

```text
dotnet new console -n HelloCSharp
cd HelloCSharp
dotnet run
```

The template creates a new project named `HelloCSharp`. The first run restores any required dependencies, builds the project, and runs it. A new console app prints a greeting.

Open the generated `Program.cs`. A recent .NET console template uses **top-level statements**, which means you can write the program without first declaring a class and a `Main` method.

Replace its contents with:

```csharp
Console.Write("What is your name? ");
string? name = Console.ReadLine();

if (string.IsNullOrWhiteSpace(name))
{
    Console.WriteLine("Hello, there!");
}
else
{
    Console.WriteLine($"Hello, {name.Trim()}!");
}
```

Run the app again:

```text
dotnet run
```

`Console.Write` displays a prompt without moving to the next line. `Console.ReadLine` reads user input. The variable is declared as `string?` because the user might not enter a line, and the null check is part of handling that possibility safely. The `$"..."` syntax creates an interpolated string, inserting the value of an expression such as `{name.Trim()}` into the text.

## A few C# building blocks

### Variables and types

A variable stores a value. C# checks that values are used with compatible types:

```csharp
string firstName = "Ada";
int completedProjects = 3;
bool isAvailable = true;
```

You can also let the compiler infer a local variable's type with `var`:

```csharp
var greeting = $"Hello, {firstName}!";
```

`var` is still statically typed—the compiler determines the type from the value on the right-hand side. It does not mean that the variable can freely change to any type.

### Conditions

Use `if` when a program should choose what to do based on a condition:

```csharp
if (completedProjects > 0)
{
    Console.WriteLine($"{firstName} has completed work.");
}
else
{
    Console.WriteLine("No completed projects yet.");
}
```

The braces mark the code that belongs to each branch. Even when a branch contains only one line, keeping braces makes changes easier to review.

### Collections and loops

A `List<T>` stores a collection of values of type `T`. This example prints each language in a list:

```csharp
var languages = new List<string> { "C#", "PowerShell", "Python" };

foreach (string language in languages)
{
    Console.WriteLine(language);
}
```

Most .NET types, including `List<T>`, live in namespaces. The standard console template includes common `System` namespaces through implicit usings, so `List<string>` works without an extra `using` line in a typical new project.

### Methods

A method gives a named piece of work a place in your program. It can accept inputs and return a result:

```csharp
static string CreateGreeting(string name)
{
    return $"Hello, {name}!";
}
```

You can call it with `CreateGreeting("Ada")`. The `string` before the method name is its return type; the `string name` inside the parentheses is a parameter.

## Build and run

While `dotnet run` is convenient during development, the CLI also exposes the individual steps:

```text
dotnet build
dotnet run --no-build
```

`dotnet build` checks and compiles the project. `dotnet run --no-build` runs the most recently built version. Build errors point to a source file and line number; read the first error carefully, make a small correction, and build again.

## Where to go next

Once the console app makes sense, useful next steps include:

- Learn about classes, interfaces, and records to organize related data and behavior.
- Practice working with collections, files, and JSON.
- Learn `try`/`catch` and input validation for operations that can fail.
- Add unit tests to check behavior as the program grows.
- Explore the official [.NET documentation](https://learn.microsoft.com/dotnet/) and [C# documentation](https://learn.microsoft.com/dotnet/csharp/).

The best way to learn is to make a small program that solves a problem you understand. Get the basic version working, then improve it one feature at a time.