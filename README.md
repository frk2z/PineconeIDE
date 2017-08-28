# Pinecone IDE

A small IDE for the language [Pinecone][https://github.com/william01110111/Pinecone] built with [Fragaria][https://github.com/mugginsoft/Fragaria] and written in Objective-C

## Features

- Auto Complete
- Syntax Highlighting
- Custom Color Schemes
- Run, save as cpp or bin file from the editor (will open Terminal.app and save the file)

## Installing the IDE

You can either clone the repo and build it yourself with Xcode or grab the compiled version [here][https://github.com/frk2z/PineconeIDE/releases]

## Questions that you might ask

- Why can't I run my program ?

Make sure that the *pinecone* executable is in your $PATH, if it isn't clone the [Pinecone git repository][https://github.com/william01110111/Pinecone.git], compile and install it yourself.

- How can I learn Pinecone ?

By reading [these tutorials][https://github.com/william01110111/Pinecone/blob/master/tutorials/index.md].

- Why creating an IDE for Pinecone ?

Pinecone is a fast and easy compiled language that I really wanted to learn, but I didn't find any plug-in for it and I failed to create a .tmLanguage. So I ended up using my old project of creating a code editor for TI-Basic and added compatibility for Pinecone.

- Why using an old version of Fragaria ?

I tried to use a newer version of Fragaria, but even after trying to follow the official tutorial I got a lot of compilation errors. So I got bored and ended up using the older version of Fragaria that was still on my computer.

- I have more questions / I want to contact you, how can I do it ?

You can contact me on my Twitter ([@FrK2z][https://twitter.com/FrK2z]) or if you don't have Twitter you can still use my [e-mail][mailto:fr.k2z.dev@outlook.fr].

## TODO

- [x] Create README.md
- [x] Create CHANGELOG.md
- [x] Publish on Github (YAY)
- [ ] Wait for Pinecone to have a *compile* feature and add a *Save & Build* action in AppDelegate
- [ ] More TODO