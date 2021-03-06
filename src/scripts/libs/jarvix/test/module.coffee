# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: module
# Created: 26/01/14 10.49

jx.test.define 'jarvix.module', ->
   
   @.describe '.resolve_paths()', ->
      
      @.it 'resolves paths correctly', (done)->
         done ->
            self = @
            jx.module.resolve_paths [
               'jarvix://libs/async'
            ], (err, paths)->
               #self.assertEqual 'x', 'x'
               jx.test.expect(err).to.be.true
               jx.test.expect(paths).to.be.an 'array'
               jx.test.expect(paths[0]).to.eql 'scripts/libs/jarvix/libs/async'
      
      
      @.it 'resolves paths asimmetrically on client and server', (done)->
         done ->
            jx.module.resolve_paths 
               client: ['jarvix://libs/async']
               server: ['node://async']
            , (err, paths)->
                  
                  #self.assertEqual 'ciao', 'ciao'
                  'x'.should.equal 'x'
                  # common tests.
                  jx.test.expect(err).to.be.null
                  jx.test.expect(paths).to.be.an 'array'
   
                  # nodejs tests.
                  if jx.utility.is_nodejs()
                     jx.test.expect(paths[0]).to.eql 'async'
                  
                  # browser tests.
                  else if jx.utility.is_browser()
                     jx.test.expect(paths[0]).to.eql 'scripts/libs/jarvix/libs/async'
                     
               

      @.it 'adds paramters for caching purposes', (done)->
         jx.library.config jx, module: cache: false, (err, jx)->
            
            # nodejs tests.
            if jx.utility.is_nodejs()
               jx.test.expect(jx.module.options.cache).to.be.true
               done()
   
            # browser tests.
            else if jx.utility.is_browser()
               jx.module.resolve_paths ['jarvix://libs/async'], (err, paths)->
                  jx.test.expect(err).to.be.null
                  require = jx.module.options.requirejs
                  path = require.toUrl paths[0]
                  jx.test.expect(require.s.contexts._.config.urlArgs).to.contain 'v='
                  jx.test.expect(jx.string.contains(path, '?v=')).to.be.true
      
                  done()
                  
            