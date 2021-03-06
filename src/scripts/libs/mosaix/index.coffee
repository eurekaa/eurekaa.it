# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 01/09/13 6.32

jX.library.define 'mosaix', 
jarvix_path: '../jarvix/index', [
   'mosaix://database'
   'mosaix://load'
   'mosaix://socket'
], (database, load, socket)->

   database: database
   load: load
   socket: socket