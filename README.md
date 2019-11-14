# Readinglist

A command line utility to help you find books you are looking for and save them to a reading list.

## Dependencies

At the least requires the Erlang vm to run the `readinglist` file. 

The script was developed using Elixir 1.9.4 and Erlang/OTP 22.

## Installation

Clone down the repository with git

```bash
  git clone https://github.com/karl-thomas/readinglist.git
```

If you are planning on working on it or running the tests, make sure you get the dependencies

```bash
 mix deps.get
```

## Usage

You can use this utility by running the file './readinglist'

### Search

Uses the google books api to find books.

A basic query
```
./readinglist search --query="flowers" 
```

A query with a modifier.
```
./readinglist search --query="flowers" --inauthor=keyes
```

Or just the modifier

```
./readinglist search --inauthor=keyes
```

All the Modifiers

- `--intitle`: Returns results where the text following this keyword is found in the title.
- `--inauthor`: Returns results where the text following this keyword is found in the author.
- `--inpublisher`: Returns results where the text following this keyword is found in the publisher.
- `--subject`: Returns results where the text following this keyword is listed in the category list of the volume.
- `--isbn`: Returns results where the text following this keyword is the ISBN number.
- `--lccn`: Returns results where the text following this keyword is the Library of Congress Control Number.
- `--oclc`: Returns results where the text following this keyword is the Online Computer Library Center number.


It will then prompt you from a list a five books, you can enter 1-5 and it will save that book to a file. 

### List

To list what is in your reading list file

```
./readinglist list
```

## Build script

```
mix escript.build
```
