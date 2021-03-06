# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 05/09/13 12.34


jX = require 'jarvix'
jX.library.define 'quadrix', [
   'config://index' 
   'jquery_ui'
   'namespace'
   'quadrix://parser'
   'quadrix://localizer'
   'quadrix://element'
], (sys, $, namespace, parser, localizer, element)->

   # init library.
   qX =
      localizer: localizer
      element: element
      parser: parser 
   
   # add widgets to library. each widget will be asynchronously downloaded when required.
   widgets = ['accordion', 'breadcrumber', 'langswitcher', 'menu', 'panel', 'scrollbar']
   jX.list.each widgets, (widget_name, i)->

      qX[widget_name] = (element, options, callback)-> 
         try
            if not callback then callback = ()->
            if element then element = $(element) else throw new Error 'element must be defined'
            console.log widget_name
            jX.module.require ['quadrix://widgets/' + widget_name], (widget)->
               
               # wait for widget to be ready, then callback passing widget api.
               element.on 'ready', ()-> 
                  callback null, element.data 'qUi-qUi_' + widget_name
                  element.off 'ready'
               
               # run widget on element.
               options = options || {}
               element['qUi_' + widget_name](options)
         
         catch err then callback err, null


   # create qX namespace under $.fn 
   $.namespace '$.fn.qUi'

   # add namespace constructor.
   $.fn.qX = (widget_name, options, callback)->
      
      # if a widget name is provided invoke to widget.
      if widget_name then qX[widget_name](@, options, callback)

      return @

   
   
   # return library.
   return qX  