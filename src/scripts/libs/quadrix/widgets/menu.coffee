# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: test
# Created: 08/08/13 20.59


#@todo:  il menu sarà il centro di controllo del trio exp.menu, exp.lang_switcher, exp.container.
#@todo:  require: exp.widgets.lang_switcher - selettore del tag di lancio. 
#@todo:     (exp.modules.langswitcher sarà poi un modulo che usa sizzle.js per il parsing di DOMElements al posto di jquery)
#@todo:     ogni istanza di menu si mette in ascolto sul selettore del lang_switcher.
#@todo:  require: exo.widgets.container
#todo:       
define [
   'jquery_ui'
   'jarvix'
   'quadrix'
   'animate_css'
], ($, jX, qX) ->

   # load stylesheets.
   jX.load.stylesheets ['styles/menu.css']

   # create widget.
   $.widget 'qX.qX_menu',

      options:
         ready: false
         class: 'menu'
         widgets:
            breadcrumber: undefined
            panel: undefined, 
         list: null
      
      
      _create: ->
         self = @

         # wait for all widgets to be ready.
         self._wait_widgets ->
            
            # run main method.
            self.main self.element, self.options



      _wait_widgets: (callback)->
         self = @
         element = self.element
         widgets = self.options.widgets
         widgets_names = jX.object.keys widgets
         loaded = 0
         counted = widgets_names.length
         
         # if no widget dependencies then start the plugin directly.
         if counted == 0 then return callback()
         
         # wait for widgets to be loaded.
         element.on 'waiting', (event, name)->
            loaded++
            
            # when a widget is loaded store its api in options.widgets property.
            widgets[name] = $(widgets[name]).data 'qX-qX_' + name
            
            # if all widgets are loaded, callback.
            if counted == loaded
               element.off 'waiting' 
               callback()
         
         # handle widgets loading.
         jX.list.each widgets_names, (name, i)->
            widget = $(widgets[name])
            
            # widget is already.   
            if widget and widget.data 'qX-qX_' + name
               element.trigger 'waiting', name

            # wait for widget ready.
            else widget.on 'ready', ->
               element.trigger 'waiting', name; 
               widget.off 'ready'



      main: (element, options)->
         self = @
         widgets = self.options.widgets
         try
            
            # check arguments.
            if not jX.utility.is_defined widgets.panel then throw 'qX.panel must be defined.'
            
            # add class to container.
            element.addClass options.class
            
            # render menu
            datalist = element.find 'datalist option'
            html = '<ul>'
            jX.list.each element.find('datalist option'), (option, i)->
               html += '<li class="' + (option.className || '')  + '">'
               html += '<a data-label="' + option.label + '" data-link="' + option.value + '"></a>'
               html += '</li>'
            html += '</ul>'
            self.element.html html
            
            
            # init menu
            self.localize()
            
            # bind click events.
            element.find('[data-link]').on 'click', (event)-> self.load_url(event)
            
            # bind localization event.
            $(window).on 'localize', -> self.localize()
            
            # trigger ready event.
            options.ready = true
            element.trigger 'ready'
         
         catch err then console.error err


      localize: ()->
         self = @ # preserve context.
         
         # localize menu.
         self.element.find('li').each (i, item)->
            item = $(item)
            item.animate_css 'bounceInDown', (100 * ++i)
            qX.localizer.localize item, (err, item)->


      load_url: (event)->
         self = @
         widgets = self.options.widgets
         element = $(event.target)
         
         # if active return.
         if element.parent().hasClass 'active' then return
         
         # load new page.
         page = element.attr('data-link').replace('page://', 'pages/')
         widgets.panel.load page, (err)->
            if err then console.error err

         # change menu status.
         self.element.find('li').each (i, item)-> $(item).removeClass 'active'
         element.parent().addClass 'active'
         
         # change breadcrumb.
         #if self.options.breadcrumber
         #self.options.breadcrumber.reset(jX.utility.to_capitalized(element.html()))


      _destroy: ->
         @.element.removeClass @.options.class