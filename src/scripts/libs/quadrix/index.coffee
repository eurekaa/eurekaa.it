# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 05/09/13 12.34

define [
   'config' 
   'jarvix'
   'jquery_ui'
   'namespace'
   'scripts/libs/quadrix/modules/parser'
   'scripts/libs/quadrix/modules/localizer'
], (config, jX, $, namespace, parser, localizer)->
   
   
   # init library.
   qX = 
      parser: parser
      localizer: localizer


   # add widgets to library. each widget will be asynchronously downloaded when required.
   widgets = ['accordion', 'breadcrumber', 'langswitcher', 'menu', 'panel', 'scrollbar']
   jX.list.each widgets, (widget_name, i)->

      qX[widget_name] = (element, options, callback)-> 
         try
            if element then element = $(element) else throw new Error 'element must be defined'
            require [config.require.paths.quadrix.replace('index', 'widgets/') + widget_name], (widget)->
               
               # wait for widget to be ready, then callback passing widget api.
               element.on 'ready', ()-> 
                  callback null, element.data 'qX-qX_' + widget_name
                  element.off 'ready'
               
               # run widget on element.               
               options = options || {}
               element['qX_' + widget_name](options)
         
         catch err then callback err, null


   # create qX namespace under $.fn 
   $.namespace '$.fn.qX'

   # add namespace constructor.
   $.fn.qX = (widget_name, options, callback)->
      
      # if a widget name is provided invoke to widget.
      if widget_name then qX[widget_name](@, options, callback)

      return @
      
      
      
      

   # return the library.
   return qX  