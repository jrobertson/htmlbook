#!/usr/bin/env ruby

# file: htmlbook.rb


require 'rexle-builder'
require 'qnd_html2page'



class HtmlBook

  attr_reader :to_html
  attr_accessor :pages


  def initialize(filename='page.html', pg_height: 740, width: '700px', 
                 debug: false)

    @filename, @pg_height, @width, @debug = filename, pg_height, width, debug
    @doc = build()
    @to_html = @doc.root.xml pretty: true

  end

  def build()
    
    doc = Rexle.new(RXFHelper.read(@filename).first)
    
    style = Rexle::Element.new('style').add_text css
    style.attributes[:id] = 'tmpcss'
    doc.root.element('head').add  style
    puts 'doc: ' + doc.xml.inspect if @debug
    
    pages = QndHtml2Page.new(doc, pg_height: @pg_height, debug: @debug).to_pages
    doc.at_css('#tmpcss').delete
    build_html doc, collate(pages)
    
  end

  def save(filename=@filename.sub(/\.\w+$/,'2\0'))
    
    css_filename = filename.sub(/\.html$/, '.css')
    @doc.root.element('head/link').attributes[:href] = css_filename
    File.write css_filename, css()
    File.write filename, @doc.xml(pretty: true)
    
  end
  
  protected
  
  def collate(pages)
    pages.map.with_index {|pg, pg_no| [pg, pg_no+1]}    
  end


  def build_html(doc, pages)

    xml = RexleBuilder.new 
    
    a = xml.body do

      pages.each do |page, pg_no|
        
        puts 'page: ' + page.inspect if @debug

        xml.div({class: 'page '})  do
          xml.article page.children.join
          xml.footer do
            xml.p({class: 'n'+ (pg_no.odd? ? 'odd' : 'even')}, 
                  'pg ' + pg_no.to_s)
          end
        end

      end

    end
    
    body = Rexle.new(a).root
    puts 'after body' if @debug
    doc.root.element('body').delete
    doc.root.add body

    attr = Attributes.new( { rel: "stylesheet", type: "text/css", \
                        href:  @filename.sub(/\.html$/, '.css'), media: \
                      "screen, projection, tv, print" })    
    link = Rexle::Element.new('link', attributes: attr)
        
    doc.root.element('head').add link
    puts 'returning the doc' if @debug
    return doc
    
  end

  def css()
<<CSS
html,
body {
  height: 100%;
  margin: 0;
  padding: 0;
  max-width: 700px;
}

span {font-size: 0.01em; margin: 0; padding: 0;}

.page {
  display: flex;
  flex-direction: column;
  min-height: 100%;
}

article {
  flex: 1;
}

@media print {
  .page {page-break-after: always;}
}

.page {

        margin: 0; padding: 0; 
        border: 1px solid black;
        /* height: 98vh; */

  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -webkit-box-orient: vertical;
  -webkit-box-direction: normal;
      -ms-flex-direction: column;
          flex-direction: column;
  min-height: 88%;
}
article {
  -webkit-box-flex: 1;
      -ms-flex: 1;
          flex: 1;
}


    footer p.nodd  {text-align: right;}
CSS
  end

end
