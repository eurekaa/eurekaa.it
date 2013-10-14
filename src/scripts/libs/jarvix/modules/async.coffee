# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: async
# Created: 01/10/13 20.38

define [], ->
   
   if: (condition, action, callback)->
      if condition then action.then callback
      else action.else callback