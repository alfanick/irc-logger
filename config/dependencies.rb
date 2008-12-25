# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = nil # Use the newest version
dm_gems_version   = nil # Use the newest version

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args"
dependency "merb-assets"
dependency "merb-cache" 
dependency "merb-helpers"
dependency "merb-mailer"
dependency "merb-slices"
dependency "merb-auth-core"
dependency "merb-auth-more"
dependency "merb-auth-slice-password"
dependency "merb-param-protection"
dependency "merb-exceptions"
 
dependency "dm-core"         
dependency "dm-aggregates" 
dependency "dm-migrations"
dependency "dm-timestamps"
dependency "dm-types"      
dependency "dm-validations"
#dependency "dm-is-searchable"
#gem "shanna-dm-sphinx-adapter"
require "dm-sphinx-adapter"

dependency "haml"

gem "net-yail"
