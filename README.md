# Introducing the HTMLbook gem

## Usage

    require 'htmlbook'

    book = HtmlBook.new('/tmp/page.html')
    book.build
    puts book.to_html

This gem attempts to make an HTML document easier to print like a book by splitting the content in pages based on the accumulated height of HTML elements.

## Resources

* htmlbook https://rubygems.org/gems/htmlbook

htmlbook gem html book page pages
