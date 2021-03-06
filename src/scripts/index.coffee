# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 08/08/13 20.58


# define main module.
jX = require 'jarvix'
jX.module.define 'index', [
   'jquery_ui'
   'mosaix'
   'quadrix'
], ($, mX, qX)->

   # load stylesheets.
   mX.load.stylesheets [
      'styles/eurekaa.css'
      'styles/fonts.css'
   ]
   
   qX.element.define 'index',

      options: {}
      